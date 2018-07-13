#' Smoother functions
#'
#' Each of these functions have an interface \code{function(lambda, xj, ...)}, and
#' return smoothed values for xj. The output is expected to be ordered along an ordered lambda.
#' This means that the following is true:
#' \preformatted{
#' x <- runif(100)
#' y <- runif(100)
#' ord <- sample.int(100)
#' sfun <- smoother_functions[[1]]
#' all(sfun(x, y) == sfun(x[ord], y[ord]))
#' }
smoother_functions <- list(
  smooth_spline = function(lambda, xj, ..., df = 5) {
    ord <- order(lambda)
    lambda <- lambda[ord]
    xj <- xj[ord]
    fit <- stats::smooth.spline(lambda, xj, ..., df = df, keep.data = FALSE)
    stats::predict(fit, x = lambda)$y
  },

  lowess = function(lambda, xj, ...) {
    stats::lowess(lambda, xj, ...)$y
  },

  periodic_lowess = function(lambda, xj, ...) {
    periodic_lowess(lambda, xj, ...)$y
  }
)
