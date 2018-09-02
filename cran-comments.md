`analogue` and `aroma.light` both get warnings as a result of the deprecation of 
`principal.curve()`. 

## Changelog

  * Removed extra dependencies in princurve by removing vignettes; fixes #28.
  
  * Fully deprecated `principal.curve()` function.

## Test environments
* local Fedora 28 install, R 3.5.0
* OS X (on travis-ci), R 3.5.0
* Ubuntu 14.04 (on travis-ci), R 3.5.0
* Windows (on appveyor), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  
  Days since last update: 1

## Reverse dependencies

R CMD check was run at 2019/09/02 using the following command:

```r
revdepcheck::revdep_check(timeout = as.difftime(60, units = "mins"), num_workers = 8)
```

|package                                      |version |error |warning |note |
|:--------------------------------------------|:-------|:-----|:-------|:----|
|[analogue](revdep/problems.md#analogue)      |0.17-0  |      |__+1__  |     |
|[aroma.light](revdep/problems.md#aromalight) |3.10.0  |      |__+1__  |1    |
|ClusterSignificance                          |1.8.2   |      |        |     |
|[FateID](revdep/problems.md#fateid)          |0.1.4   |      |1       |     |
|[lilikoi](revdep/problems.md#lilikoi)        |0.1.0   |      |        |3    |
|MDSMap                                       |1.1     |      |        |     |
|[pathifier](revdep/problems.md#pathifier)    |1.20.0  |      |        |1    |
|[RSDA](revdep/problems.md#rsda)              |2.0.5   |1     |        |     |
|SCORPIUS                                     |1.0.2   |      |        |     |
