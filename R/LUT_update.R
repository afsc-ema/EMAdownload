## function to read in lut from access
## Reminder - that after you use this file to overwrite the internal data (hint you may need to delete it and re-write it)
## all this code should be commented out, because as this is a package, R tries to build in the functions that it thinks
## it should be getting from this script.

# library(RODBC)
#
# ## connect to akfin
# ## con <- dbConnect(odbc::odbc(), "akfin", UID=getPass(msg="USER NAME"), PWD=getPass())
# ## or connect to the databased on access
# con <- odbcConnectAccess2007("Y:/ABL_EMA/DATABASES/MASTERS/EMA_Database_08.07.25.accdb")
#
# download_lut <- function(table) {
#   dbFetch(dbSendQuery(con,
#                       paste0("select * from ema.",table)))%>%
#     rename_with(tolower)%>%
#     dplyr::select(-akfin_load_date)
#
# }
#
# download_lut <- function(table) {
#   sqlQuery(con, paste("select * from",table))
# }
# # #
#
# table_vec <- c("LUT_BSIERP_REGION",
#                "LUT_CATCH_LIFE_HISTORY_STAGE",
#                "LUT_GEAR",
#                "LUT_GEAR_DESCRIPTION",
#                "LUT_GEAR_PERFORMANCE",
#                "LUT_LENGTH_TYPE",
#                "LUT_NBS_STRATA",
#                "LUT_OCEANOGRAPHIC_DOMAIN",
#                "LUT_SEX",
#                "LUT_TOW_TYPE",
#                "LUT_VESSEL_CODE",
#                "LUT_ZOOP_STAGE_CODE",
#                "LUT_SALMON_MATURITY")
#
# my_tables<-list()
#
# for (i in 1:length(table_vec)) {
#   my_tables[[i]] <- download_lut(table_vec[i])
# }
#
# odbcClose(con)
#
# # we want to be able to  use this data (lut) as internal data in the package
# # so this write it to the internal data,
#
# # 8/19/25 try reading it as external data
# # usethis::use_data(tables, overwrite = TRUE)
# # create raw data file to put this script (tables generating script)
# # usethis::use_data_raw()
#
#
# # new_env <- new.env(hash = F)
# # load("R/sysdata.rda", envir = new_env)
# # new_env$tables <- tables
# #
# # new_env$tables
#
# # save(list = names(new_env),
# #      file = "R/sysdata.rda",
# #      envir = new_env)
#
#
# usethis::use_data(my_tables, internal = TRUE, overwrite = TRUE)
#
# length(my_tables)

