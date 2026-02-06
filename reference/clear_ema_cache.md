# Clear Local EMA Data Cache

Deletes the local .rds files and ETag logs stored in the user's
AppData/Cache folder.

## Usage

``` r
clear_ema_cache(name = NULL)
```

## Arguments

- name:

  Optional string. If provided (e.g., "event"), only deletes that
  specific cache. If NULL (default), wipes the entire EMAdownload cache
  folder.
