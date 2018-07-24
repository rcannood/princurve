deprecation_date <- as.Date("2018-08-01")

#' Fit a Principal Curve
#'
#' This function will be deprecated on August 1st, 2018.
#' Use \code{\link{principal_curve}} instead.
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
#'   \code{"smooth_spline"}, and other choices are \code{"lowess"} and
#'   \code{"periodic_lowess"}. The latter allows one to fit closed curves.
#'   Beware, you may want to use \code{iter = 0} with \code{lowess()}.
#' @param trace If \code{TRUE}, the iteration information is printed
#' @param ... additional arguments to the smoothers
#'
#' @export
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
  # This function will be deprecated on August 1st, 2018
  if (Sys.Date() >= deprecation_date) {
    .Deprecated("principal_curve", package = "princurve", old = "principal.curve")
  }

  out <- principal_curve(
    x = x,
    start = start,
    thresh = thresh,
    maxit = maxit,
    stretch = stretch,
    smoother = smoother,
    trace = trace,
    plot_iterations = plot.true,
    ...
  )
  names(out)[[2]] <- "tag"
  names(out)[[6]] <- "nbrOfIterations"
  class(out) <- "principal.curve"
  out
}


#' @rdname principal.curve
#' @export
#' @include principal_curve.R
lines.principal.curve <- lines.principal_curve

#' @rdname principal.curve
#' @export
plot.principal.curve <- plot.principal_curve

#' @rdname principal.curve
#' @export
points.principal.curve <- points.principal_curve

