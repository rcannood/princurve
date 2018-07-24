
<!-- README.md is generated from README.Rmd. Please edit that file -->
princurve
=========

[![Build Status](https://travis-ci.org/dynverse/princurve.svg?branch=master)](https://travis-ci.org/dynverse/princurve) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dynverse/princurve?branch=master&svg=true)](https://ci.appveyor.com/project/dynverse/princurve) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/princurve)](https://cran.r-project.org/package=princurve) [![Coverage Status](https://codecov.io/gh/dynverse/princurve/branch/master/graph/badge.svg)](https://codecov.io/gh/dynverse/princurve?branch=master)

Fitting a principal curve to a data matrix in arbitrary dimensions. A principal curve is a smooth curve passing through the middle of a multidimensional dataset. This package is an R/C++ reimplementation of the S/Fortran code provided by Trevor Hastie, with multiple performance tweaks.

Deriving a principal curve is an iterative process. This is what it looks like for a two-dimensional toy dataset:

![](man/figures/README_example-1.gif)

For more information on how to use the `princurve` package, check out the following resources:

-   Vignette: [Introduction to the princurve package](https://cran.r-project.org/web/packages/princurve/vignettes/intro.html)
-   Help file: `?principal_curve`

Latest changes
--------------

Check out `news(package = "princurve")` or [NEWS.md](inst/NEWS.md) for a full list of changes.

<!-- This section gets automatically generated from inst/NEWS.md, and also generates inst/NEWS -->
### Latest changes in princurve 2.1.2 (unreleased)

-   DOCUMENTATION: Use the `magick` package to generate animated GIFs in the vignette, instead of the `animation` package, because `animation` uses `ffmpeg` which is not installed on all CRAN systems.

-   DEPRECATION: Added deprecation which will be triggered starting from 2018-08-01 upon calling `principal.curve()` or `get.lam()`.

### Latest changes in princurve 2.1.1 (2018-07-23)

-   DOCUMENTATION: Added vignettes on the algorithm behind princurve and on benchmarking results between princurve 1.1 and 2.1.

-   BUG FIX `principal_curve()`: Don't apply rownames to curve as approx\_points could be set to a different value other than `nrow(x)`.

-   TESTING: Skip comparison unit test between princurve 1.1 and 2.1 on CRAN.

-   MINOR CHANGE `project_to_curve()`: Attempt to fix rchk warnings by not using `x(i, j) = v` notation but instead `x[j * x.nrow() + i] = v`.

-   DOCUMENTATION: Fix in README documentation.

References
----------

Hastie, T. and Stuetzle, W., [Principal Curves](https://www.jstor.org/stable/2289936), JASA, Vol. 84, No. 406 (Jun., 1989), pp. 502-516, DOI: [10.2307/2289936](http://doi.org/10.2307/2289936) ([PDF](https://web.stanford.edu/~hastie/Papers/principalcurves.pdf))
