#' @importFrom stats approx
approx_sorted <- function(x, y, xout, ...) {
  if (any(duplicated(x))) {
    x <- x + seq(-1e-50, 1e-50, length.out = length(x))
  }

  stats::approx(x = x, y = y, xout = xout, ...)
}
