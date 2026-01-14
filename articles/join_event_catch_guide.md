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

``` r
df <- join_event_catch(start_year = 2003, # Defaults to 2003 if no argument entered.
                       end_year = 2024,
                       survey_region = "NBS",
                       tsn = 161980,
                       lhs = "J",
                       gear = c("CAN","Nor264","NETS156","MAR"),
                       trawl_method = c("S","M","O"),
                       catch0 = FALSE)
#> [1] "Last AKFIN catch table upload date 2026-01-02T10:38:05Z"

nrow(df); head(df)
#> [1] 950
#>   sample_year cruise_id event_code  station_id master_station_name gear
#> 1        2003    SS0301          3 20030101001            64-164.5  CAN
#> 2        2003    SS0301          3 20030101002            64-163.5  CAN
#> 3        2003    SS0301          3 20030101003              64-166  CAN
#> 4        2003    SS0301          3 20030101004            64-166.5  CAN
#> 5        2003    SS0301          3 20030101005              64-167  CAN
#> 6        2003    SS0301          3 20030101006            64-167.5  CAN
#>   gear_performance tow_type nbs_strata oceanographic_domain
#> 1                S        S          6                    1
#> 2                S        S          6                    1
#> 3                S        S          8                    1
#> 4                S        S          8                    1
#> 5                S        S          8                    1
#> 6                S        S          8                    1
#>   large_marine_ecosystem region             eq_time eq_latitude eq_longitude
#> 1             Bering Sea    NBS 2003-08-22 00:19:00     64.0825    -164.5717
#> 2             Bering Sea    NBS 2003-08-22 03:46:00     64.0687    -163.6500
#> 3             Bering Sea    NBS 2003-08-22 15:09:00     64.0313    -166.1247
#> 4             Bering Sea    NBS 2003-08-22 18:04:00     63.9988    -166.4883
#> 5             Bering Sea    NBS 2003-08-22 20:28:00     63.9700    -166.9988
#> 6             Bering Sea    NBS 2003-08-22 23:05:00     63.9870    -167.4942
#>   gear_in_time gear_in_latitude gear_in_longitude gear_out_time
#> 1         <NA>               NA                NA          <NA>
#> 2         <NA>               NA                NA          <NA>
#> 3         <NA>               NA                NA          <NA>
#> 4         <NA>               NA                NA          <NA>
#> 5         <NA>               NA                NA          <NA>
#> 6         <NA>               NA                NA          <NA>
#>   gear_out_latitude gear_out_longitude       haulback_time haulback_latitude
#> 1                NA                 NA 2003-08-22 00:49:00           64.0735
#> 2                NA                 NA 2003-08-22 04:14:00           64.0652
#> 3                NA                 NA 2003-08-22 15:39:00           64.0692
#> 4                NA                 NA 2003-08-22 18:34:00           64.0100
#> 5                NA                 NA 2003-08-22 20:58:00           64.0075
#> 6                NA                 NA 2003-08-22 23:35:00           64.0288
#>   haulback_longitude effort effort_units tow_duration species_tsn
#> 1          -164.4910 0.2221          km2           30      161980
#> 2          -163.5695 0.2158          km2           28      161980
#> 3          -166.1372 0.2336          km2           30      161980
#> 4          -166.5762 0.2856          km2           30      161980
#> 5          -166.9982 0.2745          km2           30      161980
#> 6          -167.5118 0.2938          km2           30      161980
#>      common_name          scientific_name lhs_code total_catch_number
#> 1 Chinook Salmon Oncorhynchus tshawytscha        J                 55
#> 2 Chinook Salmon Oncorhynchus tshawytscha        J                 77
#> 3 Chinook Salmon Oncorhynchus tshawytscha        J                 39
#> 4 Chinook Salmon Oncorhynchus tshawytscha        J                 11
#> 5 Chinook Salmon Oncorhynchus tshawytscha        J                 34
#> 6 Chinook Salmon Oncorhynchus tshawytscha        J                  2
#>   total_catch_weight
#> 1               3924
#> 2               5078
#> 3               3100
#> 4               1002
#> 5               2759
#> 6                233
```

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
#> Warning in join_event_catch(start_year = 2003, end_year = 2024, survey_region =
#> c("SEBS", : Local data files exist. Formatting file from those exports
#> [1] "Last AKFIN catch table upload date 2026-01-02T10:38:05Z"

nrow(df); head(df)
#> [1] 2083
#>   sample_year cruise_id event_code  station_id master_station_name gear
#> 1        2003    SS0301          3 20030101058           58.75-165  CAN
#> 2        2003    SS0301          3 20030101059              59-165  CAN
#> 3        2003    SS0301          3 20030101060           59.25-165  CAN
#> 4        2003    SS0301          3 20030101061              59-164  CAN
#> 5        2003    SS0301          3 20030101062           58.75-164  CAN
#> 6        2003    SS0301          3 20030101063            58.5-164  CAN
#>   gear_performance tow_type nbs_strata oceanographic_domain
#> 1                S        S          0                    1
#> 2                S        S          0                    1
#> 3                S        S          0                    1
#> 4                S        S          0                    1
#> 5                S        S          0                    1
#> 6                S        S          0                    1
#>   large_marine_ecosystem region             eq_time eq_latitude eq_longitude
#> 1             Bering Sea   SEBS 2003-09-06 22:35:00     58.7398    -164.9875
#> 2             Bering Sea   SEBS 2003-09-07 01:09:00     59.0118    -164.9723
#> 3             Bering Sea   SEBS 2003-09-07 04:04:00     59.2578    -164.9752
#> 4             Bering Sea   SEBS 2003-09-07 16:22:00     59.0108    -163.9788
#> 5             Bering Sea   SEBS 2003-09-07 18:38:00     58.7657    -164.0007
#> 6             Bering Sea   SEBS 2003-09-07 20:51:00     58.5203    -163.9975
#>   gear_in_time gear_in_latitude gear_in_longitude gear_out_time
#> 1         <NA>               NA                NA          <NA>
#> 2         <NA>               NA                NA          <NA>
#> 3         <NA>               NA                NA          <NA>
#> 4         <NA>               NA                NA          <NA>
#> 5         <NA>               NA                NA          <NA>
#> 6         <NA>               NA                NA          <NA>
#>   gear_out_latitude gear_out_longitude       haulback_time haulback_latitude
#> 1                NA                 NA 2003-09-06 23:05:00           58.7778
#> 2                NA                 NA 2003-09-07 01:39:00           58.9910
#> 3                NA                 NA 2003-09-07 04:34:00           59.2348
#> 4                NA                 NA 2003-09-07 16:52:00           58.9842
#> 5                NA                 NA 2003-09-07 19:08:00           58.7248
#> 6                NA                 NA 2003-09-07 21:21:00           58.4803
#>   haulback_longitude effort effort_units tow_duration species_tsn common_name
#> 1          -165.0272 0.2883          km2           30      934083     Pollock
#> 2          -165.0202 0.2192          km2           30          NA        <NA>
#> 3          -165.0332 0.2580          km2           30      934083     Pollock
#> 4          -164.0323 0.2640          km2           30          NA        <NA>
#> 5          -163.9988 0.2862          km2           30          NA        <NA>
#> 6          -164.0002 0.2743          km2           30      934083     Pollock
#>       scientific_name lhs_code total_catch_number total_catch_weight
#> 1 Gadus chalcogrammus       A0                 10                 NA
#> 2                <NA>     <NA>                 NA                 NA
#> 3 Gadus chalcogrammus       A0                  1                 NA
#> 4                <NA>     <NA>                 NA                 NA
#> 5                <NA>     <NA>                 NA                 NA
#> 6 Gadus chalcogrammus       A0                 30                 69
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
#> Warning in join_event_catch(start_year = 2003, end_year = 2024, survey_region =
#> c("NBS"), : Local data files exist. Formatting file from those exports
#> [1] "Last AKFIN catch table upload date 2026-01-02T10:38:05Z"

nrow(df); head(df)
#> [1] 4630
#> # A tibble: 6 × 45
#>    station_id event_code gear  species_tsn common_name  scientific_name lhs_code
#>         <dbl>      <int> <chr>       <int> <chr>        <chr>           <chr>   
#> 1 20030101001          3 CAN        161977 Coho Salmon  Oncorhynchus k… J       
#> 2 20030101001          3 CAN        161979 Sockeye Sal… Oncorhynchus n… J       
#> 3 20030101001          3 CAN        161980 Chinook Sal… Oncorhynchus t… J       
#> 4 20030101001          3 CAN        161976 Chum Salmon  Oncorhynchus k… J       
#> 5 20030101001          3 CAN        161975 Pink Salmon  Oncorhynchus g… J       
#> 6 20030101002          3 CAN        161977 Coho Salmon  Oncorhynchus k… J       
#> # ℹ 38 more variables: cruise_id <chr>, sample_year <int>, tow_type <chr>,
#> #   gear_performance <chr>, region <chr>, eq_time <dttm>, eq_latitude <dbl>,
#> #   eq_longitude <dbl>, gear_in_time <dttm>, gear_in_latitude <dbl>,
#> #   gear_in_longitude <dbl>, gear_out_time <dttm>, gear_out_latitude <dbl>,
#> #   gear_out_longitude <dbl>, haulback_time <dttm>, haulback_latitude <dbl>,
#> #   haulback_longitude <dbl>, tow_duration <dbl>, master_station_name <chr>,
#> #   nbs_strata <int>, bsierp_region <int>, oceanographic_domain <int>, …
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
#> Warning in join_event_catch(start_year = 2008, end_year = 2018, survey_region =
#> "SEBS", : Local data files exist. Formatting file from those exports
#> [1] "Last AKFIN catch table upload date 2026-01-02T10:38:05Z"

nrow(df); head(df)
#> [1] 272
#> # A tibble: 6 × 45
#>    station_id event_code gear  species_tsn common_name scientific_name  lhs_code
#>         <dbl>      <int> <chr>       <int> <chr>       <chr>            <chr>   
#> 1 20080306033          3 CAN        164711 Pacific Cod Gadus macroceph… A0      
#> 2 20080306037          3 CAN        164711 Pacific Cod Gadus macroceph… A0      
#> 3 20080306039          3 CAN        164711 Pacific Cod Gadus macroceph… A0      
#> 4 20090305002          3 CAN        164711 Pacific Cod Gadus macroceph… A0      
#> 5 20090305050          3 CAN        164711 Pacific Cod Gadus macroceph… A0      
#> 6 20100304047          3 CAN        164711 Pacific Cod Gadus macroceph… A0      
#> # ℹ 38 more variables: cruise_id <chr>, sample_year <int>, tow_type <chr>,
#> #   gear_performance <chr>, region <chr>, eq_time <dttm>, eq_latitude <dbl>,
#> #   eq_longitude <dbl>, gear_in_time <dttm>, gear_in_latitude <dbl>,
#> #   gear_in_longitude <dbl>, gear_out_time <dttm>, gear_out_latitude <dbl>,
#> #   gear_out_longitude <dbl>, haulback_time <dttm>, haulback_latitude <dbl>,
#> #   haulback_longitude <dbl>, tow_duration <dbl>, master_station_name <chr>,
#> #   nbs_strata <int>, bsierp_region <int>, oceanographic_domain <int>, …
```
