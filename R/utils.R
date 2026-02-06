#' Internal helper to download and cache EMA data
#' @param url The AKFIN API endpoint URL
#' @param name A short string used to name the cache files (e.g., "event", "catch")
#' @param force_download Bypass cache and force download
#' @return a dataframe when used within a get function
#' @keywords internal
#' @noRd

.ema_downloader <- function(url, name, force_download = FALSE) {
    # Create file.paths for cached data/directories
    cache_dir  <- tools::R_user_dir("EMAdownload", which = "cache")
    cache_file <- file.path(cache_dir, paste0(name, "_cache.rds"))
    etag_file  <- file.path(cache_dir, paste0(name, "_etag.txt"))

    if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)

    # Get the already cached server etag if its there
    # if its not there, then this returns null
    message("Checking AKFIN for updates to ", name, "...")
    # Wrap in tryCatch in case the user is offline
    # "peaks" at data on server for etag
    server_etag <- tryCatch({
      resp <- httr::HEAD(url)
      httr::headers(resp)$etag
    }, error = function(e) return(NULL))

    #Determine if update is needed: cases where needed true force download,
    # if there's no cached file or if the server etag is null
    # the || means or until a condition is met
    needs_update <- force_download || !file.exists(cache_file) || is.null(server_etag)

    # tests if needs update is TRUE AND there's an etag file
    # double && makes sure that only one vector is returned rather than a vector of any length
    if (!needs_update && file.exists(etag_file)) {
      local_etag <- readLines(etag_file, warn = FALSE)
      # checks to see if etag in server matches whats in local server
      if (server_etag != local_etag) {
        message("New ", name, " data detected. Updating...")
        needs_update <- TRUE
      }
    }

    # Based on this, download new data or pull from cache
    if (needs_update) {
      message("Downloading ", name, " data...")
      # takes the url, which is input from the species get_ema_event etc fxn
      response <- httr::GET(url)

      # if the response is a 200 means that the execution is success, go ahead and download
      # note: according to ?http_status codes can also be in 100s and 200s and be successful
      if (httr::status_code(response) == 200) {
        data <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

        # save the data in the form of RDS in the cache file, cache directory
        saveRDS(data, cache_file)

        # if the server etag is not null then write out the server etag to the
        # etag file and update the cached etag
        if (!is.null(server_etag)) writeLines(as.character(server_etag), etag_file)
      } else {
        # Fallback: if download fails but we have a cache, use the cache
        if (file.exists(cache_file)) {
          warning("Download failed. Using existing cache.")
          data <- readRDS(cache_file)
        } else {
          stop("Download failed and no local cache exists.")
        }
      }
      # if data isn't new, force_download isn't true, or download doesn't work
    } else {
      message("Using cached ", name, " data.")
      data <- readRDS(cache_file)
    }

    return(data)
}



#' Clear Local EMA Data Cache
#'
#' @description Deletes the local .rds files and ETag logs stored in the
#' user's AppData/Cache folder.
#'
#' @param name Optional string. If provided (e.g., "event"), only deletes
#' that specific cache. If NULL (default), wipes the entire EMAdownload cache folder.
#' @export
clear_ema_cache <- function(name = NULL) {
  cache_dir <- tools::R_user_dir("EMAdownload", which = "cache")

  if (!dir.exists(cache_dir)) {
    message("No cache directory found. Nothing to clear.")
    return(invisible(NULL))
  }

  if (is.null(name)) {
    # Delete the whole folder
    unlink(cache_dir, recursive = TRUE)
    message("Full EMAdownload cache cleared.")
  } else {
    # Delete specific files
    cache_file <- file.path(cache_dir, paste0(name, "_cache.rds"))
    etag_file  <- file.path(cache_dir, paste0(name, "_etag.txt"))

    files_to_remove <- c(cache_file, etag_file)
    removed <- file.remove(files_to_remove[file.exists(files_to_remove)])

    if (any(removed)) {
      message("Cleared cache for: ", name)
    } else {
      message("No cache files found for: ", name)
    }
  }
}
