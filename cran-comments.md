# princurve 2.1.6

  * BUG FIX `project_to_curve()`: Return error message when `x` or `s` contain
    insufficient rows.
    
  * BUG FIX unit tests: Switch from `svg()` to `pdf()` as support for `svg()` 
    might be optional. 

## Test environments
* localhost (before installation):
  - Fedora, R 4.0.2
* Github Actions (automated):
  - Mac OS X, R Release
  - Windows, R Release
  - Ubuntu 16.04, R Release
  - Ubuntu 16.04, R 3.2
  - Ubuntu 16.04, R 3.3
  - Ubuntu 16.04, R 3.4
  - Ubuntu 16.04, R 3.5
  - Ubuntu 16.04, R 3.6
* win-builder:
  - oldrelease
  - release
  - devel

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Summary:
```
> revdepcheck::revdep_check(num_workers = 15, timeout = as.difftime(600, units = "mins"))
── CHECK ──────────────────────────────────────────────────────── 11 packages ──
✔ analogue 0.17-5                        ── E: 1     | W: 0     | N: 0                                                                                                                                                                                    
I ClusterSignificance 1.18.0             ── E: 1     | W: 0     | N: 1                                                                                                                                                                                    
✔ pathifier 1.28.0                       ── E: 0     | W: 0     | N: 1                                                                                                                                                                                    
✔ aroma.light 3.20.0                     ── E: 0     | W: 0     | N: 1                                                                                                                                                                                    
✔ MDSMap 1.1                             ── E: 1     | W: 0     | N: 0                                                                                                                                                                                    
✔ slingshot 1.8.0                        ── E: 1     | W: 0     | N: 1                                                                                                                                                                                    
✔ RSDA 3.0.4                             ── E: 1     | W: 0     | N: 0                                                                                                                                                                                    
✔ FateID 0.1.9                           ── E: 1     | W: 0     | N: 0                                                                                                                                                                                    
✔ SCORPIUS 1.0.7                         ── E: 0     | W: 0     | N: 0                                                                                                                                                                                    
✔ mappoly 0.2.1                          ── E: 1     | W: 0     | N: 0                                                                                                                                                                                    
✔ tradeSeq 1.4.0                         ── E: 1     | W: 0     | N: 0                                                                                                                                                                                    
OK: 11
BROKEN: 0
Total time: 4 min
── REPORT ──────────────────────────────────────────────────────────────────────
```
