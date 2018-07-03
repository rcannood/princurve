#' Project a set of points to the closest point on a curve
#'
#' Finds the projection index for a matrix of points \code{x}, when
#' projected onto a curve \code{s}. The curve need not be of the same
#' length as the number of points. If the points on the curve are not in
#' order, this order needs to be given as well, in \code{ord}.
#'
#' @param x a matrix of data points.
#' @param s a parametrized curve, represented by a polygon.
#' @param ord the order of the point in \code{s}. Default is the given order.
#' @param stretch A stretch factor for the endpoints of the curve,
#'   allowing the curve to grow to avoid bunching at the end.
#'   Must be a numeric value between 0 and 2.
#'
#' @return A structure is returned which represents a fitted curve.  It has components
#'   \item{s}{The fitted points on the curve corresponding to each point \code{x}}
#'   \item{ord}{the order of the fitted points}
#'   \item{lambda}{The projection index for each point}
#'   \item{dist}{The total squared distance from the curve}
#'   \item{dist_ind}{The squared distances from the curve to each of the respective points}
#'
#' @seealso \code{\link{principal_curve}}
#'
#' @keywords regression smooth nonparametric
#'
#' @export
project_to_curve <- function(
  x,
  s,
  ord = seq_len(nrow(s)),
  stretch = 2
) {
  if (!is.matrix(x)) {
    stop(sQuote("x"), " should be a matrix")
  }

  if (!is.matrix(s)) {
    stop(sQuote("s"), " should be a matrix")
  }

  # Check 'stretch'
  if (!is.numeric(stretch)) {
    stop("Argument ", sQuote("stretch"), " must be numeric.")
  }
  if (stretch < 0) {
    stop("Argument ", sQuote("stretch"), " should be larger than 0.")
  }
  if (stretch > 2) {
    stop("Argument ", sQuote("stretch"), " should be smaller than 2.")
  }

  s <- s[ord, , drop = F]

  out <- project_to_curve_cpp(x = x, s = s, stretch = stretch)

  class(out) <- "principal_curve"
  out
}

#' Projection Index
#'
#' This function will be deprecated on July 1st, 2018.
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
  tag,
  stretch = 2
) {
  # This function will be deprecated on July 1st, 2018
  # .Deprecated("project_to_curve", package = "princurve", old = "get.lam")

  out <- project_to_curve(x = x, s = s, ord = tag, stretch = stretch)
  out <- out[c("s", "ord", "lambda", "dist")]
  names(out) <- c("s", "tag", "lambda", "dist")
  out
}
