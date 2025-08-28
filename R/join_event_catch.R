#' @title Get EMA catch and event data
#'
#' @description This function queries and joins event and catch data hosted on AKFIN collected from Ecosystem Monitoring and Assessment (EMA) surveys.
#' It includes parameters to control start and end year, gear type, survey region, trawl method, tsn (taxonomic serial number),
#' lhs code (life history stage), and whether or not to calculate catch0 (true/false)
#'
#' @param start_year Optional filter for start year, valid range 2003 to present, defaults to 2003
#' @param end_year Optional filter for end year, valid range 2002 to present, defaults to 3000
#' @param survey_region Optional filter for survey region.  Defaults to all regions. Options are "SEBS", "NBS", "Chukchi", and "GOA"  Can take vector of multiple regions.
#' This filter is based on classification of large marine ecosystem and latitude with the separation between the Northern and Southern Bering Sea at 59.9 N
#' The seperation between NBS and Chukchi is at 65.5. Stations are sorted into region rather than survey objective (i.e. the survey
#' may be a survey to go to the "Chukchi", but if some stations occurred in the Northern Bering Sea those stations get classified as NBS stations).
#' @param tsn Filter for species taxonomic serial number (from ITIS.gov), defaults to all species in database. Can take vectors of species tsns.
#' This parameter is optional if catch0=FALSE, but is required if catch0=TRUE.  Use get_ema_taxonomy function to see full list of TSNs.
#' @param lhs Optional filter for species life history stage.  For salmon species, options are IM or J. For all other species, see values in EMA-lookup-table.
#' @param gear Optional filter for gear type, options are CAN, MAR, NETS156, Nor64, defaults to CAN & Nor64 (which are all surface trawls).
#' Can take vector of multiple gear types
#' @param catch0 Optional argument that indicates whether data should include 0-catches (i.e. stations that were fished where no species/lhs combinations were caught).
#' Defaults to false if no argument entered. However, when catch0 == FALSE it will give you any events where NOTHING was caught in the net
#' @param trawl_method Optional filter for trawl or tow method (i.e. surface, midwater, oblique, live box (surface trawl with a live box), fishing power comparison, or diel tows)
#' See look up table for full explanation of category. Default to "S" or surface tow.
#' @returns Returns a data frame of event information with catch data
#' @export
#' @examples df <- join_event_catch(start_year=2002,end_year=2024,
#' survey_region=c("SEBS","NBS"),tsn=c(161980,934083),lhs=c("J","A0"),catch0=TRUE)

join_event_catch <- function(start_year=2003, end_year=3000, survey_region=NA, tsn=NA,lhs=NA,
                             gear= c("CAN","Nor264"), trawl_method="S", catch0=FALSE) {
  # if else function looks for "cth", "event", "event_parameters" or "taxa" files in local environment before
  # re-downloading them from AkFIN via the API
  if(all(exists("cth"),exists("event"),exists("event_parameters"),exists("taxa"))) {
    warning("Local data files exist. Formatting file from those exports")
  }else {


  # download tables from AKFIN
  event <- get_ema_event() |>
    ## Filter out aborted and unsatisfactory tows.
    dplyr::filter (!gear_performance %in% c("A","U"))
  cth <- get_ema_catch()
  taxa <- get_ema_taxonomy()
  event_parameters <- get_ema_event_parameters()
  }

  ###saves list of data files to global environment
  df_list <- list(cth, event, event_parameters, taxa)
  names(df_list) <- c("cth", "event", "event_parameters", "taxa")
  list2env(df_list, envir=.GlobalEnv)

  # gear filter - only allow gears present in cth table
  if(all(gear %in% unique(cth$gear))){
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

  # Optional survey region filter - defaults to survey_region = NA
  # this is a way of dealing with the "NA" in region column that get generated when we created region in the ema_event pull
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
  # if(any(survey_region %in% unique(stats::na.omit(event$region)))){
  #   survey_region <- c(survey_region)
  # } else {
  #   survey_region <- c(unique(event$region)) |> stats::na.omit()
  # }


  # error message if start year not within range
  if(start_year < 2002 | start_year > max(event$sample_year)) {
    stop("Start year not within acceptable range, try 2002 - present")
  }
    # error message if end year not within range
  if(end_year < 2002) {
    stop("Start year not within acceptable range, try 2002 - present")
  }


  # optional tsn filter
  if(all(is.na(tsn))) {
    cth2 <-cth |>
      dplyr::left_join(taxa, by="species_tsn")
  } else {
    cth2 <-cth |>
      # inner join with the species tsn from the fxn argument
      dplyr::inner_join(taxa |> dplyr::filter(species_tsn %in% tsn), by="species_tsn") |>
      # LHS filter code next to TSN filter code
      dplyr::filter(dplyr::case_when(any(is.na(lhs)) ~ lhs_code %in% unique(cth$lhs_code),
                                     any(!is.na(lhs)) ~ lhs_code %in% lhs))
  }

# set up the catch0 ifelse statement
  if(catch0 == FALSE){
  # join into one data frame
    data <- event |>
      dplyr::filter(sample_year >= start_year
             & sample_year <= end_year
             & gear %in% gear_vec
             & tow_type %in% trawl_vec
             & region %in% survey_vec) |>
      dplyr::select(-akfin_load_date) |>
    # note keeping this a left_join event to catch means that there are about ~11 water hauls (or satisfactory hauls)
    # that legit got ZERO things in the net.
      dplyr::left_join(cth2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
      dplyr::left_join(event_parameters, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
      dplyr::mutate(haulback_time = lubridate::ymd_hms(haulback_time),
                  eq_time = lubridate::ymd_hms(eq_time),
                  gear_in_time = lubridate::ymd_hms(gear_in_time),
                  gear_out_time = lubridate::ymd_hms(gear_out_time),
                  tow_duration = ifelse(tow_type %in% c("S", "M", "L"),
                                        difftime(haulback_time, eq_time, units = "mins"),
                                        ifelse(tow_type %in% c("O"),
                                               difftime(gear_in_time, gear_out_time, units = "mins"), NA))) |>
      dplyr::select(sample_year, cruise_id, event_code, station_id, master_station_name, gear, gear_performance, tow_type, nbs_strata, oceanographic_domain,
                  large_marine_ecosystem, region, eq_time, eq_latitude, eq_longitude, gear_in_time, gear_in_latitude, gear_in_longitude,
                  gear_out_time, gear_out_latitude, gear_out_longitude, haulback_time, haulback_latitude, haulback_longitude,
                  effort, effort_units, tow_duration,
                  species_tsn, common_name, scientific_name, lhs_code, total_catch_number, total_catch_weight)

  print(paste("Last AKFIN catch table upload date", unique(cth$akfin_load_date)))

  # Begin catch 0 calculation
  } else { # stops the function if there are no tsn included
    if(any(is.na(tsn))) {
      stop("catch0 cannot be TRUE when tsn=NA. This will produce a data frame of up to 8,667,792 rows.")
    }
    #same event code as above to get sampling events
    event2 <- event |>
      dplyr::filter(sample_year >= start_year
                    & sample_year <= end_year
                    & gear %in% gear_vec
                    & tow_type %in% trawl_vec
                    & region %in% survey_vec) |>
      dplyr::mutate(haulback_time = lubridate::ymd_hms(haulback_time),
                    eq_time = lubridate::ymd_hms(eq_time),
                    gear_in_time = lubridate::ymd_hms(gear_in_time),
                    gear_out_time = lubridate::ymd_hms(gear_out_time),
                    tow_duration = ifelse(tow_type %in% c("S", "M", "L"),
                      difftime(haulback_time, eq_time, units = "mins"),
                      ifelse(tow_type %in% c("O"),
                             difftime(gear_in_time, gear_out_time, units = "mins"), NA))) %>%
      dplyr::select(-akfin_load_date)


    # Creates a unique list of species_tsn's plus LHS_Codes
    cth_unique <- unique(cth2[c("species_tsn", "common_name", "scientific_name", "lhs_code")])

    # Builds a grid of all stations and species/lhs combinations (including nonsensicle ones)
    zero_grid <- tidyr::expand_grid(subset(event2, select=c("station_id","event_code","gear")), cth_unique)

    # Take the zero grid of tsn and lhs and join in event information (filtered above)
    zero_event_join <- dplyr::left_join(zero_grid, subset(event2, select=c("station_id", "event_code", "gear",
                                                                         "cruise_id","sample_year",
                                                                         "tow_type","gear_performance","region", "eq_time",
                                                                         "eq_latitude","eq_longitude", "gear_in_time",
                                                                         "gear_in_latitude", "gear_in_longitude",
                                                                         "gear_out_time", "gear_out_latitude", "gear_out_longitude",
                                                                         "haulback_time", "haulback_latitude", "haulback_longitude",
                                                                         "tow_duration")),
                                        by=c("station_id", "event_code", "gear"))
    # Add event parameter fields to the zero catch-events
    zero_event_param_join <- dplyr::left_join(zero_event_join ,subset(event_parameters,
                                                                      select=c("station_id","event_code","gear",
                                                                               "master_station_name","nbs_strata","bsierp_region",
                                                                               "oceanographic_domain","effort","effort_units")),
                                              by=c("station_id","event_code","gear"))
    # Where the magic catch zero calculation happens
    # Notice the left_join here with events and catch
    data <- dplyr::left_join(zero_event_param_join,cth2,by=c("station_id","event_code","gear",
                                                               "species_tsn","common_name","scientific_name",
                                                               "lhs_code"))|>
      dplyr::mutate(total_catch_number = ifelse(is.na(total_catch_number),0,total_catch_number),
                    total_catch_weight = ifelse(is.na(total_catch_weight),0,total_catch_weight),
                    cpue_num= total_catch_number/effort,
                    cpue_weight = total_catch_weight/effort)

    print(paste("Last AKFIN catch table upload date", unique(cth$akfin_load_date)))
  }


  return(data)
}


