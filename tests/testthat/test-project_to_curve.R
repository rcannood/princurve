context("Testing project_to_curve")

z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)
ord <- sample.int(nrow(x))

test_that("Testing project_to_curve", {
  lam <- project_to_curve(
    x = x,
    s = s,
    stretch = 0
  )

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$ord, seq_len(100)), .99)
})

test_that("Expect project_to_curve to error", {
  expect_error(project_to_curve(list(1), list(1)), "matrix")
})


test_that("Testing get.lam for backwards compatibility", {
  # expect_warning({
  lam <- get.lam(
    x = x,
    s = s,
    stretch = 0
  )
  # }, "deprecated")

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$tag, seq_len(100)), .99)
})


test_that("Testing project_to_curve with shuffled order", {
  lam <- project_to_curve(
    x = x[ord,],
    s = s,
    stretch = 0
  )

  expect_gte(cor(as.vector(lam$s[lam$ord,]), as.vector(s)), .99)
  expect_gte(cor(order(lam$ord), ord), .99)
})

test_that("Values are more or less correct", {
  constant_s <- matrix(c(-1, 1, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  lam <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 0
  )

  expect_true(all(abs(lam$s[,1] - x[,1]) < 1e-6))
  expect_true(all(abs(lam$s[,2] - .1) < 1e-6))
  expect_true(all(abs(lam$s[,3] - .2) < 1e-6))
  expect_true(all(abs(lam$s[,4] - .3) < 1e-6))
  expect_equal(lam$ord, seq_along(z))
  expect_true(all(abs(lam$lambda - seq(0, 2, length.out = 100)) < 1e-6))

  dist_ind <-
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(lam$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - lam$dist) < 1e-10)
})



test_that("Values are more or less correct, with stretch = 2", {
  constant_s <- matrix(c(-.9, .9, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  lam <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 2
  )

  expect_true(all(abs(lam$s[,1] - x[,1]) < 1e-6))
  expect_true(all(abs(lam$s[,2] - .1) < 1e-6))
  expect_true(all(abs(lam$s[,3] - .2) < 1e-6))
  expect_true(all(abs(lam$s[,4] - .3) < 1e-6))
  expect_equal(lam$ord, seq_along(z))
  expect_true(all(abs(lam$lambda - seq(0, 2, length.out = 100)) < 1e-3))

  dist_ind <-
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(lam$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - lam$dist) < 1e-10)
})



test_that("Values are more or less correct, without stretch", {
  constant_s <- matrix(c(-.9, .9, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  lam <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 0
  )

  f <- z <= -.9 | z >= .9

  expect_true(all(abs(lam$s[!f,1] - x[!f,1]) < 1e-6))
  expect_false(any(abs(lam$s[f,1] - x[f,1]) < 1e-6))

  expect_true(all(abs(lam$s[,2] - .1) < 1e-6))
  expect_true(all(abs(lam$s[,3] - .2) < 1e-6))
  expect_true(all(abs(lam$s[,4] - .3) < 1e-6))
  expect_true(cor(lam$ord, seq_along(z)) > .9)
  expect_true(all(abs(lam$lambda[!f] - seq(0, 1.8, length.out = sum(!f))) < 1e-3))
  expect_true(all(lam$lambda[z <= -.9] < 1e-5))
  expect_true(all(abs(lam$lambda[z >= .9] - 1.8) < 1e-5))

  dist_ind <-
    ifelse(f, (abs(z) - .9)^2, 0) +
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(lam$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - lam$dist) < 1e-10)
})
