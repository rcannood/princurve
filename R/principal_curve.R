#' @importFrom stats approx
bias.correct.curve <- function(x, pcurve, ...) {
  # bias correction, as suggested by Jeff Banfield
  p <- ncol(x)
  ones <- rep(1, p)
  sbar <- apply(pcurve$s, 2, "mean")
  ray <- drop(sqrt(((x - pcurve$s)^2) %*% ones))
  dist1 <- (scale(x, sbar, FALSE)^2) %*% ones
  dist2 <- (scale(pcurve$s, sbar, FALSE)^2) %*% ones
  sign <- 2 * as.double(dist1 > dist2) - 1
  ray <- sign * ray
  ploess <- periodic_lowess(pcurve$lambda, ray, ...)
  sray <- stats::approx(
    ploess$x,
    ploess$y,
		pcurve$lambda
  )$y
  ## AW: changed periodic_lowess() to periodic_lowess()$x and $y
  pcurve$s <- pcurve$s + (abs(sray)/ray) * ((x - pcurve$s))
  get.lam(x, pcurve$s, pcurve$tag, stretch = 0)
}



#' Fit a Principal Curve
#'
#' Fits a principal curve which describes a smooth curve that passes through the \code{middle}
#' of the data \code{x} in an orthogonal sense.  This curve is a nonparametric generalization
#' of a linear principal component.  If a closed curve is fit (using \code{smoother = "periodic_lowess"})
#' then the starting curve defaults to a circle, and each fit is followed by a bias correction
#' suggested by Jeff Banfield.
#'
#' @param x a matrix of points in arbitrary dimension.
#' @param start either a previously fit principal curve, or else a matrix
#'   of points that in row order define a starting curve. If missing or NULL,
#'   then the first principal component is used.  If the smoother is
#'   \code{"periodic_lowess"}, then a circle is used as the start.
#' @param thresh convergence threshold on shortest distances to the curve.
#' @param plot.true If \code{TRUE} the iterations are plotted.
#' @param maxit maximum number of iterations.
#' @param stretch a factor by which the curve can be extrapolated when
#'   points are projected.  Default is 2 (times the last segment
#'   length). The default is 0 for \code{smoother} equal to
#'   \code{"periodic_lowess"}.
#' @param smoother choice of smoother. The default is
#'   \code{"smooth.spline"}, and other choices are \code{"lowess"} and
#'   \code{"periodic_lowess"}. The latter allows one to fit closed curves.
#'   Beware, you may want to use \code{iter = 0} with \code{lowess()}.
#' @param trace If \code{TRUE}, the iteration information is printed
#' @param ... additional arguments to the smoothers
#'
#' @return An object of class \code{"principal.curve"} is returned. For this object
#'   the following generic methods a currently available: \code{plot, points, lines}.
#'
#'   It has components:
#'     \item{s}{a matrix corresponding to \code{x}, giving their projections
#'       onto the curve.}
#'   \item{tag}{an index, such that \code{s[tag, ]} is smooth.}
#'   \item{lambda}{for each point, its arc-length from the beginning of the
#'     curve. The curve is parametrized approximately by arc-length, and
#'     hence is \code{unit-speed}.}
#'   \item{dist}{the sum-of-squared distances from the points to their
#'     projections.}
#'   \item{converged}{A logical indicating whether the algorithm converged
#'     or not.}
#'   \item{nbrOfIterations}{Number of iterations completed before returning.}
#'   \item{call}{the call that created this object; allows it to be
#'     \code{updated()}.}
#'
#' @seealso \code{\link{get.lam}}
#'
#' @keywords regression smooth nonparametric
#'
#' @references
#'   \dQuote{Principal Curves} by Hastie, T. and Stuetzle, W. 1989, JASA.
#'   See also Banfield and Raftery (JASA, 1992).
#'
#' @export
#'
#' @examples
#' x <- runif(100,-1,1)
#' x <- cbind(x, x ^ 2 + rnorm(100, sd = 0.1))
#' fit1 <- principal.curve(x, plot = TRUE)
#' fit2 <- principal.curve(x, plot = TRUE, smoother = "lowess")
#' lines(fit1)
#' points(fit1)
#' plot(fit1)
#' whiskers <- function(from, to)
#'   segments(from[, 1], from[, 2], to[, 1], to[, 2])
#' whiskers(x, fit1$s)
principal.curve <- function(
  x,
  start = NULL,
  thresh = 0.001,
  plot.true = FALSE,
  maxit = 10,
  stretch = 2,
  smoother = c("smooth_spline", "lowess", "periodic_lowess"),
  trace = FALSE,
  ...
) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments:
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument 'smoother':
  if (is.function(smoother)) {
    smootherFcn <- smoother
  } else {
    # substitute .'s to _'s for backwards compatibility
    smoother <- match.arg(gsub("\\.", "_", smoother))
    smootherFcn <- NULL
  }

  # Argument 'stretch':
  stretches <- c(smooth_spline = 2, lowess = 2, periodic_lowess = 0)
  if (is.function(smoother)) {
    if (is.null(stretch))
      stop("Argument 'stretch' must be given if 'smoother' is a function.")
  } else {
    if (missing(stretch) || is.null(stretch)) {
      stretch <- stretches[smoother]
    }
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Setup
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (is.null(smootherFcn)) {
    smootherFcn <- switch(smoother,
      lowess = function(lambda, xj, ...) {
        lowess(lambda, xj, ...)$y
      },

      smooth_spline = function(lambda, xj, ..., df=5) {
        o <- order(lambda)
        lambda <- lambda[o]
        xj <- xj[o]
        fit <- smooth.spline(lambda, xj, ..., df = df, keep.data = FALSE)
        predict(fit, x=lambda)$y
      },

      periodic_lowess = function(lambda, xj, ...) {
        periodic_lowess(lambda, xj, ...)$y
      }

    # Should the fitted curve be bias corrected (in each iteration)?
    bias_correct_curve <- (smoother == "periodic_lowess")
  } else {
    bias_correct_curve <- FALSE
  }

  this.call <- match.call()
  dist.old <- sum(diag(var(x)))
  d <- dim(x)
  n <- d[1]
  p <- d[2]

  # You can give starting values for the curve
  if (missing(start) || is.null(start)) {
    # use largest principal component
    if (is.character(smoother) && smoother == "periodic_lowess") {
      start <- start_circle(x)
    } else {
      xbar <- colMeans(x)
      xstar <- scale(x, center=xbar, scale=FALSE)
      svd.xstar <- svd(xstar)
      dd <- svd.xstar$d
      lambda <- svd.xstar$u[,1] * dd[1]
      tag <- order(lambda)
      s <- scale(outer(lambda, svd.xstar$v[,1]), center = -xbar, scale = FALSE)
      dist <- sum((dd^2)[-1]) * nrow(x)
      start <- list(s = s, tag = tag, lambda = lambda, dist = dist)
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
    plot(
      x[,1:2],
      xlim = adjust.range(x[,1], 1.3999999999999999),
	    ylim = adjust.range(x[,2], 1.3999999999999999))
      lines(pcurve$s[pcurve$tag, 1:2]
    )
  }

  it <- 0
  if (trace) {
    cat("Starting curve---distance^2: ", pcurve$dist, "\n", sep="");
  }

  # Pre-allocate nxp matrix 's'
  naValue <- as.double(NA);
  s <- matrix(naValue, nrow=n, ncol=p);

  has_converged <- (abs((dist.old - pcurve$dist)/dist.old) <= thresh);
  while (!has_converged && it < maxit) {
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
    pcurve <- get.lam(x, s = s, stretch = stretch);

    # Bias correct?
    if (bias_correct_curve) {
      pcurve <- bias.correct.curve(x, pcurve = pcurve, ...)
    }

    # Converged?
    has_converged <- (abs((dist.old - pcurve$dist)/dist.old) <= thresh);

    if (plot.true) {
      plot(
        x[,1:2],
        xlim = adjust.range(x[,1], 1.3999999999999999),
        ylim = adjust.range(x[,2], 1.3999999999999999)
      )
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
    converged = has_converged,         # Added by HB
    nbrOfIterations = as.integer(it), # Added by HB
    call = this.call
  ), class = "principal.curve")
}


#' @rdname principal.curve
#' @export
lines.principal.curve <- function(x, ...)
  lines(x$s[x$tag,  ], ...)

#' @rdname principal.curve
#' @export
plot.principal.curve <- function(x, ...)
  plot(x$s[x$tag,  ], ..., type = "l")

#' @rdname principal.curve
#' @export
points.principal.curve <- function(x, ...)
  points(x$s, ...)


adjust.range <- function (x, fact) {
  # AW: written by AW, replaces ylim.scale
  r <- range(x)
  d <- diff(r) * (fact - 1) / 2
  c(r[1] - d, r[2] + d)
}

start_circle <- function(x) {
  # the starting circle uses the first two co-ordinates,
  # and assumes the others are zero
  d <- dim(x)

  xbar <- apply(x, 2, mean)
  ray <- sqrt((scale(x, xbar, FALSE)^2) %*% rep(1, ncol(p)))
  radius <- mean(ray)
  theta <- pi * seq_len(nrow(x)) * 2 / nrow(x)

  s <- cbind(radius * sin(theta), radius * cos(theta))

  if(ncol(x) > 2) {
    s <- cbind(s, matrix(0, nrow = nrow(x), ncol = ncol(x) - 2))
  }

  get.lam(x, s)
}
