# Get EMA catch and event data

This function queries and joins event and catch data hosted on AKFIN
collected from Ecosystem Monitoring and Assessment (EMA) surveys. It
includes parameters to control start and end year, gear type, survey
region, trawl method, tsn (taxonomic serial number), lhs code (life
history stage), and whether or not to calculate catch0 (true/false)

## Usage

``` r
join_event_catch(
  start_year = 2003,
  end_year = 3000,
  survey_region = NA,
  tsn = NA,
  lhs = NA,
  gear = c("CAN", "Nor264"),
  trawl_method = "S",
  catch0 = FALSE,
  force_download = FALSE
)
```

## Arguments

- start_year:

  Optional filter for start year, valid range 2003 to present, defaults
  to 2003

- end_year:

  Optional filter for end year, valid range 2002 to present, defaults to
  3000

- survey_region:

  Optional filter for survey region. Defaults to all regions. Options
  are "SEBS", "NBS", "Chukchi", and "GOA" Can take vector of multiple
  regions. This filter is based on classification of large marine
  ecosystem and latitude with the separation between the Northern and
  Southern Bering Sea at 59.9 N The seperation between NBS and Chukchi
  is at 65.5. Stations are sorted into region rather than survey
  objective (i.e. the survey may be a survey to go to the "Chukchi", but
  if some stations occurred in the Northern Bering Sea those stations
  get classified as NBS stations).

- tsn:

  Filter for species taxonomic serial number (from ITIS.gov), defaults
  to all species in database. Can take vectors of species tsns. This
  parameter is optional if catch0=FALSE, but is required if catch0=TRUE.
  Use get_ema_taxonomy function to see full list of TSNs.

- lhs:

  Optional filter for species life history stage. For salmon species,
  options are IM or J. For all other species, see values in
  EMA-lookup-table.

- gear:

  Optional filter for gear type, options are CAN, MAR, NETS156, Nor64,
  defaults to CAN & Nor64 (which are all surface trawls). Can take
  vector of multiple gear types

- trawl_method:

  Optional filter for trawl or tow method (i.e. surface, midwater,
  oblique, live box (surface trawl with a live box), fishing power
  comparison, or diel tows) See look up table for full explanation of
  category. Default to "S" or surface tow.

- catch0:

  Optional argument that indicates whether data should include 0-catches
  (i.e. stations that were fished where no species/lhs combinations were
  caught). Defaults to false if no argument entered. However, when
  catch0 == FALSE it will give you any events where NOTHING was caught
  in the net

- force_download:

  forces a redownload of data directly from AKFINs API rather than using
  a cached version of the data. This argument will force a re-download
  of all data not just event or catch

## Value

Returns a data frame of event information with catch data

## Examples

``` r
df <- join_event_catch(start_year=2002,end_year=2024,
survey_region=c("SEBS","NBS"),tsn=c(161980,934083),lhs=c("J","A0"),catch0=TRUE)
#> Checking AKFIN for updates to event...
#> Downloading event data...
#> Checking AKFIN for updates to catch...
#> Downloading catch data...
#> Checking AKFIN for updates to taxonomy...
#> Downloading taxonomy data...
#> Checking AKFIN for updates to event_parameters...
#> Downloading event_parameters data...
#> [1] "Last AKFIN catch table upload date 2026-01-02T10:38:05Z"
```
