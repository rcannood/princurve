context("Testing get_lam")


test_that("Testing get_lam", {
  z <- seq(-1, 1, length.out = 100)

  s <- cbind(z, z^2)

  x <- s + rnorm(length(s), mean = 0, sd = .005)

  lam <- get_lam(
    x = x,
    s = s,
    stretch = 0
  )

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$tag, seq_len(100)), .99)
})


test_that("Testing get.lam for backwards compatibility", {
  z <- seq(-1, 1, length.out = 100)

  s <- cbind(z, z^2)

  x <- s + rnorm(length(s), mean = 0, sd = .005)

  lam <- get.lam(
    x = x,
    s = s,
    stretch = 0
  )

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$tag, seq_len(100)), .99)
})
