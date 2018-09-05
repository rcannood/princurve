# analogue

Version: 0.17-0

## Newly broken

*   checking examples ... WARNING
    ```
    ...
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
      Warning: 'get.lam' is deprecated.
    Deprecated functions may be defunct as soon as of the next release of
    R.
    See ?Deprecated.
    ```

# aroma.light

Version: 3.10.0

## Newly broken

*   checking examples ... WARNING
    ```
    Found the following significant warnings:
    
      Warning: 'principal.curve' is deprecated.
      Warning: 'principal.curve' is deprecated.
    Deprecated functions may be defunct as soon as of the next release of
    R.
    See ?Deprecated.
    ```

## In both

*   checking for hidden files and directories ... NOTE
    ```
    Found the following hidden files and directories:
      inst/rsp/.rspPlugins
    These were most likely included in error. See section ‘Package
    structure’ in the ‘Writing R Extensions’ manual.
    ```

# FateID

Version: 0.1.4

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    Error in re-building vignettes:
      ...
    Error running filter pandoc-citeproc:
    Could not find executable pandoc-citeproc
    Error: processing vignette 'FateID.Rmd' failed with diagnostics:
    pandoc document conversion failed with error 83
    Execution halted
    ```

# lilikoi

Version: 0.1.0

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  5.0Mb
      sub-directories of 1Mb or more:
        data      3.8Mb
        extdata   1.1Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘Matrix’ ‘devtools’ ‘e1071’ ‘glmnet’ ‘hash’ ‘pamr’ ‘randomForest’
      All declared Imports should be used.
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 3837 marked UTF-8 strings
    ```

# pathifier

Version: 1.20.0

## In both

*   checking R code for possible problems ... NOTE
    ```
    .getpathway: no visible global function definition for ‘var’
    .samplings_stdev: no visible binding for global variable ‘sd’
    .score_pathway: no visible binding for global variable ‘sd’
    .score_pathway: no visible global function definition for ‘aggregate’
    .score_pathway: no visible global function definition for ‘dist’
    quantify_pathways_deregulation: no visible binding for global variable
      ‘sd’
    quantify_pathways_deregulation: no visible global function definition
      for ‘prcomp’
    Undefined global functions or variables:
      aggregate dist prcomp sd var
    Consider adding
      importFrom("stats", "aggregate", "dist", "prcomp", "sd", "var")
    to your NAMESPACE file.
    ```

# RSDA

Version: 2.0.5

## In both

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘randomcoloR’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

