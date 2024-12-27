# input_df <- targets::tar_read('sample_data')
# ncores <- 10
# input_df <- input_df[1:10,]

# geocodebr
geocodebr_fun <- function(input_df){

  fields <- geocodebr::setup_address_fields(
    logradouro = 'logradouro',
    numero = 'numero',
    cep = 'cep',
    bairro = 'bairro',
    municipio = 'municipio',
    estado = 'uf'
  )

  geocodebr_output <- geocodebr:::geocode(
    addresses_table = input_df,
    address_fields = fields,
    n_cores = getOption("TARGETS_N_CORES"),
    progress = F
  )

  return(geocodebr_output)
}

# geocodebr_main_like <- function(){
#   fields <- geocodebr::setup_address_fields(
#     logradouro = 'logradouro',
#     numero = 'numero',
#     cep = 'cep',
#     bairro = 'bairro',
#     municipio = 'municipio',
#     estado = 'uf'
#   )
#
#
#   geocodebr_output_like <- geocodebr:::geocode_like(
#     addresses_table = input_df,
#     address_fields = fields,
#     n_cores = ncores,
#     progress = F
#   )
# }



# geocodepro

geocodepro_fun <- function(input_df){

  # reticulate::use_condaenv(
  #   "C://Program Files/ArcGIS/Pro/bin/Python/envs/arcgispro-py3"
  # )

  localizador <- paste0(
    "C://StreetMap/NewLocators/BRA_",
    getOption("TARGETS_N_CORES"),
    "/BRA.loc"
  )

  fields <- geocodepro::address_fields_const(
    Address_or_Place = "logradouro_com_numero",
    Neighborhood = "bairro",
    City = "municipio",
    State = "uf",
    ZIP = "cep")


  geocodepro_output <- geocodepro::geocode(
    locations =  input_df,
    locator = localizador,
    cache = FALSE,
    address_fields = fields
  )

  return(geocodepro_output)
}
