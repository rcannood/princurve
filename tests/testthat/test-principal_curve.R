context("Testing principal_curve")


z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)

test_that("Testing principal_curve with smooth_spline", {
  fit <- principal_curve(x, smoother = "smooth_spline")

  pdf("/dev/null", 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$tag, seq_len(100))), .99)
})

test_that("Testing principal_curve with lowess", {
  fit <- principal_curve(x, smoother = "lowess")

  pdf("/dev/null", 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$tag, seq_len(100))), .99)
})


test_that("Testing principal.curve for backward compatibility", {
  expect_warning({
    fit <- principal.curve(x, smoother = "smooth.spline")
  }, "deprecated")

  pdf("/dev/null", 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$tag, seq_len(100))), .99)
})


z <- seq(0, 2 * pi, length.out = 100)
s <- cbind(cos(z), sin(z), 2 * cos(z), 3 * sin(z))
x <- s + rnorm(length(s), mean = 0, sd = .005)

test_that("Testing principal_curve with periodic_lowess", {
  fit <- principal_curve(x, smoother = "periodic_lowess")

  pdf("/dev/null", 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
})
