#' @title Get EMA catch table
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#' It includes parameters to control start and end year, gear type, and TSN (species code)
#'
#' @param force_download Bypass cache and force download
#' @returns a dataframe with all trawl related catch information
#' @export


get_ema_catch <- function(force_download = FALSE) {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/catch?"


  #use internal function to download and cache data
  data.tmp <- .ema_downloader(url = url, name = "catch", force_download)
  data <- data.tmp |>
    dplyr::rename_with(tolower) |> # rename all to lower case
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear)) # fix typo in the db

  return(data)

}



