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
  expect_true(all(abs(rowSums((x - lam$s)^2) - lam$dist_ind) < 1e-10))

  expect_equal(names(lam), c("s", "ord", "lambda", "dist_ind", "dist"))

  sord <- lam$s[lam$ord,]
  slam <- cumsum(c(0, sqrt(rowSums((sord[-nrow(sord),] - sord[-1,])^2))))
  expect_gte(cor(slam, lam$lambda[lam$ord]), .99)
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
  expect_true(all(abs(rowSums((x[ord,] - lam$s)^2) - lam$dist_ind) < 1e-10))

  sord <- lam$s[lam$ord,]
  slam <- cumsum(c(0, sqrt(rowSums((sord[-nrow(sord),] - sord[-1,])^2))))
  expect_gte(cor(slam, lam$lambda[lam$ord]), .99)
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
  cut <- 0.89898990
  constant_s <- matrix(c(-cut, cut, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  lam <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 0
  )

  f <- z < -cut | z > cut

  expect_true(all(abs(lam$s[!f,1] - x[!f,1]) < 1e-6))
  expect_false(any(abs(lam$s[f,1] - x[f,1]) < 1e-6))

  expect_true(all(abs(lam$s[,2] - .1) < 1e-6))
  expect_true(all(abs(lam$s[,3] - .2) < 1e-6))
  expect_true(all(abs(lam$s[,4] - .3) < 1e-6))
  expect_true(cor(lam$ord, seq_along(z)) > cut)

  lambda <- apply(lam$s, 1, function(x) sqrt(sum((x - constant_s[1,])^2)))
  expect_true(all(abs(lam$lambda - lambda) < 1e-8))

  dist_ind <-
    ifelse(f, (abs(z) - cut)^2, 0) +
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(lam$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - lam$dist) < 1e-10)
})



test_that("Expect principal_curve to error elegantly", {
  expect_error(project_to_curve(x = list(), s = s, stretch = 0), "matrix")
  expect_error(project_to_curve(x = x, s = list(), stretch = 0), "matrix")
  expect_error(project_to_curve(x, s, stretch = -1), "larger than 0")
  expect_error(project_to_curve(x, s, stretch = 10), "smaller than 2")
  expect_error(project_to_curve(x, s, stretch = "10"), "must be numeric")
})



test_that("Projecting to random data produces correct results", {
  s <- matrix(runif(100), ncol = 2)
  x <- matrix(runif(100), ncol = 2)

  lam <- project_to_curve(
    x = x,
    s = s,
    stretch = 0
  )

  sord <- lam$s[lam$ord,]
  slam <- sqrt(rowSums((sord[-nrow(sord),] - sord[-1,])^2))

  lam$lambda[lam$ord]
})

