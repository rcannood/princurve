context("Testing smoother_functions")

for (nsf in names(smoother_functions)) {
  test_that(paste0("Smoother function ", nsf, " works as expected"), {
    sf <- smoother_functions[[nsf]]

    lambda <- seq(-1, 1, length.out = 100)
    xj <- lambda^2 + rnorm(length(lambda), 0, .1)

    # check whether y is smoother than xj
    y <- sf(lambda, xj)
    expect_lte(mean(diff(y)^2), mean(diff(xj)^2))

    # check whether shuffled input data results in the same output
    or <- sample.int(length(lambda))
    y2 <- sf(lambda[or], xj[or])
    expect_lte(mean(diff(y)^2), mean(diff(xj)^2))
  })
}
