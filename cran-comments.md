## Test environments
* local OS X install, R 3.5.0
* ubuntu 12.04 (on travis-ci), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new release.

## Reverse dependencies

I have run R CMD check on the 8 downstream dependencies.

|package                                                       |version |error |warning |note |
|:-------------------------------------------------------------|:-------|:-----|:-------|:----|
|analogue                                                      |0.17-0  |      |        |     |
|[aroma.light](revdep/problems.md#aromalight)                  |3.10.0  |      |        |1    |
|[ClusterSignificance](revdep/problems.md#clustersignificance) |1.8.0   |-1    |        |1    |
|FateID                                                        |0.1.2   |      |        |     |
|MDSMap                                                        |1.0     |      |        |     |
|[pathifier](revdep/problems.md#pathifier)                     |1.18.0  |1     |        |2    |
|RSDA                                                          |2.0.4   |      |        |     |
|SCORPIUS                                                      |1.0.2   |      |        |     |


### pathifier (1.18.0)
Maintainer: Assif Yitzhaky <assif.yitzhaky@weizmann.ac.il>

1 error  | 1 warning  | 1 note 

```
Error in project_to_curve(x = x, s = start, stretch = stretch) : 
  Expecting a single value: [extent=50].
```

I have sent the maintainer a patch for pathifier which solves the problem.
The parameter `stretch` is supposed to be a numeric of length 1, 
but in a pathifier example a numeric of length 50 is passed.
princurve <= 2.0.2 did not make a fuss when a vector of incorrect length
is passed, but princurve >= 2.0.3 is more stringent.

