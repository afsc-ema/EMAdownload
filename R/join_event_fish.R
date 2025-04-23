#' @title Get EMA fish specimen data with event information
#'
#' @description This function pulls specimen level data with associated event information from
#' ecosystem survey data (from EMA surveys) from the AKFIN data server.
#' It includes parameters to control start and end year, gear type, and TSN (species code).
#'
#' This function, by nature of the type of data it returns, only provides specimen data for locations
#' where positive catch
#'
#' You may want to catch weight the specimen data in which case you should use the join_event_catch
#' function to get the associated catch information. You then join on station ID, event code, and
#' gear code.
#'
#' @param start_year Optional filter for start year, valid range 2002 to present defaults to 2002
#' @param end_year Optional filter for end year, valid range 2002 to present defaults to 3000
#' @param tsn Optional filter for species taxonomic serial number (from ITIS.gov), defaults to all species in database. Can take vectors of species tsn
#' @param gear Optional filter for gear type, options are CAN, MAR, NETS156, Nor64, defaults to CAN. Can take vector of multiple gear types
#'
#' @returns Returns a data frame of event information with specimen data (lengths, weights, special samples taken)
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
  } else {
    stop("Gear type must be CAN, MAR, NETS156, Nor264")
  }

  if(all(tsn %in% unique(taxa$species_tsn))){
    tsn_vec <- c(tsn)
  } else {
    stop("Invalid tsn number")
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
  if(anyNA(tsn_vec)) {
    fish2 <- fish |>
      dplyr::left_join(taxa, by="species_tsn")
  } else {
    fish2 <- fish |>
      dplyr::inner_join(taxa |> dplyr::filter(species_tsn %in% tsn_vec), by="species_tsn")
  }

  # join into one data frame
  data <- event |>
    dplyr::filter(sample_year >=start_year &
                    sample_year <= end_year
                  & gear %in% gear_vec) |>
    dplyr::right_join(fish2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
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
