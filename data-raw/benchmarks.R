library(princurve)
library(tidyverse)
library(microbenchmark)

set.seed(1)

# create a toy dataset
num_points <- round(10^seq(log10(100), log10(100000), length.out = 25))
lambda <- rnorm(max(num_points), 0, .2)
x <- cbind(lambda, lambda^2) + rnorm(length(lambda) * 2, 0, .02)
lambda <- sort(lambda)

# run benchmarks
benchmarks <- map_df(
  rev(num_points),
  function(np) {
    xsel <- x[seq_len(np),]
    microbenchmark::microbenchmark(
      "princurve1.1" = princurvelegacy::principal.curve(xsel),
      "princurve2.1" = princurve::principal_curve(xsel, approx_points = 100),
      times = 10L,
      unit = "ms"
    ) %>%
      summary() %>%
      as_data_frame() %>%
      mutate(num_points = np)
  }
)

# save data
devtools::use_data(benchmarks)
