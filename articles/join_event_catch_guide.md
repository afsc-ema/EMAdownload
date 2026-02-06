# Join Event Catch Examples

``` r
library(EMAdownload)
# source("../R/join_event_catch.R")
# source("../R/get_ema_catch.R")
# source("../R/get_ema_event.R")
# source("../R/get_ema_event_parameters.R")
# source("../R/get_ema_taxonomy.R")
```

This vignette will walk through several possible use cases for the
join_event_catch() function and provide examples

### Pull all Juvenile Chinook positive catches from all tows from all years from Northern Bering Sea

### Pull all age-0 pollock from surface trawls in all survey regions

``` r
df <- join_event_catch(start_year = 2003, # Defaults to 2003 if no argument entered.
                       end_year = 2024,
                       survey_region = c("SEBS","NBS","Chukchi"),
                       tsn = 934083,
                       lhs = "A0",
                       gear = c("CAN","Nor264"), # There are no NETS156 or MAR surface trawls.
                       trawl_method = c("S"),
                       catch0 = FALSE)

nrow(df); head(df)
```

### Pull all juvenile salmon catches from surface trawls in the Northern Bering Sea and include zero-catches

``` r
df <- join_event_catch(start_year = 2003, # Defaults to 2003 if no argument entered.
                       end_year = 2024,
                       survey_region = c("NBS"),
                       tsn = c(161975,161976,161977,161979,161980),
                       lhs = "J",
                       gear = c("CAN"), # There are no Nor264 surface trawls in NBS.
                       trawl_method = c("S"),
                       catch0 = TRUE)

nrow(df); head(df)
```

### Pull all age-0 pacific cod from non-surface trawls in the Southeastern Bering Sea between 2008 and 2018 and include zero-catches

``` r
df <- join_event_catch(start_year = 2008, # Defaults to 2003 if no argument entered.
                       end_year = 2018,
                       survey_region = "SEBS",
                       tsn = 164711,
                       lhs = "A0",
                       gear = c("CAN","NETS156","Nor264","MAR"), 
                       trawl_method = c("M","O"),
                       catch0 = TRUE)

nrow(df); head(df)
```
