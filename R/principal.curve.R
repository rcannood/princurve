"bias.correct.curve" <- function(x, pcurve, ...)
{
# bias correction, as suggested by
#Jeff Banfield
  p <- ncol(x)
  ones <- rep(1, p)
  sbar <- apply(pcurve$s, 2, "mean")
  ray <- drop(sqrt(((x - pcurve$s)^2) %*% ones))
  dist1 <- (scale(x, sbar, FALSE)^2) %*% ones
  dist2 <- (scale(pcurve$s, sbar, FALSE)^2) %*% ones
  sign <- 2 * as.double(dist1 > dist2) - 1
  ray <- sign * ray
  sray <- approx(periodic.lowess(pcurve$lambda, ray, ...)$x,
		 periodic.lowess(pcurve$lambda, ray, ...)$y,
		 pcurve$lambda)$y
  ## AW: changed periodic.lowess() to periodic.lowess()$x and $y
  pcurve$s <- pcurve$s + (abs(sray)/ray) * ((x - pcurve$s))
  get.lam(x, pcurve$s, pcurve$tag, stretch = 0)
}


"get.lam" <- function(x, s, tag, stretch = 2)
{
  storage.mode(x) <- "double"
  storage.mode(s) <- "double"
  storage.mode(stretch) <- "double"
  if(!missing(tag))
    s <- s[tag,  ]
  np <- dim(x)
  if(length(np) != 2)
    stop("get.lam needs a matrix input")
  n <- np[1]
  p <- np[2]
  tt <- .Fortran("getlam",
		 n,
		 p,
		 x,
		 s = x,
		 lambda = double(n),
		 tag = integer(n),
		 dist = double(n),
		 as.integer(nrow(s)),
		 s,
		 stretch,
		 double(p),
		 double(p),
                 PACKAGE = "princurve")[c("s", "tag", "lambda", "dist")]
  tt$dist <- sum(tt$dist)
  class(tt) <- "principal.curve"
  tt
}


"lines.principal.curve" <- function(x, ...)
  lines(x$s[x$tag,  ], ...)


"periodic.lowess"<- function(x, y, f = 0.59999999999999998, ...)
{
  n <- length(x)
  o <- order(x)
  r <- range(x)
  d <- diff(r)/(length(unique(x)) - 1)
  xr <- x[o[1:(n/2)]] - r[1] + d + r[2]
  xl <- x[o[(n/2):n]] - r[2] - d + r[1]
  yr <- y[o[1:(n/2)]]
  yl <- y[o[(n/2):n]]
  xnew <- c(xl, x, xr)
  ynew <- c(yl, y, yr)
  f <- f/2
  fit <- lowess(xnew, ynew, f = f, ...)
  approx(fit$x, fit$y, x[o], rule = 2)
  # AW: changed fit to fit$x, fit$y
}


"plot.principal.curve" <- function(x, ...)
  plot(x$s[x$tag,  ], ..., type = "l")


"points.principal.curve" <- function(x, ...)
  points(x$s, ...)

principal.curve <- function(x, start=NULL, thresh=0.001, plot.true=FALSE, maxit=10, stretch=2, smoother="smooth.spline", trace=FALSE, ...) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments:
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument 'smoother':
  if (is.function(smoother)) {
    smootherFcn <- smoother;
  } else {
    smooth.list <- c("smooth.spline", "lowess", "periodic.lowess");
    smoother <- match.arg(smoother, smooth.list);
    smootherFcn <- NULL;
  }

  # Argument 'stretch':
  stretches <- c(2, 2, 0);
  if (is.function(smoother)) {
    if (is.null(stretch))
      stop("Argument 'stretch' must be given if 'smoother' is a function.");
  } else {
    if(missing(stretch) || is.null(stretch)) {
      stretch <- stretches[match(smoother, smooth.list)];
    }
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Setup
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (is.null(smootherFcn)) {
    # Setup the smoother function smootherFcn(lambda, xj, ...) which must
    # return fitted {y}:s.
    smootherFcn <- switch(smoother,
      lowess = function(lambda, xj, ...) {
        lowess(lambda, xj, ...)$y;
      },

      smooth.spline = function(lambda, xj, ..., df=5) {
        o <- order(lambda);
        lambda <- lambda[o];
        xj <- xj[o];
        fit <- smooth.spline(lambda, xj, ..., df=df, keep.data=FALSE);
        predict(fit, x=lambda)$y;
      },

      periodic.lowess = function(lambda, xj, ...) {
        periodic.lowess(lambda, xj, ...)$y;
      }
    ) # smootherFcn()

    # Should the fitted curve be bias corrected (in each iteration)?
    biasCorrectCurve <- (smoother == "periodic.lowess");
  } else {
    biasCorrectCurve <- FALSE;
  }

  this.call <- match.call()
  dist.old <- sum(diag(var(x)))
  d <- dim(x)
  n <- d[1]
  p <- d[2]

  # You can give starting values for the curve
  if (missing(start) || is.null(start)) {
    # use largest principal component
    if (is.character(smoother) && smoother == "periodic.lowess") {
      start <- startCircle(x)
    } else {
      xbar <- colMeans(x)
      xstar <- scale(x, center=xbar, scale=FALSE)
      svd.xstar <- svd(xstar)
      dd <- svd.xstar$d
      lambda <- svd.xstar$u[,1] * dd[1]
      tag <- order(lambda)
      s <- scale(outer(lambda, svd.xstar$v[,1]), center=-xbar, scale=FALSE)
      dist <- sum((dd^2)[-1]) * n
      start <- list(s=s, tag=tag, lambda=lambda, dist=dist)
    }
  } else if (!inherits(start, "principal.curve")) {
    # use given starting curve
    if (is.matrix(start)) {
      start <- get.lam(x, s=start, stretch=stretch)
    } else {
      stop("Invalid starting curve: should be a matrix or principal.curve")
    }
  }

  pcurve <- start
  if (plot.true) {
    plot(x[,1:2], xlim=adjust.range(x[,1], 1.3999999999999999),
	 ylim=adjust.range(x[,2], 1.3999999999999999))
    lines(pcurve$s[pcurve$tag, 1:2])
  }

  it <- 0
  if (trace) {
    cat("Starting curve---distance^2: ", pcurve$dist, "\n", sep="");
  }

  # Pre-allocate nxp matrix 's'
  naValue <- as.double(NA);
  s <- matrix(naValue, nrow=n, ncol=p);

  hasConverged <- (abs((dist.old - pcurve$dist)/dist.old) <= thresh);
  while (!hasConverged && it < maxit) {
    it <- it + 1;

    for(jj in 1:p) {
      s[,jj] <- smootherFcn(pcurve$lambda, x[,jj], ...);
    }

    dist.old <- pcurve$dist;


    # Finds the "projection index" for a matrix of points 'x',
    # when projected onto a curve 's'.  The projection index,
    # \lambda_f(x) [Eqn (3) in Hastie & Stuetzle (1989), is
    # the value of \lambda for which f(\lambda) is closest
    # to x.
    pcurve <- get.lam(x, s=s, stretch=stretch);

    # Bias correct?
    if (biasCorrectCurve)
      pcurve <- bias.correct.curve(x, pcurve=pcurve, ...)

    # Converged?
    hasConverged <- (abs((dist.old - pcurve$dist)/dist.old) <= thresh);

    if (plot.true) {
      plot(x[,1:2], xlim=adjust.range(x[,1], 1.3999999999999999), ylim=adjust.range(x[,2], 1.3999999999999999))
      lines(pcurve$s[pcurve$tag, 1:2])
    }

    if (trace) {
      cat("Iteration ", it, "---distance^2: ", pcurve$dist, "\n", sep="");
    }
  } # while()

  # Return fit
  structure(list(
    s = pcurve$s,
    tag = pcurve$tag,
    lambda = pcurve$lambda,
    dist = pcurve$dist,
    converged = hasConverged,         # Added by HB
    nbrOfIterations = as.integer(it), # Added by HB
    call = this.call
  ), class="principal.curve");
} # principal.curve.hb()

###########################################################################
# HISTORY:
# 2009-07-15
# o MEMORY OPTIMIZATION: Now the result matrix allocated as doubles, not
#   logicals (as NA is), in order to prevent a coersion.
# 2009-02-08
# o BUG FIX: An error was thrown if 'smoother' was a function.
# o Cleaned up source code (removed comments).
# 2008-05-27
# o Benchmarking: For larger data sets, most of the time is spent in
#   get.lam().
# o BUG FIX: smooth.spline(x,y) will only use *and* return values for
#   "unique" {x}:s. This means that the fitted {y}:s maybe be fewer than
#   the input vector. In order to control for this, we use predict().
# o Now 'smoother' can also be a function taking arguments 'lambda', 'xj'
#   and '...' and return 'y' of the same length as 'lambda' and 'xj'.
# o Now arguments 'start' and 'stretch' can be NULL, which behaves the
#   same as if they are "missing" [which is hard to emulate with for
#   instance do.call()].
# o Added 'converged' and 'nbrOfIterations' to return structure.
# o SPEED UP/MEMORY OPTIMIZATION: Now the nxp matrix 's' is allocated only
#   once. Before it was built up using cbind() once per iteration.
# o SPEED UP: Now the smoother function is identified/created before
#   starting the algorithm, and not once per dimension and iteration.
###########################################################################

adjust.range <- function (x, fact)
  {
# AW: written by AW, replaces ylim.scale
    r <- range (x);
    d <- diff(r)*(fact-1)/2;
    c(r[1]-d, r[2]+d)
  }


"startCircle" <- function(x)
{
# the starting circle uses the first two co-ordinates,
# and assumes the others are zero
  d <- dim(x)
  n <- d[1]
  p <- d[2]	# use best circle centered at xbar
  xbar <- apply(x, 2, "mean")
  ray <- sqrt((scale(x, xbar, FALSE)^2) %*% rep(1, p))
  radius <- mean(ray)
  s <- cbind(radius * sin((pi * (1:101))/50),
	     radius * cos((pi * (1:101))/50))
  if(p > 2)
    s <- cbind(s, matrix(rep(0, n * (p-2)), nrow = n, ncol = p - 2))
  get.lam(x, s)
}
