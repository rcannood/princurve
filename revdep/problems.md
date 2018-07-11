# aroma.light

Version: 3.10.0

## In both

*   checking for hidden files and directories ... NOTE
    ```
    Found the following hidden files and directories:
      inst/rsp/.rspPlugins
    These were most likely included in error. See section ‘Package
    structure’ in the ‘Writing R Extensions’ manual.
    ```

# ClusterSignificance

Version: 1.8.0

## Newly fixed

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      missing value where TRUE/FALSE needed
      1: pcp(mat, groups) at testthat/test_projection-methods.R:86
      2: pcp(mat, groups)
      3: .local(mat, ...)
      4: .Curve(mat, groups, df)
      5: principal.curve(mat, maxit = 1000, df = df)
      6: principal_curve(x = x, start = start, thresh = thresh, maxit = maxit, stretch = stretch, smoother = smoother, trace = trace, plot_iterations = plot.true, ...)
      
      ══ testthat results  ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
      OK: 28 SKIPPED: 0 FAILED: 2
      1. Error: check that all ouput from princurve is ordered as expected (@test_projection-methods.R#52) 
      2. Error: check that  princurve is correct (@test_projection-methods.R#86) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

## In both

*   checking for hidden files and directories ... NOTE
    ```
    Found the following hidden files and directories:
      .travis.yml
    These were most likely included in error. See section ‘Package
    structure’ in the ‘Writing R Extensions’ manual.
    ```

# pathifier

Version: 1.18.0

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘pathifier-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: pathifier-package
    > ### Title: Quantify deregulation of pathways in cancer
    > ### Aliases: pathifier-package pathifier
    > ### Keywords: package
    > 
    > ### ** Examples
    > 
    > data(KEGG) # Two pathways of the KEGG database 
    > data(Sheffer) # The colorectal data of Sheffer et al.
    > PDS<-quantify_pathways_deregulation(sheffer$data, sheffer$allgenes,
    +   kegg$gs, kegg$pathwaynames, sheffer$normals, attempts = 100,
    +   logfile="sheffer.kegg.log", min_exp=sheffer$minexp, min_std=sheffer$minstd)
    Error in project_to_curve(x = x, s = start, stretch = stretch) : 
      Expecting a single value: [extent=50].
    Calls: quantify_pathways_deregulation ... principal.curve -> principal_curve -> project_to_curve
    Execution halted
    ```

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

*   checking re-building of vignette outputs ... NOTE
    ```
    Error in re-building vignettes:
      ...
    
    Error: processing vignette 'Overview.Rnw' failed with diagnostics:
     chunk 4 
    Error in project_to_curve(x = x, s = start, stretch = stretch) : 
      Expecting a single value: [extent=50].
    Execution halted
    ```

