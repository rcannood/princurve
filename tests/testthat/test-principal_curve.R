context("Testing principal_curve")

z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)

file <- tempfile(fileext = ".svg")
on.exit(unlink(file))

test_that("Testing principal_curve with smooth_spline", {
  svg(file, 5, 5)
  fit <- principal_curve(x, smoother = "smooth_spline", plot_iterations = TRUE)
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

test_that("Expect principal_curve to error", {
  expect_error(principal_curve(list(1)), "matrix")
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
