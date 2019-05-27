context("Comparing principal.curve and get.lam to legacy package")

skip_on_cran()

already_installed <- "princurvelegacy" %in% rownames(installed.packages())
if (!already_installed) {
  devtools::install_github("rcannood/princurve@legacy")
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare principal.curve against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)

    fit1 <- principal_curve(x)
    fit2 <- princurvelegacy::principal.curve(x)

    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit2$s))), .99)
    expect_gte(cor(order(fit1$ord), order(fit2$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit2$lambda)), .99)
    expect_lte(abs(fit1$dist - fit2$dist), .01)
    expect_equal(fit1$converged, fit2$converged)
    expect_equal(fit1$num_iterations, fit2$nbrOfIterations)
  })
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare get.lam against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)
    s <- matrix(runif(100), ncol = 10)

    fit1 <- project_to_curve(x, s)
    fit2 <- princurvelegacy::get.lam(x, s)

    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit2$s))), .99)
    expect_gte(cor(order(fit1$ord), order(fit2$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit2$lambda)), .99)
    expect_lte(abs(fit1$dist - fit2$dist), .01)
  })
}

if (!already_installed) {
  remove.packages("princurvelegacy")
}
