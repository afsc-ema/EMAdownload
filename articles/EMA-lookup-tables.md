# EMA lookup tables

This document contains lookup tables for EMA data codes. Data are pulled
from internal data based off of EMA internal database. This report was
last run 2026-01-15

## Lookup tables

| BSIERP_REGION | BSIERP_REGION_DESCRIPTION |
|--------------:|:--------------------------|
|             0 | No Region Assigned        |
|             1 | AK peninsula              |
|             2 | Midnorth inner shelf      |
|             3 | Midnorth middle shelf     |
|             4 | North inner shelf         |
|             5 | North middle shelf        |
|             6 | North outer shelf         |
|             7 | Norton Sound              |
|             8 | Off-shelf north           |
|             9 | Off-shelf southeast       |
|            10 | Pribilofs                 |
|            11 | South Bering Strait       |
|            12 | South inner shelf         |
|            13 | South middle shelf        |
|            14 | South outer shelf         |
|            15 | St. Lawrence              |
|            16 | St. Matthews              |

| LHS_CODE | LHS_CODE_DESCRIPTION    | NOTES                                                         |
|:---------|:------------------------|:--------------------------------------------------------------|
| A        | Adult                   | NA                                                            |
| A0       | Age 0                   | NA                                                            |
| A1       | Age 1                   | NA                                                            |
| A1+      | Age 1+                  | NA                                                            |
| A2+      | Age 2+                  | Began use in 2024 when “Age 1” LHS Code was used for Pollock. |
| I_M      | Mixed Immature + Mature | NA                                                            |
| J        | Juvenile                | NA                                                            |
| L        | Larval                  | NA                                                            |
| U        | Unspecified             | NA                                                            |

| GEAR     | GEAR_DESCRIPTION                              |
|:---------|:----------------------------------------------|
| 3MBT     | 3meter Beam Trawl                             |
| Bongo153 | Bongo net with 153um mesh                     |
| Bongo333 | Bongo net with 333um mesh                     |
| Bongo505 | Bongo net with 505um mesh                     |
| Bongo80  | Bongo net with 80um mesh                      |
| CAN      | 300 headrope                                  |
| CAT      | Temperature Logging. Often paired with Bongos |
| CTD      | Temperature Logger/Water Sampler.             |
| Juday    | Zooplankton sampling net                      |
| MAR      | Marinovich                                    |
| NETS156  | NETS Pelagic Trawl                            |
| Nor264   | Nordic                                        |
| PairoVET | Zooplankton sampling net                      |

| GEAR_NAME | GEAR_NAME_DESCRIPTION                                                                                                                                                                |
|:----------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 16 Plus   | Sea-Bird Electronics 16 Plus                                                                                                                                                         |
| 19        | Sea-Bird Electronics 19 CTD (SeaCat) profiler                                                                                                                                        |
| 19 Plus   | Sea-Bird Electronics 19 Plus CTD (SeaCat) profiler with auxilliary sensors                                                                                                           |
| 25        | Sea-Bird Electronics 25 CTD profiler with auxilliary sensors                                                                                                                         |
| 25 Plus   | Sea-Bird Electronics 25 Plus CTD profiler with auxilliary sensors                                                                                                                    |
| 300       | Can Trawl 300                                                                                                                                                                        |
| 300400    | Can Trawl 300 headrope, 400 sidewalls                                                                                                                                                |
| 39        | Sea-Bird Electronics 39 for temperature and pressure measurements typically collected on headrope and footrope of trawl net                                                          |
| 39 plus   | Sea-Bird Electronics 39 Plus unit for Temperature and pressure measurements typically collected on headrope and footrope of trawl net (updated version of 39, came out in Feb. 2014) |
| 3MBT      | 3 meter wide small mesh Beam Trawl                                                                                                                                                   |
| 400580    | Can Trawl 400 headrope, 580 sidewalls                                                                                                                                                |
| 400601    | Can Trawl 400 headrope, 601 sidewalls                                                                                                                                                |
| 49        | Sea-Bird Electronics 49 CTD (FastCat) profiler                                                                                                                                       |
| 911       | Sea-Bird Electronics 9 CTD with 11 deck unit, real time data acquisition with auxilliary sensors                                                                                     |
| 917       | Sea-Bird Electronics 911 CTD with17Plus profiler with auxilliary sensors and V2 Searam for non-real time data acquisition and bottle firing                                          |
| Bongo153  | 20 cm diameter, mesh 153 microns.                                                                                                                                                    |
| Bongo333  | 60cm diameter, mesh 333 microns.                                                                                                                                                     |
| Bongo505  | 60 cm diameter, mesh 505 microns.                                                                                                                                                    |
| Bongo80   | 80 cm diameter, mesh 153 microns.                                                                                                                                                    |
| Juday     | Juday net, 36 cm diameter, mesh 168 microns.                                                                                                                                         |
| MAR       | Marinovich small mesh midwater net (with optional pocket nets)                                                                                                                       |
| NETS156   | Net Systems 156 oblique/midwater trawl.                                                                                                                                              |
| Nor264    | Nordic 264 small mesh codend surface trawl net.                                                                                                                                      |
| PairoVET  | PairoVET net, 25 cm diameter, mesh 153 microns.                                                                                                                                      |

| GEAR_PERFORMANCE | GEAR_PERFORMANCE_NAME | PERFORMANCE_DESCRIPTION                                                                          |
|:-----------------|:----------------------|:-------------------------------------------------------------------------------------------------|
| A                | Aborted               | Tow was aborted, associated data should be excluded from analyses.                               |
| G                | Good                  | Trawl performed without issues                                                                   |
| Q                | Questionable          | Trawl had issues, catches were still counted and sorted. Use at own discretion                   |
| S                | Satisfactory          | Trawl performed adequately but had some issues. See notes for specific details                   |
| U                | Unsatisfactory        | Trawl performed with very notable issues that impacted fishing. Should be excluded from analyses |

| LENGTH_TYPE | LENGTH_DESCRIPTION |
|:------------|:-------------------|
| BD          | Bell Diameter      |
| FL          | Fork Length        |
| ML          | Mantle Length      |
| SL          | Standard Length    |
| TL          | Total Length       |

| NBS_STRATA | STRATA_NAME           | STRATA_DESCRIPTION                                   |
|-----------:|:----------------------|:-----------------------------------------------------|
|          0 | No Strata             | Not a station considered in the NBS survey region    |
|          1 | Lower Inner           | South of 61.6N and East of 168.1                     |
|          2 | Lower Middle          | South of 61.6N and Between 168.1 and 171.1W          |
|          3 | Middle Inner          | Between 61.6N and 62.6N and East of 168.1W           |
|          4 | Middle Middle         | Between 61.6N and 62.6N and Between 168.1 and 171.1W |
|          5 | Middle Core           | Between 62.7 and 63.6N and Between 165 and 168W      |
|          6 | Norton Sound Core     | North of 63.9N and East of 164.9W                    |
|          7 | Norton Sound Adaptive | South of 63.9N and East of 164.9W                    |
|          8 | Upper Inner           | Between 63.6N and 64.6N and between -165W and 168.1W |
|          9 | Upper Outer           | Between 63.6N and 64.6N and West of 168.1W           |
|         10 | Bering Strait Inner   | North of 64.6 and east of -168.1W                    |
|         11 | Bering Strait Outer   | North of 64.6 and west of -168.1W                    |
|         12 | Lower Outer           | South of 63.6 and West of 171.1                      |

| OCEANOGRAPHIC_DOMAIN | OCEANOGRAPHIC_DOMAIN_DESCRIPTION | NOTES               |
|---------------------:|:---------------------------------|:--------------------|
|                    0 | No region assigned               | NA                  |
|                    1 | Coastal Shelf                    | 0-50m bathymetry    |
|                    2 | Middle Shelf                     | 50-100m bathymetry  |
|                    3 | Off Shelf                        | \>200m bathymetry   |
|                    4 | Outer Shelf                      | 100-200m bathymetry |

| SEX | SEX_DESCRIPTION |
|:----|:----------------|
| F   | Female          |
| M   | Male            |
| U   | Unknown         |

| TOW_TYPE | TOW_TYPE_NAME            | TOW_TYPE_DESCRIPTION                                                                                                         |
|:---------|:-------------------------|:-----------------------------------------------------------------------------------------------------------------------------|
| B        | Bottom                   | Tow conducted on bottom/at bottom of water column.                                                                           |
| D        | Diel                     | Tow contucted at change of light (dark to light or light to dark)                                                            |
| FP       | Fishing Power Comparison | Side by side tow conducted with another vessel for the sake of assessing fishing selection of used trawl gear(s) or vessels. |
| L        | Live Box                 | Tow conducted with live box attached at end of trawl to collect live samples.                                                |
| M        | Midwater                 | Targeted midwater tow aimed at fish sign identified in middle of water column.                                               |
| O        | Oblique                  | Tow conducted from surface down to bottom and back to surface sampling whole water column.                                   |
| S        | Surface                  | Tow conducted at surface of water column.                                                                                    |
| V        | Vertical                 | Vertical cast straight down to just off bottom and back to surface                                                           |

| VESSEL_CODE | VESSEL_ALPHA_CODE | VESSEL_NAME        |
|------------:|:------------------|:-------------------|
|           1 | SS                | Seastorm           |
|           2 | NW                | Northwest Explorer |
|           3 | DY                | Oscar Dyson        |
|           4 | GP                | Great Pacific      |
|           5 | EE                | Epic Explorer      |
|           8 | BE                | Bristol Explorer   |
|           9 | AE                | Alaskan Endeavor   |
|          10 | JC                | John N. Cobb       |
|          11 | ST                | Stellar            |
|          12 | CH                | Chelissa           |
|          13 | SA                | Sashin             |
|          14 | QU                | Quest              |
|          15 | CF                | Cape Flattery      |
|          16 | OS                | Ocean Starr        |
|          17 | SI                | Sikuliaq           |
|          18 | AQ                | Aquila             |

| CODE         | DESCRIPTION                                   | FOCI_CODE |
|:-------------|:----------------------------------------------|----------:|
| A & J        | Adult and juveniles combined.                 |        64 |
| adult        | Adult stage.                                  |         0 |
| C1           | Copepodite I stage.                           |        20 |
| C1-2         | Copepodite stage 1 through 2.                 |        NA |
| C1-3         | Copepodite stage 1 through 3.                 |        NA |
| C1-4         | Copepodite stage 1 through 4.                 |        19 |
| C1-5         | Copepodite stage 1 through 5.                 |        NA |
| C2           | Copepodite II stage.                          |        21 |
| C2-3         | Copepodite stage 2 through 3.                 |        NA |
| C2-5         | Copepodite stage 2 through 5.                 |        NA |
| C3           | Copepodite III stage.                         |        22 |
| C3-4         | Copepodite stage 3 through 4.                 |        NA |
| C3-5         | Copepodite stage 3 through 5.                 |        NA |
| C4           | Copepodite IV stage.                          |        23 |
| C4-5         | Copepodite stage 4 through 5.                 |        NA |
| C4-6         | Copepodite stage 4 through adult.             |        NA |
| C5           | Copepodite V stage.                           |        24 |
| calyptopis   | Calyptopis (stage not determined).            |        60 |
| calyptopis 1 | Calyptopis 1 stage.                           |        61 |
| calyptopis 2 | Calyptopis 2 stage.                           |        62 |
| calyptopis 3 | Calyptopis 3 stage.                           |        63 |
| cypris       | Barnacle cypris stage.                        |        25 |
| egg          | Egg.                                          |        11 |
| furcilia     | Furcilia stage.                               |        29 |
| juvenile     | Juvenile stage.                               |        80 |
| larva        | Larval stage.                                 |        51 |
| medusa       | Free swimming medusa stage.                   |         3 |
| megalopa     | Megalopa stage.                               |        75 |
| nauplius     | Naupliar stage                                |        13 |
| post-larva   | Stage following larval mysis stage in shrimp. |        NA |
| U            | Unidentified stage.                           |       999 |
| zoea         | Zoea stage.                                   |        70 |

| SALMON_MATURITY | MATURITY_DESCRIPTION | Notes                                                                                                                                  |
|:----------------|:---------------------|:---------------------------------------------------------------------------------------------------------------------------------------|
| J               | Juvenile             | NA                                                                                                                                     |
| I               | Immature             | Designation ONLY used in FISH (specimen) records. Salmon of this maturity come from CATCH records with LHS I_M (mixed immature/mature) |
| I_M             | Immature or Mature   | Unspecified whether immature or mature specimen. From CATCH records with LHS I_M (mixed immature/mature)                               |
| M               | Mature               | Designation ONLY used in FISH (specimen) records. Salmon of this maturity come from CATCH records with LHS I_M (mixed immature/mature) |
