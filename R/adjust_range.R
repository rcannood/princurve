adjust_range <- function (x, fact) {
  # AW: written by AW, replaces ylim.scale
  r <- range(x)
  d <- diff(r) * (fact - 1) / 2
  c(r[1] - d, r[2] + d)
}
