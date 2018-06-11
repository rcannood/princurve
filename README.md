<!-- README.md is generated from README.Rmd. Please edit that file -->
princurve
=========

[![Build
Status](https://travis-ci.org/dynverse/princurve.svg?branch=master)](https://travis-ci.org/dynverse/princurve)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/dynverse/princurve?branch=master&svg=true)](https://ci.appveyor.com/project/dynverse/princurve)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/princurve)](https://cran.r-project.org/package=princurve)
[![Coverage
Status](https://codecov.io/gh/dynverse/princurve/branch/master/graph/badge.svg)](https://codecov.io/gh/dynverse/princurve?branch=master)

This is an R port of Trevor Hastie's Principal Curve package.

Example
-------

    library(princurve)
    set.seed(1)
    x <- runif(100, -1, 1)
    x <- cbind(x, x ^ 2 + rnorm(100, sd = 0.1))

    fit1 <- principal_curve(x)
    plot(fit1); points(fit1); whiskers(x, fit1$s)

![](man/figures/README_example_plot-1.png)
