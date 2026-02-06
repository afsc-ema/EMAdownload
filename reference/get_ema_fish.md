# Get EMA fish specimen data with event information

This function pulls specimen level data with associated event
information from ecosystem survey data (from EMA surveys) from the AKFIN
data server. It includes parameters to control start and end year, gear
type, and TSN (species code).

You may want to catch weight the specimen data in which case you should
use the join_event_catch function to get the associated catch
information. You then join on station ID, event code, and event code.

## Usage

``` r
get_ema_fish(force_download = FALSE)
```

## Arguments

- force_download:

  Bypass cache and force download

## Value

a dataframe with all specimen data
