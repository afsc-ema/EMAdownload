#' @title Get EMA catch table
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#' It includes parameters to control start and end year, gear type, and TSN (species code)
#'
#' @export


get_ema_catch <- function() {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/catch?"
  #basic function to pull a url
  response <- httr::GET(url=url)

  # use jasonlite and the parameters we are setting above to pull data
  data <- jsonlite::fromJSON(
    httr::content(response, type = "text", encoding = "UTF-8")) |>
    dplyr::bind_rows() |>
    dplyr::rename_with(tolower) |> # rename all to lower case
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear)) # fix typo in the db

  return(data)

}



