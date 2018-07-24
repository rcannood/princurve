There was a problem generating the vignettes because ffmpeg was not installed,
resulting in warnings on fedora and solaris platforms.

I rewrote the vignette to use `magick` instead of `animation`, which uses 
imagemagick instead of ffmpeg as a back end. 

## Changelog

  * DOCUMENTATION: Use the `magick` package to generate animated GIFs in 
    the vignette, instead of the `animation` package, because
    `animation` uses `ffmpeg` which is not installed on all CRAN systems.
    
  * DEPRECATION: Added deprecation which will be triggered starting from 2018-08-01
    upon calling `principal.curve()` or `get.lam()`.

## Test environments
* local Fedora 28 install, R 3.5.0
* OS X (on travis-ci), R 3.5.0
* Ubuntu 14.04 (on travis-ci), R 3.5.0
* Windows (on appveyor), R 3.5.0
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
