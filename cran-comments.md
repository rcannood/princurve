This release fixes warnings when using `stats::approx()` in R 3.6.

## Changelog

  * Fix warning in `stats::approx()` due to changes made in R 3.6.
  
  * Defuncted `principal.curve()` and `get.lam()`.

## Test environments
* local Fedora 28 install, R 3.6.0
* OS X (on travis-ci), R 3.6.0
* Ubuntu 14.04 (on travis-ci), R 3.6.0
* Windows (on appveyor), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

R CMD check was run on 27 May 2019 using the following command:

```r
revdepcheck::revdep_check(timeout = as.difftime(60, units = "mins"), num_workers = 8)
```

Summary:
```
✔ aroma.light 3.12.0                     ── E: 0     | W: 0     | N: 1
✔ pathifier 1.20.0                       ── E: 0     | W: 0     | N: 1
✔ analogue 0.17-3                        ── E: 1     | W: 0     | N: 0
✔ ClusterSignificance 1.10.0             ── E: 0     | W: 0     | N: 1
✔ RSDA 2.0.8                             ── E: 1     | W: 0     | N: 0
✔ lilikoi 0.1.0                          ── E: 1     | W: 0     | N: 0
✔ SCORPIUS 1.0.2                         ── E: 1     | W: 0     | N: 0
✔ MDSMap 1.1                             ── E: 0     | W: 0     | N: 0
✔ FateID 0.1.7                           ── E: 0     | W: 0     | N: 0
✔ slingshot 1.0.0                        ── E: 1     | W: 0     | N: 0
OK: 10                                                                                                                                                                                
BROKEN: 0
Total time: 33 min
```
