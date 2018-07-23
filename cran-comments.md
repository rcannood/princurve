Submitting princurve 2.1.1 because one of the tests was failing on CRAN.
In this test, the current version of princurve was being directly compared to
princurve 1.1-12 to ensure backwards compatibility. This issue was solved
by disabling the test, as it is sufficient to run this test on locally and 
on travis.

I noticed rchk produced a warning for princurve 2.1.0, which should be fixed
in this version.

## Changelog

  * DOCUMENTATION: Added vignettes on the algorithm behind princurve and
    on benchmarking results between princurve 1.1 and 2.1.
    
  * BUG FIX `principal_curve()`: Don't apply rownames to curve as approx_points could
    be set to a different value other than `nrow(x)`.
  
  * TESTING: Skip comparison unit test between princurve 1.1 and 2.1 on CRAN.
  
  * MINOR CHANGE `project_to_curve()`: Attempt to fix rchk warnings by not using
  `x(i, j) = v` notation but instead `x[j * x.nrow() + i] = v`.

## Test environments
* local OS X install, R 3.5.0
* ubuntu 12.04 (on travis-ci), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

R CMD check was run on 8 downstream dependencies.

|package                                      |version |error |warning |note |
|:--------------------------------------------|:-------|:-----|:-------|:----|
|analogue                                     |0.17-0  |      |        |     |
|[aroma.light](revdep/problems.md#aromalight) |3.10.0  |      |        |1    |
|ClusterSignificance                          |1.8.2   |      |        |     |
|FateID                                       |0.1.2   |      |        |     |
|MDSMap                                       |1.0     |      |        |     |
|[pathifier](revdep/problems.md#pathifier)    |1.20.0  |      |        |1    |
|RSDA                                         |2.0.4   |      |        |     |
|SCORPIUS                                     |1.0.2   |      |        |     |
