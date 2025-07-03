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
#'
#'
#' @export


get_ema_fish <- function() {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/fish?"
  #basic function to pull a url
  response <- httr::GET(url=url)

  # use jasonlite and the parameters we are setting above to pull data
  data <- jsonlite::fromJSON(
    httr::content(response, type = "text", encoding = "UTF-8")) |>
    dplyr::bind_rows() |>
    rename_with(tolower)

  return(data)

}
