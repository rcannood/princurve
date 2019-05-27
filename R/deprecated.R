#' Deprecated functions
#'
#' This function is deprecated, please use
#' \code{\link{principal_curve}} and \code{\link{project_to_curve}} instead.
#'
#' @param x x
#' @param start start
#' @param thresh thresh
#' @param plot.true plot.true
#' @param maxit maxit
#' @param stretch stretch
#' @param smoother smoother
#' @param trace trace
#' @param s s
#' @param tag tag
#' @param ... ...
#'
#' @rdname deprecated
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
  .Defunct("principal_curve", package = "princurve")
}


#' @rdname deprecated
#' @export
lines.principal.curve <- function(x, ...) {
  .Defunct("lines.principal_curve", package = "princurve")
}

#' @rdname deprecated
#' @export
plot.principal.curve <- function(x, ...) {
  .Defunct("plot.principal_curve", package = "princurve")
}

#' @rdname deprecated
#' @export
points.principal.curve <- function(x, ...) {
  .Defunct("points.principal_curve", package = "princurve")
}

#' @rdname deprecated
#' @export
get.lam <- function(
  x,
  s,
  tag = NULL,
  stretch = 2
) {
  .Defunct("project_to_curve", package = "princurve")
}

