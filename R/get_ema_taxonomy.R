#' @title Get ema taxa
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#'
#' @export


get_ema_taxonomy <- function() {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/lut_trawl_species_tsn?"
  #basic function to pull a url
  response <- httr::GET(url=url)

  # use jasonlite and the parameters we are setting above to pull data
  data <- jsonlite::fromJSON(
    httr::content(response, type = "text", encoding = "UTF-8")) |>
    dplyr::bind_rows() |>
    dplyr::rename_with(tolower) # rename to lower

  return(data)

}

