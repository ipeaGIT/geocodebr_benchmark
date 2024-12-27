# bm <- targets::tar_read('benchmark_time')

figure_time <- function(bm){

  # get mean and median
  bm_df <- as.data.table(bm)
  bm_df[, time_secs := time/1000000000]

  bm_df2 <- bm_df[, .(median = round(median(time_secs),1),
                      mean = round(mean(time_secs),1)
  ), by=expr]

  max_time <- max(bm_df2$mean) + 5

  fig_time <- ggplot() +
    # geom_violin(data=bm_df, aes(x=expr, y=time_secs), fill=NA) +
    geom_boxplot(data=bm_df, aes(x=expr, y=time_secs)) +
    geom_label(data=bm_df2, aes(x=expr, label=median, y=median+5), color='red') +
    labs(y='Time (seconds)', x='') +
    scale_y_continuous(limits = c(0, max_time)) +
    theme_classic()

  ggsave(plot = fig_time, './figures/fig_time.png',
         width = 15, height = 15, units = 'cm')

  #return(fig_time)
}
