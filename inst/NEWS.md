# princurve 2.0.5 (unreleased)

  * BUG FIX `principal_curve()`: avoid division by zero when the initial principal curve
    has already converged.
  
  * BUG FIX `project_to_curve()`: set dimension names of outputted `s` correctly.
  
  * DOCUMENTATION: Added `cran-comments.md` and `revdep` to repository.
  
  * MINOR CHANGE: Removed `adjust_range()`; use `grDevices::extendrange()` instead.

# princurve 2.0.4 (2018-07-09)

  * BUG FIX: Fixed issues with legacy `principal.curve()` and `get.lam()` (#8).

  * TESTING: Perform direct comparison between the current princurve and
    princurve 1.1-12 to check whether `principal.curve()` and `get.lam()` produce
    output with exactly the same format and almost exactly the same values.

  * SIGNIFICANT CHANGE: Remove the `ord` parameter from `project_to_curve()`,
    in order to reduce the amount of Rcpp code a little bit.

  * DOCUMENTATION: Improved citations (#10).

  * DOCUMENTATION: Improved news (#11).

  * SPEED UP `project_to_curve()`: Do not compute `lambda` accurately as it
    is only used to order the points in `x`.

  * MINOR CHANGE: Added `...` argument to `whiskers()`.

  * DOCUMENTATION: Minor fix in output documentation of `principal_curve()`.

  * DOCUMENTATION: Added more information to the README.
  
  * MINOR CHANGE: Support both `news()` and markdown news on GitHub.

# princurve 2.0.3 (2018-07-04)

  * SIGNIFICANT CHANGES: Reimplemented `project_to_curve()` completely in
    Rcpp, thereby completely removing all Fortran code from princurve.

  * TESTING: test both on linux and osx.

  * TESTING: Added tests to ensure `project_to_curve()` works similar to
    legacy `get.lam()`.

# princurve 2.0.2 (2018-06-12)

  * MAINTAINER: Changed the maintainer from Andreas Weingessel
    to Robrecht Cannoodt.

  * SIGNIFICANT CHANGES: Added functions `principal_curve()` and
    `project_to_curve()` with a slightly different interface than
    `principal.curve()` and `get.lam()`.

  * DEPRECATION: Prepare `get.lam()` and `principal.curve()` for deprecation
    planned on 2018-07-01.  Will contact maintainers of reverse depending
    packages.

  * BUG FIX: Allow `start_circle()` to work when the number of dimensions
    is larger than 2.

  * DOCUMENTATION: Rewrite the README in markdown.

  * DOCUMENTATION: Use roxygen2 for the documentation.

  * MINOR CHANGES: Clean up code to ensure consistent code formatting.

  * TESTING: Added tests for `principal_curve()` and `project_to_curve()`.

  * TESTING: Enabled continuous integration using
    [travis-ci.org](https://travis-ci.org/dynverse/princurve) and
    [ci.appveyor.com](https://ci.appveyor.com/project/dynverse/princurve).

# princurve 1.1-12 (2013-04-25)

  * BUG FIX: src/sortdi.f (sortdi): Fix Fortran array bounds problem.

# princurve 1.1-11 (2011-09-18)

  * MINOR CHANGES: Update for R 2.0.

  * DEPRECATION: Removed `whiskers()`

# princurve 1.1-10 (2009-10-04)

  * BENCHMARKING: For larger data sets, most of the time is spent in `get.lam()`.

  * BUG FIX: `smooth.spline(x,y)` will only use *and* return values for
    "unique" {x}:s. This means that the fitted {y}:s maybe be fewer than
    the input vector. In order to control for this, we use `predict()`.

  * NEW FEATURE: Now `smoother` can also be a function taking arguments
    `lambda`, `xj` and `...` and return `y` of the same length
    as `lambda` and `xj`.

  * NEW FEATURE `principal.curve()`: Arguments `start` and `stretch`
    can be NULL, which behaves the same as if they are "missing"
    [which is hard to emulate with for instance `do.call()`].

  * NEW FEATURE: Added `converged` and `nbrOfIterations` to return structure.

  * SPEED UP/MEMORY OPTIMIZATION: Now the nxp matrix 's' is allocated only
    once. Before it was built up using cbind() once per iteration.

  * SPEED UP: Now the smoother function is identified/created before
    starting the algorithm, and not once per dimension and iteration.

  * MEMORY OPTIMISATION `principal.curve()`: Now the result matrix
    allocated as doubles, not logicals (as NA is), in order to
    prevent a coersion.

  * BUG FIX: An error was thrown if `smoother` was a function.

  * MINOR CHANGES: Cleaned up source code (removed comments).

# princurve 1.1-9 (2007-07-12)

  * MINOR CHANGE: Clarify license.

# princurve 1.1-8 (2006-10-04)

  * MINOR CHANGE: Update license and add depending packages.

# princurve 1.1-7 (2004-11-04)

  * MINOR CHANGE: Depend on R >= 1.9.0

  * MINOR CHANGE: Changed license to GPL version 2 or newer,
    as granted by Trevor Hastie.

  * MINOR CHANGE: Don't require defunct `modreg`.

# princurve 1.1-6 (2004-01-31)

  * MINOR CHANGE: Removed INDEX.

# princurve 1.1-5 (2002-07-03)

  * MINOR CHANGE: Added `PACKAGE` to Fortran calls.

# princurve 1.1-4 (2002-07-02)

  * MINOR CHANGES: Change all `T` to `TRUE`.

# princurve 1.1-2 (2001-06-10)

  * MINOR CHANGE `plot.principal.curve()`: Rename argument `object` to `x`.

  * MINOR CHANGE `lines.principal.curve()`: Rename argument `object` to `x`.

  * MINOR CHANGE `points.principal.curve()`: Rename argument `object` to `x`.

  * MINOR CHANGE: Rename internal function`start.circle()` to `startCircle()`.

# princurve 1.1-0 (2000-12-27)

  * DESCRIPTION: Added Title and Maintainer field.

  * MINOR CHANGES: Changed `F` to `FALSE`.

  * DOCUMENTATION: Added keywords to `get.lam()`.

  * DOCUMENTATION: Expanded documentation of `principal.curve()`:
    added default values to usage, description, keywords and aliases.

  * MINOR CHANGES: Changed precision in `getlam.f` from `v(2,10)` to `v(2,p)`.