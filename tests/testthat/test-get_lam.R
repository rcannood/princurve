context("Testing get_lam")


test_that("Testing get_lam", {
  s <- cbind(
    seq(0, 1, length.out = 100),
    seq(2, 1, length.out = 100)^2
  )

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
  s <- cbind(
    seq(0, 1, length.out = 100),
    seq(2, 1, length.out = 100)
  )

  x <- s + rnorm(length(s), mean = 0, sd = .005)

  lam <- get.lam(
    x = x,
    s = s,
    stretch = 0
  )

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$tag, seq_len(100)), .99)
})
