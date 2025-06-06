## function to read in lut from access


#library(RODBC)

# connect to akfin
# con <- dbConnect(odbc::odbc(), "akfin", UID=getPass(msg="USER NAME"), PWD=getPass())
# or connect to the databased on access
# con <- odbcConnectAccess2007("Y:/ABL_EMA/DATABASES/MASTERS/EMA_Database_05.15.25.accdb")
#
#  download_lut <- function(table) {
#    dbFetch(dbSendQuery(con,
#                             paste0("select * from ema.",table)))%>%
#      rename_with(tolower)%>%
#      dplyr::select(-akfin_load_date)
#
#  }
#
# download_lut <- function(table) {
#    sqlQuery(con, paste("select * from",table))
#   }
# #

# table_vec <- c("LUT_BSIERP_REGION",
#                "LUT_FISH_LIFE_HISTORY_STAGE",
#                "LUT_GEAR",
#                "LUT_GEAR_DESCRIPTION",
#                "LUT_GEAR_PERFORMANCE",
#                "LUT_LENGTH_TYPE",
#                "LUT_NBS_STRATA",
#                "LUT_OCEANOGRAPHIC_DOMAIN",
#                "LUT_SEX",
#                "LUT_TOW_TYPE",
#                "LUT_VESSEL_CODE",
#                "LUT_ZOOP_STAGE_CODE")
#
# tables<-list()
#
# for (i in 1:length(table_vec)) {
#   tables[[i]] <- download_lut(table_vec[i])
# }

# odbcClose(con)

# we want to be able to  use this data (lut) as internal data in the package
# so this write it to the internal data, access this using devtools::load_all()
# usethis::use_data(tables, internal = TRUE)
