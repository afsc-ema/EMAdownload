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
#' @param force_download forces a redownload of data directly from AKFINs API rather than using a cached version of the data. This argument will force a re-download of all data not just event or catch
#'
#' @returns Returns a data frame of event information with specimen data (lengths, weights, special samples taken)
#'
#' @export

join_event_fish <- function(start_year=2003, end_year=3000, survey_region=NA, tsn=NA,
                             gear=c("CAN", "Nor264"), trawl_method = "S", force_download = FALSE)  {


  # download tables from AKFIN
  evnt <- get_ema_event(force_download) |> # tolower done in get_ema_event, same with adding region
    dplyr::filter(!(gear_performance %in% c("A", "U"))) |>
    dplyr::rename(event_notes = notes)
  fsh <- get_ema_fish(force_download) |>
    dplyr::rename(specimen_notes = notes)
  taxa <- get_ema_taxonomy(force_download) |>
    dplyr::rename(taxa_notes = notes)
  event_parameters <- get_ema_event_parameters(force_download)


### go through basic checks ###
  # gear filter - only allow gears present in catch table
  if(all(gear %in% unique(fsh$gear))){
    gear_vec <- c(gear)
  } else {
    stop("Gear type must be CAN, MAR, NETS156, Nor264")
  }

  # option trawl method/tow type
  if(all(trawl_method %in% unique(evnt$tow_type))) {
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
      tsn_vec <- c(unique(fsh$species_tsn))
      } else {
        stop("Invalid tsn number")
      }
    }



  # error message if start year not within range
  if(start_year < 2003) {
    stop("Start year not within acceptable range, try 2003 - present")
  }
  # error message if end year not within range
  if(end_year < 2003) {
    stop("End year not within acceptable range, try 2003 - present")
  }

  # Optional survey region filter - defaults to survey_region = NA
  # this is a way of dealing with the "NA" in region column that get generated when we created region above
  # these four lines can be removed if the lat/lon information gets fixed at those four stations
  if(all(survey_region %in% unique(stats::na.omit(evnt$region)))){
    survey_vec <- c(survey_region)
  } else {
    if(is.na(survey_region)){
      survey_vec <- c(unique(evnt$region))
    } else {
      stop("Survey region must be one or more of: NBS, SEBS, GOA, or Chukchi")
    }
  }

  # optional tsn filter
  if(anyNA(tsn_vec)) {
    fish2 <- fsh |>
      dplyr::left_join(taxa, by="species_tsn")
  } else {
    fish2 <- fsh |>
      dplyr::inner_join(taxa |> dplyr::filter(species_tsn %in% tsn_vec), by="species_tsn")
  }

  # join into one data frame
  data <- evnt |>
    dplyr::filter(sample_year >= start_year &
                    sample_year <= end_year &
                    gear %in% gear_vec &
                    tow_type %in% trawl_vec &
                    region %in% survey_vec) |>
    # fish2 is the specimen level data with the appropriate taxonomic names; because the fish is a left join
    # we keep all the correct event level info but then get NAs if we have a tsn filter so we have to make sure we filter on the
    # tsn here too
    dplyr::left_join(fish2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::filter(species_tsn %in% tsn_vec) |>
    dplyr::left_join(event_parameters, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    #dplyr::rename(notes = notes.y) |>
    dplyr::select(sample_year, haul_date, cruise_id, event_code, station_id, gear, gear_performance, tow_type,
                  nbs_strata, master_station_name, oceanographic_domain, large_marine_ecosystem, region, eq_latitude, eq_longitude,
                  species_tsn, common_name, scientific_name, lhs_code, salmon_maturity, sex,
                  length, length_type, weight, scale_card_number, scale_card_position, otolith_number,
                  stomach_flag, genetic_number, genetic_flag, fish_number,
                  scale_position_pref_code, gonad_weight, caloric_number, isotope_number, stomach_number, barcode,
                  fat_meter, event_notes, specimen_notes)

  print(paste("Last AKFIN fish table upload date", unique(fsh$akfin_load_date)))
  return(data)
}
