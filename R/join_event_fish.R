#' @title Get EMA fish specimen data with event information
#'
#' @description This function pulls specimem level data with associated event information from
#' ecosystem survey data (from EMA surveys) from the AKFIN data server.
#' It includes parameters to control start and end year, gear type, and TSN (species code).
#'
#' You may want to catch weight the specimen data in which case you should use the join_event_catch
#' function to get the associated catch information. You then join on station ID, event code, and
#' event code.
#'
#' @export


join_event_fish <- function(start_year=2002, end_year=3000, tsn=NA,
                             gear= "CAN") {
  # download tables from AKFIN
  event <- get_ema_event() |> dplyr::rename_with(tolower) |>
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear)) # fix gear typo in db
  fish <- get_ema_fish() |> dplyr::rename_with(tolower)
  taxa <- get_ema_taxonomy() |> dplyr::rename_with(tolower)
  event_parameters <- get_ema_event_parameters() |> dplyr::rename_with(tolower)


  # gear filter - only allow gears present in catch table
  if(all(gear %in% unique(fish$gear))){
    gear_vec <- c(gear)
    message("Using default gear type: CAN")
  } else {
    stop("Gear type must be CAN, MAR, NETS156, Nor264")
  }

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
    fish2 <-fish |>
      dplyr::left_join(taxa, by="species_tsn")
  } else {
    fish2 <-fish |>
      dplyr::inner_join(taxa |> dplyr::filter(species_tsn=tsn), by="species_tsn")
  }

  # join into one data frame
  data <- event |>
    dplyr::filter(sample_year >=start_year &
                    sample_year <= end_year
                  & gear %in% gear_vec) |>
    dplyr::left_join(fish2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::left_join(event_parameters, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::rename(notes = notes.y) |>
    dplyr::select(sample_year, cruise_id, event_code, station_id, gear, gear_performance, tow_type,
                  nbs_strata, oceanographic_domain,large_marine_ecosystem, eq_latitude, eq_longitude,
                  species_tsn, common_name, scientific_name, lhs_code, salmon_maturity, sex,
                  length, length_type, weight, scale_card_number, scale_card_position, otolith_number,
                  stomach_flag, genetic_number, genetic_flag, notes, fish_number,
                  scale_position_pref_code, gonad_weight, caloric_number, isotope_number, stomach_number, barcode,
                  fat_meter)

  print(paste("Last AKFIN catch upload date", unique(fish$akfin_load_date)))
  return(data)
}
