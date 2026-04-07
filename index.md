# EMAdownload

Note: last full load date of EMA data to AKFIN was 2026-04-06T14:13:41Z

## Package Installation Instructions:

To install the package, please run the line below. This package is
currently under development to improve functionality, please update
frequently and/or review the
[changelog](https://github.com/afsc-ema/EMAdownload/commits/v0.1.0).

``` r
# install.packages("devtools")
devtools::install_github("afsc-ema/EMAdownload", quiet = F, force = T, dependencies=TRUE, build_vignettes=TRUE)
```

If you get errors related to the package being in use and that it will
not be re-installed, try detaching it first and then re-installing it
(above):

``` r
detach("package:EMAdownload", unload = T)
```

## Data Structure:

EMA survey design and sample processing has changed throughout the
timeseries given funding and survey objectives. Please review the
introduction vignettes to better understand these data, [introduction
vignette](https://afsc-ema.github.io/EMAdownload/articles/EMAdownload_introduction.html).

Metadata/data look up tables can be viewed in the [EMA lookup tables
vignette](https://afsc-ema.github.io/EMAdownload/articles/EMA-lookup-tables.html)

If you have additional questions, please reach out through the
Discussion board or directly email the developers.

## Accessing Data:

Right now only fish related (events, catch, and specimen level) data are
available through EMAdownload. For access to oceanographic data, please
reach out to developers.

To access data, we recommend using these two functions:

- join_event_catch() for catch data with all associated event
  information. Arguments include start and end year, survey region, gear
  used, trawl method, and species code/lhs. Please see
  ?join_event_catch() for more information. A brief vignette for use is
  available
  [here](https://afsc-ema.github.io/EMAdownload/articles/join_event_catch_guide.html)

- join_event_fish() for specimen data with all associated event
  information. Similar to join_event_catch(), argument include start and
  end year, survey region, gear used, trawl method, and species code.

For species taxonomic species number (species tsn) look up we recommend
using get_ema_taxonomy() to see full list of species for which we have
data available.

For users familiar with these data, you get and join data with the
following functions: However, please note you should be familiar with
how the primary and secondary keys of these data to join them correctly.

- get_ema_event (sampling events)

- get_ema_event_parameters (post-sampling calculated event values,
  i.e. effort, footrope depth)

- get_ema_catch (catch data)

- get_ema_fish (specimen data)

- get_ema_taxonomy (species tsn lookup).

Note: these function calls simply query the API link for a full and
complete datasets and can take a few minutes to download from AKFIN.

For any issues, please post them in [EMAdownload github
issues](https://github.com/afsc-ema/EMAdownload/issues)

## Disclaimer

This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project
content is provided on an ‘as is’ basis and the user assumes
responsibility for its use. The scientific results and conclusions, as
well as any views or opinions expressed herein, are those of the
author(s) and do not necessarily reflect the views of NOAA or the
Department of Commerce.

**Package is under active development and functionality may change
without notice**
