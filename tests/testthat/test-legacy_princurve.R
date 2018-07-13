context("Comparing principal.curve and get.lam to legacy package")

already_installed <- "princurvelegacy" %in% rownames(installed.packages())
if (!already_installed) {
  devtools::install_github("dynverse/princurve@legacy")
}

for (i in seq_len(10)) {
  test_that(paste0("Directly compare principal.curve against legagy, run ", i), {
    x <- matrix(runif(1000), ncol = 10)
    fit1 <- princurve::principal.curve(x)
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

    fit1 <- princurve::get.lam(x, s)
    fit2 <- princurvelegacy::get.lam(x, s)

    expect_equal(names(fit1), names(fit2))
    expect_equal(class(fit1), class(fit2))
    expect_equal(attributes(fit1), attributes(fit2)) # just in case

    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit2$s))), .99)
    expect_gte(cor(order(fit1$tag), order(fit2$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit2$lambda)), .99)
    expect_lte(abs(fit1$dist - fit2$dist), .01)

    ord <- sample.int(10)
    fit3 <- princurve::get.lam(x, s[ord, ], tag = order(ord))

    expect_gte(abs(cor(as.vector(fit1$s), as.vector(fit3$s))), .99)
    expect_gte(cor(order(fit1$tag), order(fit3$tag)), .99)
    expect_gte(abs(cor(fit1$lambda, fit3$lambda)), .99)
    expect_lte(abs(fit1$dist - fit3$dist), .01)
  })
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
