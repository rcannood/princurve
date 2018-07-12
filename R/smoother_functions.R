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
