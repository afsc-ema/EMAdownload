# Get EMA catch table

This function pulls ecosystem survey data (from EMA surveys) from the
AKFIN data server It includes parameters to control start and end year,
gear type, and TSN (species code)

## Usage

``` r
get_ema_catch(force_download = FALSE)
```

## Arguments

- force_download:

  Bypass cache and force download

## Value

a dataframe with all trawl related catch information
