context("Testing principal_curve")

z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)

file <- tempfile(fileext = ".png")

on.exit(file.remove(file))

test_that("Testing principal_curve with smooth_spline", {
  pdf(file, 5, 5)
  sink(file)
  fit <- principal_curve(x, smoother = "smooth_spline", plot_iterations = TRUE, trace = TRUE)
  sink()
  dev.off()

  pdf(file, 5, 5)
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


test_that("Testing principal_curve returns same results with approx optimisation", {
  fit <- principal_curve(x)
  fit2 <- principal_curve(x, approx_points = 66)

  expect_gte(cor(as.vector(fit$s), as.vector(fit2$s)), .99)
  expect_gte(abs(cor(order(fit$ord), order(fit2$ord))), .99)
  expect_gte(abs(cor(fit$lambda, fit2$lambda)), .99)
})

test_that("Testing principal_curve with custom function", {
  fun <- function(lambda, xj, ...) {
    stats::lowess(lambda, xj, ...)$y
  }

  pdf(file, 5, 5)
  fit <- principal_curve(x, smoother = fun, plot_iterations = TRUE)
  dev.off()

  pdf(file, 5, 5)
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

  pdf(file, 5, 5)
  fit <- principal_curve(x, smoother = "smooth_spline", start = start, plot_iterations = TRUE)
  dev.off()

  pdf(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$ord, seq_len(100))), .99)
})

test_that("Expect principal_curve to error elegantly", {
  expect_error(principal_curve(list(1)), "must be a matrix")
  expect_error(principal_curve(x, stretch = -1), "larger than or equal to 0")
  expect_error(principal_curve(x, stretch = "10"))
  expect_error(principal_curve(x, start = "10"), "should be a matrix or principal")
})

test_that("Testing principal_curve with lowess", {
  fit <- principal_curve(x, smoother = "lowess")

  pdf(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(abs(cor(fit$ord, seq_len(100))), .99)
})

z <- seq(0, 2 * pi, length.out = 100)
s <- cbind(cos(z), sin(z), 2 * cos(z), 3 * sin(z))
x <- s + rnorm(length(s), mean = 0, sd = .005)

test_that("Testing principal_curve with periodic_lowess", {
  fit <- principal_curve(x, smoother = "periodic_lowess")

  pdf(file, 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
})

test_that("principal_curve does not produce NAs when checking for convergence", {
  mat <- matrix(rep(seq(1, 11, 1), 3), ncol = 3)
  fit <- principal_curve(mat)
  expect_lte(sum((fit$s - mat)^2), 1e-10)
})



test_that("principal_curve keeps rownames and colnames", {
  mat <- matrix(runif(100), ncol = 4)
  rownames(mat) <- seq_len(25)
  fit <- principal_curve(mat)
  expect_equal(dimnames(fit$s), dimnames(mat))

  colnames(mat) <- LETTERS[1:4]
  fit <- principal_curve(mat)
  expect_equal(dimnames(fit$s), dimnames(mat))

  rownames(mat) <- NULL
  fit <- principal_curve(mat)
  expect_equal(dimnames(fit$s), dimnames(mat))

  colnames(mat) <- NULL
  fit <- principal_curve(mat)
  expect_equal(dimnames(fit$s), dimnames(mat))
})

