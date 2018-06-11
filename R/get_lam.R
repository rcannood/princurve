#' Projection Index
#'
#' Finds the projection index for a matrix of points \code{x}, when
#' projected onto a curve \code{s}.  The curve need not be of the same
#' length as the number of points.  If the points on the curve are not in
#' order, this order needs to be given as well, in \code{tag}.
#'
#' @param x a matrix of data points.
#' @param s a parametrized curve, represented by a polygon.
#' @param tag the order of the point in \code{s}. Default is the given order.
#' @param stretch A stretch factor for the endpoints of the curve; a maximum of 2.
#'  it allows the curve to grow, if required, and helps avoid bunching at the end.
#'
#' @return A structure is returned which represents a fitted curve.  It has components
#'   \item{s}{The fitted points on the curve corresponding to each point \code{x}.}
#'   \item{tag}{the order of the fitted points}
#'   \item{lambda}{The projection index for each point}
#'   \item{dist}{The total squared distance from the curve}
#'
#' @seealso \code{\link{principal_curve}}
#'
#' @keywords regression smooth nonparametric
#'
#' @export
get_lam <- function(
  x,
  s,
  tag,
  stretch = 2
) {
  storage.mode(x) <- "double"
  storage.mode(s) <- "double"
  storage.mode(stretch) <- "double"

  if (!missing(tag)) {
    s <- s[tag, ]
  }

  np <- dim(x)

  if (length(np) != 2) {
    stop("get_lam needs a matrix input")
  }

  n <- np[1]
  p <- np[2]
  tt <- .Fortran(
    "getlam",
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
    PACKAGE = "princurve"
  )
  tt <- tt[c("s", "tag", "lambda", "dist")]
  tt$dist <- sum(tt$dist)
  class(tt) <- "principal_curve"
  tt
}

#' [DEPRECATED] Projection Index
#'
#' See \code{\link{get_lam}}
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
  .Deprecated("get_lam", package = "princurve", old = "get.lam")
  get_lam(x = x, s = s, tag = tag, stretch = stretch)
}
