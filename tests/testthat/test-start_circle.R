context("Testing start_circle")

test_start_circle_output <- function(x_orig) {
  xbar_orig <- apply(x_orig, 2, mean)

  fit <- start_circle(x_orig)
  x_new <- fit$s
  xbar_new <- apply(x_new, 2, mean)
  radius_new <- colMeans(abs(sweep(x_new, 2, xbar_new)))[1:2]

  expect_equal(dim(x_new), dim(x_orig))
  expect_equal(rownames(x_new), rownames(x_orig))
  expect_equal(colnames(x_new), colnames(x_orig))
  expect_lte(sum((xbar_orig - xbar_new)^2), 1e-2)

  # check whether bar and radius update correctly after translation
  fit2 <- start_circle(x_orig + 10)
  x_new2 <- fit2$s
  xbar_new2 <- apply(x_new2, 2, mean)
  radius_new2 <- colMeans(abs(sweep(x_new2, 2, xbar_new2)))[1:2]

  expect_lte(sum((abs(xbar_new2 - xbar_new) - 10)^2), 1e-10)
  expect_lte(sum((radius_new2 - radius_new)^2), 1e-10)

  # check whether bar and radius update correctly after scaling
  fit3 <- start_circle(x_orig * 10)
  x_new3 <- fit3$s
  xbar_new3 <- apply(x_new3, 2, mean)
  radius_new3 <- colMeans(abs(sweep(x_new3, 2, xbar_new3)))[1:2]

  expect_lte(sum((abs(xbar_new3 / xbar_new) - 10)^2), 1e-10)
  expect_lte(sum((abs(radius_new3 / radius_new) - 10)^2), 1e-10)
}

test_that("Testing start_circle", {
  x_orig <- cbind(
    rnorm(100, 0, 1),
    rnorm(100, 0, 1)
  )

  test_start_circle_output(x_orig)

  colnames(x_orig) <- paste0("Dim", seq_len(ncol(x_orig)))
  test_start_circle_output(x_orig)

  rownames(x_orig) <- paste0("Sample", seq_len(nrow(x_orig)))
  test_start_circle_output(x_orig)

  colnames(x_orig) <- NULL
  test_start_circle_output(x_orig)
})


test_that("Testing start_circle", {
  x_orig <- cbind(
    rnorm(404, 1, .2),
    rnorm(404, -5, .2),
    runif(404, 1.9, 2.1),
    runif(404, 2.9, 3.1)
  )

  test_start_circle_output(x_orig)

  colnames(x_orig) <- paste0("Dim", seq_len(ncol(x_orig)))
  test_start_circle_output(x_orig)

  rownames(x_orig) <- paste0("Sample", seq_len(nrow(x_orig)))
  test_start_circle_output(x_orig)

  colnames(x_orig) <- NULL
  test_start_circle_output(x_orig)
})

