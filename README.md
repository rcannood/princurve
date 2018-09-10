
<!-- README.md is generated from README.Rmd. Please edit that file -->

# princurve

[![Build
Status](https://travis-ci.org/dynverse/princurve.svg?branch=master)](https://travis-ci.org/dynverse/princurve)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/dynverse/princurve?branch=master&svg=true)](https://ci.appveyor.com/project/dynverse/princurve)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/princurve)](https://cran.r-project.org/package=princurve)
[![Coverage
Status](https://codecov.io/gh/dynverse/princurve/branch/master/graph/badge.svg)](https://codecov.io/gh/dynverse/princurve?branch=master)

Fitting a principal curve to a data matrix in arbitrary dimensions. A
principal curve is a smooth curve passing through the middle of a
multidimensional dataset. This package is an R/C++ reimplementation of
the S/Fortran code provided by Trevor Hastie, with multiple performance
tweaks.

## Example

Usage of princurve is demonstrated with a toy dataset.

``` r
t <- runif(100, -1, 1)
x <- cbind(t, t ^ 2) + rnorm(200, sd = 0.05)
colnames(x) <- c("dim1", "dim2")

plot(x)
```

![](man/figures/README_example-1.png)<!-- -->

A principal curve can be fit to the data as follows:

``` r
library(princurve)
fit <- principal_curve(x)
plot(fit); whiskers(x, fit$s, col = "gray")
```

![](man/figures/README_princurve-1.png)<!-- -->

See `?principal_curve` for more information on how to use the
`princurve` package.

## Latest changes

Check out `news(package = "princurve")` or [NEWS.md](inst/NEWS.md) for a
full list of
changes.

<!-- This section gets automatically generated from inst/NEWS.md, and also generates inst/NEWS -->

### Latest changes in princurve 2.1.3 (2018-09-10)

  - Removed extra dependencies in princurve by removing vignettes; fixes
    \#28.

  - Fully deprecated `principal.curve()` function.

### Latest changes in princurve 2.1.2 (2018-07-24)

  - DOCUMENTATION: Use the `magick` package to generate animated GIFs in
    the vignette, instead of the `animation` package, because
    `animation` uses `ffmpeg` which is not installed on all CRAN
    systems.

  - DEPRECATION: Added deprecation which will be triggered starting from
    2018-08-01 upon calling `principal.curve()` or `get.lam()`.

## References

Hastie, T. and Stuetzle, W., [Principal
Curves](https://www.jstor.org/stable/2289936), JASA, Vol. 84, No. 406
(Jun., 1989), pp. 502-516, DOI:
[10.2307/2289936](http://doi.org/10.2307/2289936)
([PDF](https://web.stanford.edu/~hastie/Papers/principalcurves.pdf))
