#' @title Get ema event table
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#'
#' @param force_download Bypass cache and force download
#' @returns a dataframe with all calculated event parameters
#'
#' @export


get_ema_event_parameters <- function(force_download = FALSE) {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/event_parameters?"


  # use internal function to download and cache data
  data.tmp <- .ema_downloader(url = url, name = "event_parameters", force_download)
  data <- data.tmp |>
    dplyr::bind_rows() |>
    dplyr::rename_with(tolower) # rename to lower

  return(data)

}

