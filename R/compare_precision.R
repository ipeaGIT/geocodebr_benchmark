# geocodebr_output <- targets::tar_read('geocodebr_output')
# geocodepro_output <- targets::tar_read('geocodepro_output')

compare_precison <- function(geocodebr_output, geocodepro_output){

  # rename columns
  data.table::setDT(geocodebr_output)
  data.table::setDT(geocodepro_output)

  data.table::setnames(
    x = geocodebr_output,
    old = c('lat', 'lon', 'match_type'),
    new = c('lat_br', 'lon_br', 'match_type_br'))

  geocodepro_output <- sfheaders::sf_to_df(geocodepro_output, fill = T)
  data.table::setnames(
    x = geocodepro_output,
    old = c('y', 'x', 'Addr_type'),
    new = c('lat_pro', 'lon_pro', 'match_type_pro'))


# join tables
df <- left_join(geocodebr_output, geocodepro_output, by = 'id')

df[, match_type_br := gsub('case_', '', match_type_br) ]
df[, match_type_pro := ifelse(match_type_pro=="", "not found", match_type_pro) ]


df_long <- df[, .(count = .N /nrow(df)*100),
              by = .(match_type_br, match_type_pro)
              ][order(match_type_br)]

# count performance in each
df_br <- df[, .(count = .N /nrow(df)*100), by = .(match_type_br)][order(match_type_br)]
df_pro <- df[, .(count = .N /nrow(df)*100), by = .(match_type_pro)][order(match_type_pro)]


df_equivalencia <- data.frame(
  br = c('cat_01|02|03|04', 'cat_05|06|07|08', 'cat_09|10', 'cat_11|12', 'others', 'not found'),
  pro = c('PointAddress', 'StreetAddress|StreetAddressExt|StreetName', 'PostalLoc|PostalExt|Postal', 'Locality',
          'POI', 'not found')
)


return(df_long)

}



