context("Testing principal_curve")

z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)

file <- tempfile(fileext = ".svg")
on.exit(unlink(file))

test_that("Testing principal_curve with smooth_spline", {
  svg(file, 5, 5)
  sink(file)
  fit <- principal_curve(x, smoother = "smooth_spline", plot_iterations = TRUE, trace = TRUE)
  sink()
  dev.off()

  svg(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
    lines(fit)
    whiskers(x = x, s = fit$s)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$ord, seq_len(100))), .99)
})

test_that("Testing principal_curve with custom function", {
  fun <- function(lambda, xj, ...) {
    stats::lowess(lambda, xj, ...)$y
  }

  svg(file, 5, 5)
  fit <- principal_curve(x, smoother = fun, plot_iterations = TRUE)
  dev.off()

  svg(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$ord, seq_len(100))), .99)
})


test_that("Testing principal_curve with a given start curve", {
  start <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1), ncol = 4, byrow = TRUE)

  svg(file, 5, 5)
  fit <- principal_curve(x, smoother = "smooth_spline", start = start, plot_iterations = TRUE)
  dev.off()

  svg(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$ord, seq_len(100))), .99)
})

test_that("Expect principal_curve to error elegantly", {
  expect_error(principal_curve(list(1)))
  expect_error(principal_curve(x, stretch = -1), "larger than or equal to 0")
  expect_error(principal_curve(x, stretch = "10"))
  expect_error(principal_curve(x, start = "10"), "should be a matrix or principal_curve")
})

test_that("Testing principal_curve with lowess", {
  fit <- principal_curve(x, smoother = "lowess")

  svg(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$ord, seq_len(100))), .99)
})


test_that("Testing principal.curve for backward compatibility", {
  # expect_warning({
  fit <- principal.curve(x, smoother = "smooth.spline")
  # }, "deprecated")

  svg(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
    lines(fit)
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

  svg(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
})
