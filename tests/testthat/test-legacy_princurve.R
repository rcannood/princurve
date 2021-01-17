context("Comparing principal_curve and project_to_curve to legacy package")

skip_on_cran()

if (!requireNamespace("princurvelegacy", quietly = TRUE)) {
  devtools::install_github("rcannood/princurve@legacy")
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare principal_curve against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)

    fit1 <- principal_curve(x)
    fit2 <- princurvelegacy::principal.curve(x)

    expect_equivalent(fit1$s, fit2$s, tolerance = .001)
    expect_gte(cor(order(fit1$ord), order(fit2$tag)), .99)
    expect_equivalent(fit1$lambda, fit2$lambda, tolerance = .001)
    expect_equivalent(fit1$dist, fit2$dist, tolerance = .001)
    expect_equal(fit1$converged, fit2$converged)
    expect_equal(fit1$num_iterations, fit2$nbrOfIterations)
  })
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare project_to_curve against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)
    s <- matrix(runif(100), ncol = 10)

    fit1 <- project_to_curve(x, s)
    fit2 <- princurvelegacy::get.lam(x, s)

    expect_equivalent(fit1$s, fit2$s, tolerance = .001)
    expect_gte(cor(order(fit1$ord), order(fit2$tag)), .99)
    expect_equivalent(fit1$lambda, fit2$lambda, tolerance = .001)
    expect_equivalent(fit1$dist, fit2$dist, tolerance = .001)
  })
}
