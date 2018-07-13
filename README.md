
<!-- README.md is generated from README.Rmd. Please edit that file -->
princurve
=========

[![Build Status](https://travis-ci.org/dynverse/princurve.svg?branch=master)](https://travis-ci.org/dynverse/princurve) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dynverse/princurve?branch=master&svg=true)](https://ci.appveyor.com/project/dynverse/princurve) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/princurve)](https://cran.r-project.org/package=princurve) [![Coverage Status](https://codecov.io/gh/dynverse/princurve/branch/master/graph/badge.svg)](https://codecov.io/gh/dynverse/princurve?branch=master)

Fitting a principal curve to a data matrix in arbitrary dimensions.

Example
-------

We generate some example data:

``` r
t <- runif(100, -1, 1)
x <- cbind(t, t ^ 2) + rnorm(200, sd = 0.05)
colnames(x) <- c("dim1", "dim2")

plot(x)
```

![](man/figures/README_example_data-1.png)

A principal curve can be fit to the data as follows:

``` r
library(princurve)
fit <- principal_curve(x)
plot(fit); whiskers(x, fit$s, col = "gray")
```

![](man/figures/README_example_plot-1.png)

Check out `?principal_curve` for more information on the specific outputs of `principal_curve()`.

<!-- ## Latest changes -->
<!-- This section gets automatically generated from inst/NEWS.md, and also generates inst/NEWS -->
Latest changes in princurve 2.1.0 (unreleased)
----------------------------------------------

-   BUG FIX `principal_curve()`: avoid division by zero when the initial principal curve has already converged.

-   BUG FIX `project_to_curve()`: set dimension names of outputted `s` correctly.

-   DOCUMENTATION: Added `cran-comments.md` and `revdep` to repository.

-   MINOR CHANGE: Removed `adjust_range()`; use `grDevices::extendrange()` instead.

-   TESTING `start_circle()`: Added unit tests.

-   BUG FIX `start_circle()`: Make sure circle is centered and scaled correctly.

-   MINOR CHANGE: Move smoother functions from inside `principal_curve()` to a list `smoother_functions`.

-   TESTING `smoother_functions`: Added tests to ensure each of the smoother functions work correctly.

-   SPEED UP `project_to_curve()`: Significantly speed up this function by not allocation objects that don't need allocation, and pre-allocating objects that do.

-   SPEED UP `principal_curve()`: Added `approx_points` parameter. This allows approximation of the curve between smoothing and projection, to ensure `principal_curve()` scales well to higher numbers of samples.

Check [NEWS.md](inst/NEWS.md) for full list of changes.

References
----------

Hastie, T. and Stuetzle, W., [Principal Curves](https://www.jstor.org/stable/2289936), JASA, Vol. 84, No. 406 (Jun., 1989), pp. 502-516, DOI: [10.2307/2289936](http://doi.org/10.2307/2289936) ([PDF](https://web.stanford.edu/~hastie/Papers/principalcurves.pdf))
