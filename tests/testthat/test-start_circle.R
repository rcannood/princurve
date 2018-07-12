context("Testing start_circle")

test_start_circle_output <- function(x_orig, fit) {
  x_new <- fit$s

  expect_equal(dim(x_new), dim(x_orig))
  expect_equal(rownames(x_new), rownames(x_orig))
  expect_equal(colnames(x_new), colnames(x_orig))

  xbar_orig <- apply(x_orig, 2, mean)
  radius_orig <- colMeans(abs(sweep(x_orig, 2, xbar_orig)))

  xbar_new <- apply(x_new, 2, mean)
  radius_new <- colMeans(abs(sweep(x_new, 2, xbar_new)))

  expect_lte(sum((xbar_orig - xbar_new)^2), 1e-2)
  expect_lte(sum((radius_orig[1:2] - radius_new[1:2])^2), 1e-2)
}

test_that("Testing start_circle", {
  x_orig <- cbind(
    rnorm(100, 0, 1),
    rnorm(100, 0, 1)
  )

  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)

  colnames(x_orig) <- paste0("Dim", seq_len(ncol(x_orig)))
  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)

  rownames(x_orig) <- paste0("Sample", seq_len(nrow(x_orig)))
  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)

  colnames(x_orig) <- NULL
  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)
})


test_that("Testing start_circle", {
  x_orig <- cbind(
    rnorm(404, 1, .2),
    rnorm(404, -5, .2),
    runif(404, 1.9, 2.1),
    runif(404, 2.9, 3.1)
  )

  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)

  colnames(x_orig) <- paste0("Dim", seq_len(ncol(x_orig)))
  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)

  rownames(x_orig) <- paste0("Sample", seq_len(nrow(x_orig)))
  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)

  colnames(x_orig) <- NULL
  fit <- start_circle(x_orig)
  test_start_circle_output(x_orig, fit)
})

