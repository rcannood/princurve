context("Legacy functions have been properly deprecated")

test_that("Test whether legacy functions have been deprecated", {
  expect_condition(principal.curve(), "is defunct", class = "defunctError")
  expect_condition(lines.principal.curve(), "is defunct", class = "defunctError")
  expect_condition(plot.principal.curve(), "is defunct", class = "defunctError")
  expect_condition(points.principal.curve(), "is defunct", class = "defunctError")
  expect_condition(get.lam(), "is defunct", class = "defunctError")
})
