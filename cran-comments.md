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
