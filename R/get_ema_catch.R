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


#start_year= 2024; end_year = 2024; tsn ="all"; gear = "all"

# get_ema_catch <- function(start_year, end_year, tsn, gear) {
#   # based on Matt Callahan's code
#   # define queries to pass to url (akfin api)
#   # remove parameters that should return all values
#   query <- list(
#     tsn = if (length(tsn) == 1 && tsn == "all") NULL else paste(tsn, collapse=","),
#     gear = if (length(gear) == 1 && gear == "all") NULL else paste(gear, collapse=","),
#     start_year = start_year,
#     end_year = end_year
#   )
#   # Remove NULL entries from the query list
#   query <- query[!sapply(query, is.null)]
#
#   # base url for the api pull
#   url <- "https://apex.psmfc.org/akfin/data_marts/ema/event_catch?"
#
#   # basic function to pull a url
#   response <- httr::GET(url=url, query=query)
#
#   # use jasonlite and the parameters we are setting above to pull data
#   data <- jsonlite::fromJSON(
#     httr::content(response, type = "text", encoding = "UTF-8")) |>
#     dplyr::bind_rows()
#
#   return(data)
#
# }
