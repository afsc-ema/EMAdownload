#' @title Get ema taxa
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#' @param force_download Bypass cache and force download
#'
#' @returns returns look up table of species taxonomy
#' @export
#' @importFrom tidyselect where

get_ema_taxonomy <- function(force_download = FALSE) {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/lut_trawl_species_tsn?"

  data.tmp <- .ema_downloader(url = url, name = "taxonomy", force_download)

  #dat <- jsonlite::fromJSON(data.tmp, flatten = TRUE)

  # Replace U+00BF with regular spaces in character columns
  dat <- as.data.frame(data.tmp) |>
    dplyr::mutate(
      dplyr::across(
        where(~ is.character(.x) | is.factor(.x)), # Targets both types
        ~ stringr::str_replace_all(as.character(.x), "\u00BF", " ")
      )
    )

  data <- dat |>
    dplyr::rename_with(tolower)


  return(data)
}

