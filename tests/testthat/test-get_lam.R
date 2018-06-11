context("Testing get_lam")

z <- seq(-1, 1, length.out = 100)
s <- cbind(z, z^2, z^3, z^4)
x <- s + rnorm(length(s), mean = 0, sd = .005)

test_that("Testing get_lam", {
  lam <- get_lam(
    x = x,
    s = s,
    stretch = 0
  )

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$tag, seq_len(100)), .99)
})


test_that("Testing get.lam for backwards compatibility", {
  expect_warning({
    lam <- get.lam(
      x = x,
      s = s,
      stretch = 0
    )
  }, "deprecated")

  expect_gte(cor(as.vector(lam$s), as.vector(s)), .99)
  expect_gte(cor(lam$tag, seq_len(100)), .99)
})
