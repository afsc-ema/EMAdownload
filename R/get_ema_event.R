#' @title Get ema event table
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#'
#' @export


get_ema_event<- function() {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/event?"
  #basic function to pull a url
  response <- httr::GET(url=url)

  # use jasonlite and the parameters we are setting above to pull data
  data.tmp <- jsonlite::fromJSON(
    httr::content(response, type = "text", encoding = "UTF-8")) |>
    dplyr::bind_rows()

  data <- data.tmp |>
    dplyr::rename_with(tolower) |>
    dplyr::mutate(
      #gear = ifelse(gear == "NOR64", "Nor64", gear), # fix gear typo in db
                  ###This code adds a "region" field.  Note that this region only effectively works for trawls since CTD/CAT stations store lat in a different field.
                  # There's one NETS trawl from 2016 but it's aborted so I don't care about it.
                  #large_marine_ecosystem = ifelse(large_marine_ecosystem == "Chuckchi", "Chukchi", large_marine_ecosystem),
                  region = dplyr::case_when(eq_latitude <= 59.9 & !(large_marine_ecosystem == "GOA") ~ "SEBS",
                                            eq_latitude > 59.9 & eq_latitude <= 65.5 & !(large_marine_ecosystem == "GOA") ~ "NBS",
                                            eq_latitude > 65.5 ~ "Chukchi",
                                            large_marine_ecosystem=="GOA" ~ "GOA")) |>
    dplyr::mutate(region = ifelse(is.na(region),
                                  dplyr::case_when(gear_in_latitude <= 59.9 & !(large_marine_ecosystem == "GOA") ~ "SEBS",
                                                   gear_in_latitude > 59.9 & gear_in_latitude <= 65.5 & !(large_marine_ecosystem == "GOA") ~ "NBS",
                                                   gear_in_latitude > 65.5 ~ "Chukchi",
                                                   large_marine_ecosystem == "GOA" ~ "GOA"), region))
  # as of 5-5-25 there are four CTD/CAT/Bongo events that have no associated lat/lon that are just going to have to stay for now
  return(data)

}
