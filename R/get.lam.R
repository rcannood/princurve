#' Projection Index
#'
#' This function will be deprecated on August 1st, 2018.
#' See \code{\link{project_to_curve}} instead.
#'
#' @param x a matrix of data points.
#' @param s a parametrized curve, represented by a polygon.
#' @param tag the order of the point in \code{s}. Default is the given order.
#' @param stretch A stretch factor for the endpoints of the curve; a maximum of 2.
#'  it allows the curve to grow, if required, and helps avoid bunching at the end.
#'
#' @export
get.lam <- function(
  x,
  s,
  tag = NULL,
  stretch = 2
) {
  # This function will be deprecated on August 1st, 2018
  if (Sys.Date() >= deprecation_date) {
    .Deprecated("project_to_curve", package = "princurve", old = "get.lam")
  }


  if (!is.null(tag)) {
    s <- s[tag, , drop = FALSE]
  }

  out <- project_to_curve(x = x, s = s, stretch = stretch)
  out <- out[c("s", "ord", "lambda", "dist")]
  names(out) <- c("s", "tag", "lambda", "dist")
  class(out) <- "principal.curve"
  out
}
