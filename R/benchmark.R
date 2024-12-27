# input_df <- targets::tar_read('sample_data')
# ncores <- 10

benchmark_time <- function(input_df){



  # benchmark ----------------------------------------------------------

  # bm <- bench::mark(
  #   geocodebr = geocodebr_fun(),
  #   geocodepro = geocodepro_fun(),
  #   check = F,
  #   iterations  = 10
  # )

  bm <- microbenchmark::microbenchmark(
    geocodebr = geocodebr_fun(input_df),
    arcgis = geocodepro_fun(input_df),
    times  = 10
  )

#  bm <- head(input_df)

  return(bm)

}
