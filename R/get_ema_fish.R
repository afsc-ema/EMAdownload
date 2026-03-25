#' @title Get EMA fish specimen data
#'
#' @description This function pulls specimen level data from
#' ecosystem survey data (from EMA surveys) from the AKFIN data server.
#'
#'
#' @param force_download Bypass cache and force download
#' @returns a dataframe with all specimen data
#' @export


get_ema_fish <- function(force_download = FALSE) {
  #basic function to pull a url has api filter on it
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/fish"
  #  create single and multiple species query with the tsn arg
  #message("Querying fish data, may take a few minutes...")

  data.tmp <- .ema_downloader(url = url, name = "fish", force_download)
  data <- data.tmp |>
    dplyr::rename_with(tolower)


  return(data)

}

