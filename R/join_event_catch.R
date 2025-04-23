#' @title Get EMA catch and event data
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#' It includes parameters to control start and end year, gear type, and TSN (species code)
#'
#' @export


join_event_catch <- function(start_year=2002, end_year=3000, tsn=NA,
                             gear= "CAN") {
  # download tables from AKFIN
  event <- get_ema_event() |> dplyr::rename_with(tolower) |>
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear)) # fix gear typo in db
  catch <- get_ema_catch() |> dplyr::rename_with(tolower) |>
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear)) # fix gear typo in db
  taxa <- get_ema_taxonomy() |> dplyr::rename_with(tolower)
  event_parameters <- get_ema_event_parameters() |> dplyr::rename_with(tolower)

  # gear filter - only allow gears present in catch table
  if(all(gear %in% unique(catch$gear))){
    gear_vec <- c(gear)
  } else {
    stop("Gear type must be CAN, MAR, NETS156, Nor264")
  }

  # if(is.na(gear)) {
  #   gear_vec <- unique(catch$gear)
  # } else {
  #   gear_vec <- c(gear)
  # }

  # error message if start year not within range
  if(start_year < 2002) {
    stop("Start year not within acceptable range, try 2002 - present")
  }
    # error message if end year not within range
  if(end_year < 2002) {
    stop("Start year not within acceptable range, try 2002 - present")
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
    dplyr::mutate(haulback_time = lubridate::ymd_hms(haulback_time),
                  eq_time = lubridate::ymd_hms(eq_time),
                  tow_duration = difftime(haulback_time, eq_time, units = "mins")) |>
    dplyr::select(sample_year, cruise_id, event_code, station_id, gear, gear_performance, tow_type, nbs_strata, oceanographic_domain,
                  large_marine_ecosystem, eq_latitude, eq_longitude,
                  effort, effort_units, tow_duration,
                  species_tsn, common_name, scientific_name, lhs_code, total_catch_number, total_catch_weight)

  print(paste("Last AKFIN catch upload date", unique(catch$akfin_load_date)))
  return(data)
}


