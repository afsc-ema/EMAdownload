#' @title Get ema taxa
#'
#' @description This function pulls ecosystem survey data (from EMA surveys) from the AKFIN data server
#'
#' @export


get_ema_taxonomy <- function() {
  url <- "https://apex.psmfc.org/akfin/data_marts/ema/lut_trawl_species_tsn?"

  # Fetch as UTF-8 text (note: 'as', not 'type')
  resp_txt <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")

  dat <- jsonlite::fromJSON(resp_txt, flatten = TRUE)

  # Replace U+00BF with regular spaces in character columns
  dat <- as.data.frame(dat)%>%
    dplyr::mutate(across(where(is.character),
      ~ gsub("\u00BF", " ", .x, fixed = TRUE)
    )
  )

  dat <- dplyr::rename_with(dat, tolower)

  return(dat)
}

