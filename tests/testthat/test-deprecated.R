context("Legacy functions have been properly deprecated")

test_that("Test whether legacy functions have been deprecated", {
  expected_class <- ifelse(getRversion() >= "3.6", "defunctError", "simpleError")
  expect_condition(principal.curve(), "is defunct", class = expected_class)
  expect_condition(lines.principal.curve(), "is defunct", class = expected_class)
  expect_condition(plot.principal.curve(), "is defunct", class = expected_class)
  expect_condition(points.principal.curve(), "is defunct", class = expected_class)
  expect_condition(get.lam(), "is defunct", class = expected_class)
})
