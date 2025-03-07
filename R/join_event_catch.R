#' @title Get EMA catch and event data
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#' It includes parameters to control start and end year, gear type, and TSN (species code)
#'
#' @export


get_ema_event_catch <- function(start_year=1990, end_year=3000, tsn=NA, gear=NA) {
  # download tables from AKFIN
  event <- get_ema_event() |> dplyr::rename_with(tolower)
  catch <- get_ema_catch() |> dplyr::rename_with(tolower)
  taxa <- get_ema_taxonomy() |> dplyr::rename_with(tolower)
  event_parameters <- get_ema_event_parameters() |> dplyr::rename_with(tolower)

  # optional gear filter
  if(is.na(gear)) {
    gear_vec<- unique(event$gear)
  } else {
    gear_vec<-c(gear)
  }

  # optional tsn filter
  if(is.na(tsn)) {
    catch2 <-catch |>
      dplyr::left_join(taxa, by="species_tsn")
  } else {
    catch2 <-catch |>
      dplyr::inner_join(taxa |> dplyr::filter(species_tsn=tsn), by="species_tsn")
  }

  # join into one data frame
  data <- event |>
    dplyr::filter(sample_year >=start_year &
             sample_year <= end_year
           & gear %in% gear_vec) |>
    dplyr::left_join(catch2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::left_join(event_parameters, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::select(sample_year, event_code, station_id, gear, gear_performance, tow_type, eq_latitude, eq_longitude, effort, species_tsn, common_name, scientific_name, total_catch_number, total_catch_weight)

  return(data)
}


