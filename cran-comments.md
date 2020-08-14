# princurve 2.1.5 (2020-08-13)
  
  * BUG FIX `project_to_curve()`: Fix pass-by-reference bug, issue #33. Thanks 
    to @szcf-weiya for detecting and fixing this bug!

## Test environments
* localhost (before installation):
  - Fedora 31, R 4.0.2
* Github Actions (automated):
  - Mac OS X, R Release
  - Windows, R Release
  - Ubuntu 18.04, R Release
  - Ubuntu 18.04, R 3.2
  - Ubuntu 18.04, R 3.3
  - Ubuntu 18.04, R 3.4
  - Ubuntu 18.04, R 3.5
  - Ubuntu 18.04, R 3.6
* win-builder:
  - oldrelease
  - release
  - devel

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Summary:
```
> revdepcheck::revdep_check(num_workers = 8, timeout = as.difftime(600, units = "mins"))
── INIT ─────────────────────────────────────────────────── Computing revdeps ──
── INSTALL ─────────────────────────────────────────────────────── 2 versions ──
Installing CRAN version of princurve
also installing the dependency ‘Rcpp’
Installing DEV version of princurve
Installing 1 packages: Rcpp
── CHECK ──────────────────────────────────────────────────────── 10 packages ──
✓ aroma.light 3.18.0                     ── E: 0     | W: 0     | N: 1
✓ pathifier 1.26.0                       ── E: 0     | W: 0     | N: 1
✓ analogue 0.17-5                        ── E: 0     | W: 0     | N: 0
✓ RSDA 3.0.4                             ── E: 1     | W: 0     | N: 0
✓ ClusterSignificance 1.16.0             ── E: 0     | W: 0     | N: 0
✓ FateID 0.1.9                           ── E: 0     | W: 0     | N: 1
✓ SCORPIUS 1.0.7                         ── E: 0     | W: 0     | N: 0
✓ MDSMap 1.1                             ── E: 0     | W: 0     | N: 0
✓ slingshot 1.6.1                        ── E: 0     | W: 0     | N: 0
✓ tradeSeq 1.2.01                        ── E: 0     | W: 0     | N: 3
OK: 10
BROKEN: 0
Total time: 11 min
── REPORT ──────────────────────────────────────────────────────────────────────
```
