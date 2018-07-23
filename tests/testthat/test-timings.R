context("Ensuring that princurve is at least as fast as legacy princurve")

# only run this test on the maintainer's development environment
skip_if_not(Sys.info()[["user"]] %in% c("rcannood"))

already_installed <- "princurvelegacy" %in% rownames(installed.packages())
if (!already_installed) {
  devtools::install_github("dynverse/princurve@legacy")
}

test_that("project_to_cells is at least as fast as legacy get.lam", {
  set.seed(1)
  np <- 1000
  lambda <- rnorm(np, 0, .2)
  x <- cbind(
    lambda + rnorm(length(lambda), 0, .02),
    lambda^2 + rnorm(length(lambda), 0, .02)
  )
  s <- cbind(lambda, lambda^2)
  mic <- microbenchmark::microbenchmark(
    fortran = princurvelegacy::get.lam(x, s),
    rcpp = princurve::project_to_curve(x, s),
    unit = "ms",
    times = 100L
  )
  smic <- summary(mic)
  expect_lte(smic$median[[2]], smic$median[[1]] * 2)
})


test_that("principal_curve is at least as fast as legacy principal.curve", {
  set.seed(1)
  np <- 1000
  lambda <- rnorm(np, 0, .2)
  x <- cbind(
    lambda + rnorm(length(lambda), 0, .02),
    lambda^2 + rnorm(length(lambda), 0, .02)
  )
  mic <- microbenchmark::microbenchmark(
    legacy = princurvelegacy::principal.curve(x),
    new = princurve::principal_curve(x, approx_points = 100),
    unit = "ms",
    times = 100L
  )
  smic <- summary(mic)
  expect_lte(smic$median[[2]], smic$median[[1]] * 2)
})

if (!already_installed) {
  remove.packages("princurvelegacy")
}
