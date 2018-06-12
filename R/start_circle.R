# The starting circle uses the first two co-ordinates,
# and assumes the others are zero
start_circle <- function(x) {
  xbar <- apply(x, 2, mean)
  ray <- sqrt((scale(x, xbar, FALSE)^2) %*% rep(1, ncol(x)))
  radius <- mean(ray)
  theta <- pi * seq_len(nrow(x)) * 2 / nrow(x)

  s <- cbind(radius * sin(theta), radius * cos(theta))

  if(ncol(x) > 2) {
    s <- cbind(s, matrix(0, nrow = nrow(x), ncol = ncol(x) - 2))
  }

  project_to_curve(x, s)
}
