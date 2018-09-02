context("Comparing principal.curve and get.lam to legacy package")

skip_on_cran()

already_installed <- "princurvelegacy" %in% rownames(installed.packages())
if (!already_installed) {
  devtools::install_github("dynverse/princurve@legacy")
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare principal.curve against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)

    expect_warning({
      fit1 <- princurve::principal.curve(x)
    }, "deprecated")
    fit2 <- princurvelegacy::principal.curve(x)

    expect_equal(names(fit1), names(fit2))
    expect_equal(class(fit1), class(fit2))
    expect_equal(attributes(fit1), attributes(fit2)) # just in case
    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit2$s))), .99)
    expect_gte(cor(order(fit1$tag), order(fit2$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit2$lambda)), .99)
    expect_lte(abs(fit1$dist - fit2$dist), .01)
    expect_equal(fit1$converged, fit2$converged)
    expect_equal(fit1$nbrOfIterations, fit2$nbrOfIterations)
  })
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare get.lam against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)
    s <- matrix(runif(100), ncol = 10)

    expect_warning({
      fit1 <- princurve::get.lam(x, s)
    }, "deprecated")

    fit2 <- princurvelegacy::get.lam(x, s)

    expect_equal(names(fit1), names(fit2))
    expect_equal(class(fit1), class(fit2))
    expect_equal(attributes(fit1), attributes(fit2)) # just in case

    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit2$s))), .99)
    expect_gte(cor(order(fit1$tag), order(fit2$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit2$lambda)), .99)
    expect_lte(abs(fit1$dist - fit2$dist), .01)

    ord <- sample.int(10)
    expect_warning({
      fit3 <- princurve::get.lam(x, s[ord, ], tag = order(ord))
    }, "deprecated")

    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit3$s))), .99)
    expect_gte(cor(order(fit1$tag), order(fit3$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit3$lambda)), .99)
    expect_lte(abs(fit1$dist - fit3$dist), .01)
  })
}

if (!already_installed) {
  remove.packages("princurvelegacy")
}
