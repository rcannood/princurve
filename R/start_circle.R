#' Generate circle as initial curve
#'
#' The starting circle is defined in the first two dimensions,
#' and has zero values in all other dimensions.
#'
#' @param x The data for which to generate the initial circle
#'
#' @examples
#' \dontrun{
#' x <- cbind(
#'   rnorm(100, 1, .2),
#'   rnorm(100, -5, .2),
#'   runif(100, 1.9, 2.1),
#'   runif(100, 2.9, 3.1)
#' )
#' circ <- start_circle(x)
#' plot(x)
#' lines(circ)
#' }
start_circle <- function(x) {
  n_points <- 360 # number of points to generate for the initial_s

  xbar <- colMeans(x)
  radius <- colMeans(abs(sweep(x, 2, xbar)))
  theta <- pi * seq_len(n_points) * 2 / n_points

  initial_s <- cbind(radius[[1]] * sin(theta) + xbar[[1]], radius[[2]] * cos(theta) + xbar[[2]])

  if (ncol(x) > 2) {
    initial_s <- cbind(initial_s, matrix(rep(xbar[-1:-2], n_points), nrow = n_points, byrow = TRUE))
  }

  project_to_curve(x = x, s = initial_s, stretch = 0)
}
