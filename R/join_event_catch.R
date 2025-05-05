#' @title Get EMA catch and event data
#'
#' @description This function queries and joins event and catch data hosted on AKFIN collected from Ecosystem Monitoring and Assessment (EMA) surveys.
#' It includes parameters to control start and end year, gear type, survey region, trawl method, tsn (taxonomic serial number),
#' lhs code (life history stage), and whether or not to calculate catch0 (true/false)
#'
#' @param start_year Optional filter for start year, valid range 2002 to present, defaults to 2002
#' @param end_year Optional filter for end year, valid range 2002 to present, defaults to 3000
#' @param survey_region Optional filter for survey region.  Defaults to all regions. Options are "SEBS", "NBS", "Chukchi", and "GOA"  Can take vector of multiple regions.
#' This filter is based on classification of large marine ecosystem and latitude with the separation between the Northern and Southern Bering Sea at 59.9 N
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
#' @examples df <- join_event_catch(start_year=2002,end_year=2024,survey_region=c("SEBS","NBS"),tsn=c(161980,934083),lhs=c("J","A0"),catch0=TRUE)



join_event_catch <- function(start_year=2002, end_year=3000, survey_region=NA, tsn=NA,lhs=NA,
                             gear= c("CAN","Nor264"), trawl_method="S", catch0=FALSE) {
  # if else function looks for "catch", "event", "event_parameters" or "taxa" files in local environment before
  # re-downloading them from AkFIN via the API
  if(all(exists("catch"),exists("event"),exists("event_parameters"),exists("taxa"))) {
    warning("Local data files exist. Formatting file from those exports")
  }else {


  # download tables from AKFIN
  event <- get_ema_event() |> dplyr::rename_with(tolower) |>
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear), # fix gear typo in db
                  ###This code adds a "region" field.  Note that this region only effectively works for trawls since CTD/CAT stations store lat in a different field.
                  # There's one NETS trawl from 2016 but it's aborted so I don't care about it.
                  large_marine_ecosystem = ifelse(large_marine_ecosystem == "Chuckchi", "Chukchi", large_marine_ecosystem),
                  region = dplyr::case_when(eq_latitude <=59.9 & large_marine_ecosystem=="Bering Sea" ~ "SEBS",
                                            eq_latitude >59.9 & eq_latitude <= 65.5 & large_marine_ecosystem=="Bering Sea" ~ "NBS",
                                            eq_latitude >65.5 ~ "Chukchi",
                                            large_marine_ecosystem=="GOA" ~ "GOA")) |>
    dplyr::mutate(region = ifelse(is.na(region),
                                  dplyr::case_when(gear_in_latitude <= 59.9 & !(large_marine_ecosystem == "GOA") ~ "SEBS",
                                                   gear_in_latitude > 59.9 & gear_in_latitude <= 65.5 & !(large_marine_ecosystem == "GOA") ~ "NBS",
                                                   gear_in_latitude > 65.5 ~ "Chukchi",
                                                   large_marine_ecosystem == "GOA" ~ "GOA"), region)) |>
    # as of 5-5-25 there are four CTD/CAT/Bongo events that have no associated lat/lon that are just going to have to stay for now
    ## Filter out aborted and unsatisfactory tows.
    dplyr::filter (!gear_performance %in% c("A","U"))
  catch <- get_ema_catch() |> dplyr::rename_with(tolower) |>
    dplyr::mutate(gear = ifelse(gear == "NOR64", "Nor64", gear)) # fix gear typo in db
  taxa <- get_ema_taxonomy() |> dplyr::rename_with(tolower)
  event_parameters <- get_ema_event_parameters() |> dplyr::rename_with(tolower)
  }

  ###saves list of data files to global environment
  df_list <- list(catch, event, event_parameters, taxa)
  names(df_list) <- c("catch", "event", "event_parameters", "taxa")
  list2env(df_list, envir=.GlobalEnv)

  # gear filter - only allow gears present in catch table
  if(all(gear %in% unique(catch$gear))){
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

  # this is a way of dealing with the "NA" in region that get generated when we created region above
  # these four lines can be removed if the lat/lon information gets fixed.
  if(any(survey_region %in% unique(stats::na.omit(event$region)))){
    survey_region <- c(survey_region)
  } else {
    survey_region <- c(unique(event$region)) |> stats::na.omit()
  }

  # if(is.na(gear)) {
  #   gear_vec <- unique(catch$gear)
  # } else {
  #   gear_vec <- c(gear)
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
  if(is.na(tsn)) {
    catch2 <-catch |>
      dplyr::left_join(taxa, by="species_tsn")
  } else {
    catch2 <-catch |>
      # inner join with the species tsn from the fxn argument
      dplyr::inner_join(taxa |> dplyr::filter(species_tsn %in% tsn), by="species_tsn") |>
      # LHS filter code next to TSN filter code
      dplyr::filter(dplyr::case_when(any(is.na(lhs)) ~ lhs_code %in% unique(catch$lhs_code),
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
             & region %in% survey_region) |>
    # note keeping this a left_join event to catch means that there are about ~11 water hauls (or satisfactory hauls)
    # that legit got ZERO things in the net.
    dplyr::left_join(catch2, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::left_join(event_parameters, by=c("station_id"="station_id", "event_code"="event_code", "gear"="gear")) |>
    dplyr::mutate(haulback_time = lubridate::ymd_hms(haulback_time),
                  eq_time = lubridate::ymd_hms(eq_time),
                  tow_duration = difftime(haulback_time, eq_time, units = "mins")) |>
    dplyr::select(sample_year, cruise_id, event_code, station_id, gear, gear_performance, tow_type, nbs_strata, oceanographic_domain,
                  large_marine_ecosystem, region, eq_latitude, eq_longitude,
                  effort, effort_units, tow_duration,
                  species_tsn, common_name, scientific_name, lhs_code, total_catch_number, total_catch_weight)

  print(paste("Last AKFIN catch upload date", unique(catch$akfin_load_date)))

  # Begin catch 0 calculation
  } else { # stops the function if there are no tsn included
    if(any(is.na(tsn))) {
      stop("catch0 cannot be TRUE when tsn=NA.  This will produce a data frame of up to 8,667,792 rows.")
    }
    #same event code as above to get sampling events
    event2 <- event |>
      dplyr::filter(sample_year >= start_year
                    & sample_year <= end_year
                    & gear %in% gear_vec
                    & tow_type %in% trawl_vec
                    & region %in% survey_region) |>
      dplyr::mutate(haulback_time = lubridate::ymd_hms(haulback_time),
                    eq_time = lubridate::ymd_hms(eq_time),
                    tow_duration = difftime(haulback_time, eq_time, units = "mins"))


    # Creates a unique list of species_tsn's plus LHS_Codes
    catch_unique <- unique(catch2[c("species_tsn", "common_name", "scientific_name", "lhs_code")])

    # Builds a grid of all stations and species/lhs combinations (including nonsensicle ones)
    zero_grid <- tidyr::expand_grid(subset(event2, select=c("station_id","event_code","gear")), catch_unique)

    # Take the zero grid of tsn and lhs and join in event information (filtered above)
    zero_event_join <- dplyr::left_join(zero_grid, subset(event2, select=c("station_id", "event_code", "gear",
                                                                         "cruise_id","sample_year",
                                                                         "tow_type","gear_performance","region",
                                                                         "eq_latitude","eq_longitude","tow_duration")),
                                        by=c("station_id", "event_code", "gear"))
    #join in event parameter fields
    zero_event_param_join <- dplyr::left_join(zero_event_join ,subset(event_parameters,
                                                                      select=c("station_id","event_code","gear","nbs_strata","bsierp_region",
                                                                               "oceanographic_domain","effort","effort_units")),
                                              by=c("station_id","event_code","gear"))
    #where the magic happens
    data <- dplyr::left_join(zero_event_param_join,catch2,by=c("station_id","event_code","gear","species_tsn","common_name","scientific_name","lhs_code"))|>
      dplyr::mutate(total_catch_number = ifelse(is.na(total_catch_number),0,total_catch_number),
                    total_catch_weight = ifelse(is.na(total_catch_weight),0,total_catch_weight),
                    cpue_num= total_catch_number/effort,
                    cpue_weight = total_catch_weight/effort)

    print(paste("Last AKFIN catch upload date", unique(catch$akfin_load_date)))
  }






  return(data)
}


