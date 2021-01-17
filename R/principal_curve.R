#' Fit a Principal Curve
#'
#' Fit a principal curve which describes a smooth curve that passes through the \code{middle}
#' of the data \code{x} in an orthogonal sense. This curve is a non-parametric generalization
#' of a linear principal component. If a closed curve is fit (using \code{smoother = "periodic_lowess"})
#' then the starting curve defaults to a circle, and each fit is followed by a bias correction
#' suggested by Jeff Banfield.
#'
#' @param x a matrix of points in arbitrary dimension.
#' @param start either a previously fit principal curve, or else a matrix
#'   of points that in row order define a starting curve. If missing or NULL,
#'   then the first principal component is used.  If the smoother is
#'   \code{"periodic_lowess"}, then a circle is used as the start.
#' @param thresh convergence threshold on shortest distances to the curve.
#' @param plot_iterations If \code{TRUE} the iterations are plotted.
#' @param maxit maximum number of iterations.
#' @param stretch A stretch factor for the endpoints of the curve,
#'   allowing the curve to grow to avoid bunching at the end.
#'   Must be a numeric value between 0 and 2.
#' @param smoother choice of smoother. The default is
#'   \code{"smooth_spline"}, and other choices are \code{"lowess"} and
#'   \code{"periodic_lowess"}. The latter allows one to fit closed curves.
#'   Beware, you may want to use \code{iter = 0} with \code{lowess()}.
#' @param approx_points Approximate curve after smoothing to reduce computational time.
#'   If \code{FALSE}, no approximation of the curve occurs. Otherwise,
#'   \code{approx_points} must be equal to the number of points the curve
#'   gets approximated to; preferably about 100.
#' @param trace If \code{TRUE}, the iteration information is printed
#' @param ... additional arguments to the smoothers
#'
#' @return An object of class \code{"principal_curve"} is returned. For this object
#'   the following generic methods a currently available: \code{plot, points, lines}.
#'
#'   It has components:
#'     \item{s}{a matrix corresponding to \code{x}, giving their projections
#'       onto the curve.}
#'   \item{ord}{an index, such that \code{s[order, ]} is smooth.}
#'   \item{lambda}{for each point, its arc-length from the beginning of the
#'     curve. The curve is parametrized approximately by arc-length, and
#'     hence is \code{unit-speed}.}
#'   \item{dist}{the sum-of-squared distances from the points to their
#'     projections.}
#'   \item{converged}{A logical indicating whether the algorithm converged
#'     or not.}
#'   \item{num_iterations}{Number of iterations completed before returning.}
#'   \item{call}{the call that created this object; allows it to be
#'     \code{updated()}.}
#'
#' @seealso \code{\link{project_to_curve}}
#'
#' @keywords regression smooth nonparametric
#'
#' @references
#'  Hastie, T. and Stuetzle, W.,
#'  \href{https://www.jstor.org/stable/2289936}{Principal Curves},
#'  JASA, Vol. 84, No. 406 (Jun., 1989), pp. 502-516,
#'  \doi{10.2307/2289936}
#'  (\href{https://web.stanford.edu/~hastie/Papers/principalcurves.pdf}{PDF}).
#'
#' @export
#'
#' @include smoother_functions.R
#'
#' @importFrom stats lowess smooth.spline predict var
#' @importFrom grDevices extendrange
#'
#' @examples
#' x <- runif(100,-1,1)
#' x <- cbind(x, x ^ 2 + rnorm(100, sd = 0.1))
#' fit <- principal_curve(x)
#' plot(fit)
#' lines(fit)
#' points(fit)
#' whiskers(x, fit$s)
principal_curve <- function(
  x,
  start = NULL,
  thresh = 0.001,
  maxit = 10,
  stretch = 2,
  smoother = names(smoother_functions),
  approx_points = FALSE,
  trace = FALSE,
  plot_iterations = FALSE,
  ...
) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments:
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Check 'x'
  if (!is.matrix(x)) {
    stop("Argument ", sQuote("x"), " must be a matrix.")
  }

  # Check 'smoother'
  if (is.function(smoother)) {
    smoother_function <- smoother
    bias_correct_curve <- FALSE
  } else if (is.character(smoother)) {
    # substitute .'s to _'s for backwards compatibility
    smoother <- gsub(".", "_", smoother, fixed = TRUE)
    smoother <- match.arg(smoother)
    smoother_function <- smoother_functions[[smoother]]

    if (smoother == "periodic_lowess") {
      stretch <- 0
      bias_correct_curve <- TRUE
    } else {
      bias_correct_curve <- FALSE
    }
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Setup
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  function_call <- match.call()
  dist_old <- sum(diag(stats::var(x)))

  # You can give starting values for the curve
  if (missing(start) || is.null(start)) {
    # use largest principal component
    if (is.character(smoother) && smoother == "periodic_lowess") {
      start <- start_circle(x)
    } else {
      xbar <- colMeans(x)
      xstar <- scale(x, center = xbar, scale=FALSE)
      svd_xstar <- svd(xstar)
      dd <- svd_xstar$d
      lambda <- svd_xstar$u[,1] * dd[1]
      ord <- order(lambda)
      s <- scale(outer(lambda, svd_xstar$v[,1]), center = -xbar, scale = FALSE)
      dimnames(s) <- dimnames(x)
      dist <- sum((dd^2)[-1]) * nrow(x)
      start <- list(s = s, ord = ord, lambda = lambda, dist = dist)
    }
  } else if (!inherits(start, "principal_curve")) {
    # use given starting curve
    if (is.matrix(start)) {
      start <- project_to_curve(x = x, s = start, stretch = stretch)
    } else {
      stop("Invalid starting curve: should be a matrix or principal_curve")
    }
  }

  pcurve <- start

  if (plot_iterations) {
    plot(
      x[,1:2],
      xlim = grDevices::extendrange(x[,1], f = .2),
	    ylim = grDevices::extendrange(x[,2], f = .2)
    )
    lines(pcurve$s[pcurve$ord, 1:2])
  }

  it <- 0
  if (trace) {
    cat("Starting curve---distance^2: ", pcurve$dist, "\n", sep="")
  }

  # Pre-allocate nxp matrix 's'
  s <- matrix(
    as.double(NA),
    nrow = ifelse(approx_points > 0, approx_points, nrow(x)),
    ncol = ncol(x),
    dimnames = list(NULL, colnames(x))
  )

  has_converged <- abs(dist_old - pcurve$dist) <= thresh * dist_old
  while (!has_converged && it < maxit) {
    it <- it + 1

    if (approx_points > 0) {
      sort_lambda <- sort(pcurve$lambda)
      xout_lambda <- seq(sort_lambda[[1]], sort_lambda[[length(sort_lambda)]], length.out = approx_points)
    }

    for (jj in seq_len(ncol(x))) {
      # Smooth (lambda, x)
      yjj <- smoother_function(pcurve$lambda, x[,jj], ...)

      # If requested, approximate the smoothed curve to reduce computational complexity
      if (approx_points > 0) {
        yjj <- stats::approx(x = sort_lambda, y = yjj, xout = xout_lambda, ties = "ordered")$y
      }

      # Store curve
      s[,jj] <- yjj
    }

    dist_old <- pcurve$dist

    # Finds the "projection index" for a matrix of points 'x',
    pcurve <- project_to_curve(x = x, s = s, stretch = stretch)

    # Bias correct
    if (bias_correct_curve) {
      pcurve <- bias_correct_curve(x = x, pcurve = pcurve, ...)
    }

    # Converged
    has_converged <- abs(dist_old - pcurve$dist) <= thresh * dist_old

    if (plot_iterations) {
      plot(
        x[,1:2],
        xlim = grDevices::extendrange(x[,1], f = .2),
        ylim = grDevices::extendrange(x[,2], f = .2)
      )
      lines(pcurve$s[pcurve$ord, 1:2])
    }

    if (trace) {
      cat("Iteration ", it, "---distance^2: ", pcurve$dist, "\n", sep="")
    }
  }

  # Return fit
  out <- list(
    s = pcurve$s,
    ord = pcurve$ord,
    lambda = pcurve$lambda,
    dist = pcurve$dist,
    converged = has_converged,
    num_iterations = as.integer(it),
    call = function_call
  )
  class(out) <- "principal_curve"
  out
}

formals(principal_curve)$smoother <- names(smoother_functions)

#' @rdname principal_curve
#' @export
#' @importFrom graphics lines
lines.principal_curve <- function(x, ...) {
  ord <- x[["ord"]]
  graphics::lines(x$s[ord, ], ...)
}

#' @rdname principal_curve
#' @export
#' @importFrom graphics plot
plot.principal_curve <- function(x, ...) {
  ord <- x[["ord"]]
  graphics::plot(x$s[ord, ], ..., type = "l")
}

#' @rdname principal_curve
#' @export
#' @importFrom graphics points
points.principal_curve <- function(x, ...) {
  graphics::points(x$s, ...)
}

#' @rdname principal_curve
#' @param s a parametrized curve, represented by a polygon.
#' @importFrom graphics segments
#' @export
whiskers <- function(x, s, ...) {
  graphics::segments(x[, 1], x[, 2], s[, 1], s[, 2], ...)
}
