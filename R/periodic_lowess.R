#' @importFrom stats lowess approx
periodic_lowess <- function(x, y, f = 0.59999999999999998, ...) {
  n <- length(x)
  o <- order(x)
  r <- range(x)

  d <- diff(r) / (length(unique(x)) - 1)
  xr <- x[o[1 : (n/2)]] - r[1] + d + r[2]
  xl <- x[o[(n/2) : n]] - r[2] - d + r[1]
  yr <- y[o[1 : (n/2)]]
  yl <- y[o[(n/2) : n]]

  xnew <- c(xl, x, xr)
  ynew <- c(yl, y, yr)

  f <- f / 2
  fit <- stats::lowess(xnew, ynew, f = f, ...)
  stats::approx(fit$x, fit$y, x[o], rule = 2, ties = "ordered")
}
