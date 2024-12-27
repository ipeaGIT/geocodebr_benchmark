options(
  TARGETS_VERBOSE = TRUE,
  TARGETS_N_CORES = 10 # ver opcoes disponiveis em C:\StreetMap\NewLocators
)
data.table::setDTthreads(getOption("TARGETS_N_CORES"))

suppressPackageStartupMessages({
  library(geocodebr)
  library(targets)
  library(dplyr)
  library(bench)
  library(data.table)
  library(duckdb)
  library(ggplot2)
  # library(ipeadatalake)
  # library(arrow)
  #library(reticulate)
  #library(geocodepro)
})


# Run the R scripts in the R/ folder with your custom functions:
# tar_source('./R/python_env.R')
tar_source('./R/sample_data.R')
tar_source('./R/benchmark.R')
tar_source('./R/geocode_functions.R')
tar_source('./R/figure_time.R')
tar_source('./R/compare_precision.R')

tar_option_set(seed = 42)

# reticulate::use_condaenv("C://Program Files/ArcGIS/Pro/bin/Python/envs/arcgispro-py3")



# targets
list(

    tar_target(
    name = sample_data,
    command = generate_sample_data(sample_size=100000),
    format = "rds" # Efficient storage for general data objects.
  ),

  tar_target(
    name = geocodebr_output,
    command = geocodebr_fun(input_df=sample_data),
    format = "rds" # Efficient storage for general data objects.
   ),

  tar_target(
    name = geocodepro_output,
    command = geocodepro_fun(input_df=sample_data),
    format = "rds" # Efficient storage for general data objects.
  ),

  tar_target(
    name = benchmark_time,
    command = benchmark_time(input_df=sample_data),
    format = "rds" # Efficient storage for general data objects.
  ),

  tar_target(
    name = fig_benchmark_time,
    command = figure_time(bm=benchmark_time)
  ),

  tar_target(
    name = compare_result_categories,
    command = compare_precison(geocodebr_output, geocodepro_output),
    format = "rds" # Efficient storage for general data objects.
  )


)
