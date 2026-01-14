# Get EMA fish specimen data with event information

This function pulls specimen level data with associated event
information from ecosystem survey data (from EMA surveys) from the AKFIN
data server. It includes parameters to control start and end year, gear
type, and TSN (species code).

This function, by nature of the type of data it returns, only provides
specimen data for locations where positive catch

You may want to catch weight the specimen data in which case you should
use the join_event_catch function to get the associated catch
information. You then join on station ID, event code, and gear code.

## Usage

``` r
join_event_fish(
  start_year = 2003,
  end_year = 3000,
  survey_region = NA,
  tsn = NA,
  gear = c("CAN", "Nor264"),
  trawl_method = "S"
)
```

## Arguments

- start_year:

  Optional filter for start year, valid range 2002 to present defaults
  to 2002

- end_year:

  Optional filter for end year, valid range 2002 to present defaults to
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

  Optional filter for species taxonomic serial number (from ITIS.gov),
  defaults to all species in database. Can take vectors of species tsn

- gear:

  Optional filter for gear type, options are CAN, MAR, NETS156, Nor64,
  defaults to CAN. Can take vector of multiple gear types

- trawl_method:

  Optional filter for trawl or tow method (i.e. surface, midwater,
  oblique, live box (surface trawl with a live box), fishing power
  comparison, or diel tows) See look up table for full explanation of
  category. Default to "S" or surface tow.

## Value

Returns a data frame of event information with specimen data (lengths,
weights, special samples taken)
