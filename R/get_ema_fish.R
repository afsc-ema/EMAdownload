#' @title Get EMA fish specimen data with event information
#'
#' @description This function pulls specimen level data with associated event information from
#' ecosystem survey data (from EMA surveys) from the AKFIN data server.
#' It includes parameters to control start and end year, gear type, and TSN (species code).
#'
#' You may want to catch weight the specimen data in which case you should use the join_event_catch
#' function to get the associated catch information. You then join on station ID, event code, and
#' event code.
#'
#' @param force_download Bypass cache and force download
#' @returns a dataframe with all specimen data
#' @export


get_ema_fish <- function(force_download) {
  #basic function to pull a url has api filter on it
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/fish"
  #  create single and multiple species query with the tsn arg
  #message("Querying fish data, may take a few minutes...")

  data.tmp <- .ema_downloader(url = url, name = "fish", force_download)
  data <- data.tmp |>
    dplyr::rename_with(tolower)


  return(data)

}

