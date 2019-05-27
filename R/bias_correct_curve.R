#' @importFrom stats approx
bias_correct_curve <- function(x, pcurve, ...) {
  # bias correction, as suggested by Jeff Banfield
  ones <- rep(1, ncol(x))
  sbar <- colMeans(pcurve$s)
  ray <- drop(sqrt(((x - pcurve$s)^2) %*% ones))
  dist1 <- (scale(x, sbar, FALSE)^2) %*% ones
  dist2 <- (scale(pcurve$s, sbar, FALSE)^2) %*% ones
  sign <- 2 * as.double(dist1 > dist2) - 1
  ray <- sign * ray

  ploess <- periodic_lowess(pcurve$lambda, ray, ...)
  sray <- stats::approx(
    ploess$x,
    ploess$y,
    pcurve$lambda,
    ties = "ordered"
  )$y

  pcurve$s <- pcurve$s + (abs(sray) / ray) * (x - pcurve$s)
  project_to_curve(x, pcurve$s[pcurve$ord, , drop = FALSE], stretch = 0)
}
