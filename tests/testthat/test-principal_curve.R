context("Testing principal_curve")


test_that("Testing principal_curve", {
  z <- seq(-1, 1, length.out = 100)

  s <- cbind(z, z^2)

  x <- s + rnorm(length(s), mean = 0, sd = .005)

  fit <- principal_curve(x)

  pdf("/dev/null", 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(cor(fit$tag, seq_len(100)), .99)
})


test_that("Testing principal.curve for backward compatibility", {
  z <- seq(-1, 1, length.out = 100)

  s <- cbind(z, z^2)

  x <- s + rnorm(length(s), mean = 0, sd = .005)

  fit <- principal.curve(x)

  pdf("/dev/null", 5, 5)
  expect_error({
    plot(fit)
    points(fit)
  }, NA)
  dev.off()

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(cor(fit$tag, seq_len(100)), .99)
})
