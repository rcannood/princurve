Benchmarking princurve
================
Robrecht Cannoodt

<!-- github markdown using
rmarkdown::render("vignettes/benchmarks.Rmd", output_format = "github_document")
-->
princurve 2.1 contains major optimisations if the `approx_points` parameter is used. This is showcased on a toy example, where the number of points was varied between 10<sup>2</sup> and 10<sup>6</sup>.

We can see princurve 2.1 scales linearly w.r.t. the number of rows in the dataset, whereas princurve 1.1 scales quadratically. This is due to the addition of the approximation step added in between the smoothing and the projection steps (explained in more detail in [benchmarks.md](benchmarks.md)). ![](benchmarks_files/figure-markdown_github/compare-1.png)
