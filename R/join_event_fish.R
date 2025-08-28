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
#' @param survey_region Optional filter for survey region.  Defaults to all regions. Options are "SEBS", "NBS", "Chukchi", and "GOA"  Can take vector of multiple regions.
#' This filter is based on classification of large marine ecosystem and latitude with the separation between the Northern and Southern Bering Sea at 59.9 N
#' The seperation between NBS and Chukchi is at 65.5. Stations are sorted into region rather than survey objective (i.e. the survey
#' may be a survey to go to the "Chukchi", but if some stations occurred in the Northern Bering Sea those stations get classified as NBS stations).
#' @param trawl_method Optional filter for trawl or tow method (i.e. surface, midwater, oblique, live box (surface trawl with a live box), fishing power comparison, or diel tows)
#' See look up table for full explanation of category. Default to "S" or surface tow.
#'
#' @returns Returns a data frame of event information with specimen data (lengths, weights, special samples taken)
#'
#' @export

join_event_fish <- function(start_year=2003, end_year=3000, survey_region=NA, tsn=NA,
                             gear=c("CAN", "Nor264"), trawl_method = "S")  {

  # if else function looks for "fish", "event", "event_parameters" or "taxa" files in local environment before
  # re-downloading them from AkFIN via the API
  if(all(exists("fish"),exists("event"),exists("event_parameters"),exists("taxa"))) {
    warning("Local data files exist. Formatting file from those exports")
  }else {

  # download tables from AKFIN
  event <- get_ema_event() |> # tolower done in get_ema_event, same with adding region
    dplyr::filter(!(gear_performance %in% c("A", "U")))
  fish <- get_ema_fish()
  taxa <- get_ema_taxonomy()
  event_parameters <- get_ema_event_parameters()
  }

  # saves a list of data files to the global environment so you don' thave to download everytime
  df_list <- list(fish, event, event_parameters, taxa)
  names(df_list) <- c("fish", "event", "event_parameters", "taxa")
  list2env(df_list, envir=.GlobalEnv)

  # gear filter - only allow gears present in catch table
  if(all(gear %in% unique(fish$gear))){
    gear_vec <- c(gear)
  } else {
    stop("Gear type must be CAN, MAR, NETS156, Nor264")
  }

  # option trawl method/tow type
  if(all(trawl_method %in% unique(event$tow_type))) {
    trawl_vec <- c(trawl_method)
  } else {
    stop("Trawl method must be O, V, S, M, L, D, FP, B. See EMA look up tables for tow type descriptions")
  }

  # option tsn filter - only allows tsns present in taxa table
  # ie not necessarily in the fish table (for a given gear/tow type) but it is in the taxa table
  if(all(tsn %in% unique(taxa$species_tsn))){
    tsn_vec <- c(tsn)
  } else {
    if(is.na(tsn)) {
      tsn_vec <- c(unique(fish$species_tsn))
      } else {
        stop("Invalid tsn number")
      }
    }



  # error message if start year not within range
  if(start_year < 2002) {
    stop("Start year not within acceptable range, try 2002 - present")
  }
  # error message if end year not within range
  if(end_year < 2002) {
    stop("Start year not within acceptable range, try 2002 - present")
  }

  # Optional survey region filter - defaults to survey_region = NA
  # this is a way of dealing with the "NA" in region column that get generated when we created region above
  # these four lines can be removed if the lat/lon information gets fixed at those four stations
  if(all(survey_region %in% unique(stats::na.omit(event$region)))){
    survey_vec <- c(survey_region)
  } else {
    if(is.na(survey_region)){
      survey_vec <- c(unique(event$region))
    } else {
      stop("Survey region must be one or more of: NBS, SEBS, GOA, or Chukchi")
    }
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
                    sample_year <= end_year &
                    gear %in% gear_vec &
                    tow_type %in% trawl_vec &
                    region %in% survey_vec) |>
    dplyr::right_join(fish2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::left_join(event_parameters, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::rename(notes = notes.y) |>
    dplyr::select(sample_year, cruise_id, event_code, station_id, gear, gear_performance, tow_type,
                  nbs_strata, oceanographic_domain,large_marine_ecosystem, region, eq_latitude, eq_longitude,
                  species_tsn, common_name, scientific_name, lhs_code, salmon_maturity, sex,
                  length, length_type, weight, scale_card_number, scale_card_position, otolith_number,
                  stomach_flag, genetic_number, genetic_flag, notes, fish_number,
                  scale_position_pref_code, gonad_weight, caloric_number, isotope_number, stomach_number, barcode,
                  fat_meter)

  print(paste("Last AKFIN fish table upload date", unique(fish$akfin_load_date)))
  return(data)
}
