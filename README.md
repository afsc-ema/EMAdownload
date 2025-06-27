# EMAdownload
R package built to query and join survey data from EMA survey datasets from AKFIN APIs.  Currently catch and specimen data are operational, with CTD and other oceanographic data to follow.

Note: last full load date of EMA data to AKFIN was 1-30-2025.

For a list of vignettes, please use `browseVignettes(EMAdownload)`

## Package Installation Instructions:
To install the package, please run the line below. This package is regularly being updated as functionality is improved and expanded, so we recommend updating frequently.

`devtools::install_github("afsc-ema/EMAdownload", quiet = F, force = T, dependencies=TRUE, build_vignettes=TRUE)`

If you get errors related to the package being in use and that it will not be re-installed, try detaching it first and then re-installing it (above):

`detach("package:EMAdownload", unload = T)`

## Data Functions:
This package has functions to automate the querying and formatting of EMA datasets. For beginner users, we recommend using the following two functions: 

- join_event_catch() for catch data. This function queries event and catch data, then passes any filters entered as arguments for the function to filter respective data products before joining them together. Arguments include year range, survey region, gear used, trawl method, and species code/lhs.  

For a detailed breakdown of this, 
use `vignette(join_event_catch_guide,package="EMAdownload")`

- join_event_fish() for specimen data  

For users experienced with EMA data and the nuances of the data, you can set up your own filters and joins using the individual data obtained with the following functions:

  - get_ema_catch (catch data) 
  
  - get_ema_event(sampling events) 
  
  - get_ema_event_parameters (post-sampling calculated event values (i.e. effort, footrope depth)) 
  
  - get_ema_fish (specimen data) 
  
  - get_ema_taxonomy (species tsn lookup).  
  
Note, at the moment only join_event_catch and join_event_fish have filtering arguments
built into the functions.  All other function calls simply query the API link for a full and complete datasets and can take a few minutes to download from AKFIN. 

## Data Structure:

EMA survey data are nuanced, as survey design and sample processing has changed throughout the timeseries. Please use
`vignette(EMAdownload_introduction,package="EMAdownload")` to see a full write-up of all important data concepts.


For any issues, please post them at https://github.com/afsc-ema/EMAdownload/issues
