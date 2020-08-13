context("Testing project_to_curve")

# helper function for validating project_to_curve output
test_projection <- function(x, s, stretch, fit) {
  # check names
  expect_equal(names(fit), c("s", "ord", "lambda", "dist_ind", "dist"))
  expect_equal(rownames(fit$s), rownames(x))
  expect_equal(colnames(fit$s), colnames(x))
  expect_equal(names(fit$lambda), rownames(x))
  expect_equal(names(fit$dist_ind), rownames(x))
  expect_equal(names(fit$ord), NULL)
  expect_equal(names(fit$dist), NULL)

  # check lambda
  sord <- fit$s[fit$ord,]
  slam <- cumsum(c(0, sqrt(rowSums((sord[-nrow(sord),] - sord[-1,])^2))))
  expect_lte(sum((slam - fit$lambda[fit$ord])^2), 1e-10)

  # check dist_ind
  dist_ind <- rowSums((fit$s - x)^2)
  expect_lte(sum((dist_ind - fit$dist_ind)^2), 1e-10)

  # check dist
  dist <- sum(dist_ind)
  expect_lte(sum((dist - fit$dist)^2), 1e-10)

  # reproject
  fit2 <- project_to_curve(fit$s, fit$s, stretch = 0)
  expect_lte(sum((fit2$s - fit$s)^2), 1e-10)
}

# test data
z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)
ord <- sample.int(nrow(x))

test_that("Verify s is not modified", {
  s_orig <- s + 0
  fit <- project_to_curve(
    x = x,
    s = s,
    stretch = 2
  )
  expect_equal(s, s_orig, tolerance = 1e-5)
})


test_that("Testing project_to_curve", {
  fit <- project_to_curve(
    x = x,
    s = s,
    stretch = 0
  )

  test_projection(x, s, stretch = 0, fit)

  expect_gte(cor(as.vector(fit$s), as.vector(s)), .99)
  expect_gte(cor(fit$ord, seq_len(100)), .99)
})


test_that("Checking whether project_to_curve retains dimnames", {
  colnames(x) <- paste0("Comp", seq_len(ncol(x)))
  fit <- project_to_curve(x = x, s = s, stretch = 0)
  test_projection(x, s, stretch = 0, fit)

  rownames(x) <- paste0("Sample", seq_len(nrow(x)))
  fit <- project_to_curve(x = x, s = s, stretch = 0)
  test_projection(x, s, stretch = 0, fit)

  colnames(x) <- NULL
  fit <- project_to_curve(x = x, s = s, stretch = 0)
  test_projection(x, s, stretch = 0, fit)
})


test_that("Testing project_to_curve with shuffled order", {
  fit <- project_to_curve(
    x = x[ord,],
    s = s,
    stretch = 0
  )

  test_projection(x[ord,], s, stretch = 0, fit)

  expect_gte(cor(as.vector(fit$s[fit$ord,]), as.vector(s)), .99)
  expect_gte(cor(order(fit$ord), ord), .99)
})

test_that("Values are more or less correct", {
  constant_s <- matrix(c(-1, 1, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  fit <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 0
  )

  test_projection(x, constant_s, stretch = 0, fit)

  expect_true(all(abs(fit$s[,1] - x[,1]) < 1e-6))
  expect_true(all(abs(fit$s[,2] - .1) < 1e-6))
  expect_true(all(abs(fit$s[,3] - .2) < 1e-6))
  expect_true(all(abs(fit$s[,4] - .3) < 1e-6))
  expect_equal(fit$ord, seq_along(z))
  expect_true(all(abs(fit$lambda - seq(0, 2, length.out = 100)) < 1e-6))

  dist_ind <-
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(fit$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - fit$dist) < 1e-10)
})



test_that("Values are more or less correct, with stretch = 2 and a given ord", {
  constant_s <- matrix(c(-.9, .9, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  fit <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 2
  )

  test_projection(x, constant_s, stretch = 0, fit)

  expect_true(all(abs(fit$s[,1] - x[,1]) < 1e-6))
  expect_true(all(abs(fit$s[,2] - .1) < 1e-6))
  expect_true(all(abs(fit$s[,3] - .2) < 1e-6))
  expect_true(all(abs(fit$s[,4] - .3) < 1e-6))
  expect_equal(fit$ord, seq_along(z))
  expect_true(all(abs(fit$lambda - seq(0, 2, length.out = 100)) < 1e-3))

  dist_ind <-
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(fit$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - fit$dist) < 1e-10)
})



test_that("Values are more or less correct, without stretch", {
  cut <- 0.89898990
  constant_s <- matrix(c(-cut, cut, .1, .1, .2, .2, .3, .3), nrow = 2, byrow = FALSE)
  x[,1] <- z

  fit <- project_to_curve(
    x = x,
    s = constant_s,
    stretch = 0
  )

  test_projection(x, constant_s, stretch = 2, fit)

  f <- z < -cut | z > cut

  expect_true(all(abs(fit$s[!f,1] - x[!f,1]) < 1e-6))
  expect_false(any(abs(fit$s[f,1] - x[f,1]) < 1e-6))

  expect_true(all(abs(fit$s[,2] - .1) < 1e-6))
  expect_true(all(abs(fit$s[,3] - .2) < 1e-6))
  expect_true(all(abs(fit$s[,4] - .3) < 1e-6))
  expect_true(cor(fit$ord, seq_along(z)) > cut)

  lambda <- apply(fit$s, 1, function(x) sqrt(sum((x - constant_s[1,])^2)))
  expect_true(all(abs(fit$lambda - lambda) < 1e-8))

  dist_ind <-
    ifelse(f, (abs(z) - cut)^2, 0) +
    (x[,2] - .1)^2 +
    (x[,3] - .2)^2 +
    (x[,4] - .3)^2

  expect_true(all(abs(fit$dist_ind - dist_ind) < 1e-10))

  expect_true(abs(sum(dist_ind) - fit$dist) < 1e-10)
})



test_that("Expect project_to_curve to error elegantly", {
  # expect_error(project_to_curve(list(1), list(1)))
  # expect_error(project_to_curve(x = list(), s = s, stretch = 0))
  # expect_error(project_to_curve(x = x, s = list(), stretch = 0))
  expect_error(project_to_curve(x, s, stretch = -1), "larger than or equal to 0")
  # expect_error(project_to_curve(x, s, stretch = "10"))
  expect_error(project_to_curve(x, cbind(s, s)), "must have an equal number of columns")
})



test_that("Projecting to random data produces correct results", {
  for (i in seq_len(10)) {
    s <- matrix(runif(100), ncol = 2)
    x <- matrix(runif(100), ncol = 2)

    fit <- project_to_curve(
      x = x,
      s = s,
      stretch = 0
    )

    test_projection(x, s, stretch = 0, fit)
  }
})
