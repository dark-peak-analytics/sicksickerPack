#' Grab data hosted remotely
#'
#' @description Access and download remotely hosted data. This function allows
#' access to secured data.
#'
#' @param source_url_ String identifying the Uniform Resource Locator (URL)
#' for the remote (cloud) storage where the target data is stored. The
#' `source_url_` should not include a trailing forward-slash (`/`).
#' @param source_path_ String identifying the path of the data within the URL
#' passed to the `source_url_` argument. If the URL passed to the `source_url_`
#' argument is for an API, then the string passed to this argument is the name
#' of the API endpoint which returns the data of interest. The `source_path_`
#' should not include a preceding forward-slash (`/`).
#' @param source_credentials_ String identifying the key required to access the
#' `source_url_`. Pass an empty string (`""`) if the source does not require a
#' key, password, or other credentials.
#'
#' @return An object, likely a data table (dataframe) but depends on the type of
#' object storing the data in the remote server or returned by the hosting API.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' get_model_params_(
#'   source_url_ = "https://sicksickerpack-v7po7ubcwa-nw.a.run.app",
#'   source_path_ = "modelRunParams",
#'   source_credentials_ = "R-HTA_2023"
#' )
#' }
get_model_params_ <- function(source_url_,
                              source_path_,
                              source_credentials_) {
  ## Sanity checks - inputs:

  # ensure that user supplied remote information are strings
  for (x in c("source_url_", "source_path_", "source_credentials_")) {
    assertthat::assert_that(
      assertthat::is.string(get(x)),
      msg = paste(
        "The object passed to the", x, "argument is not of class string"
      )
    )
  }

  hosted_data <- if(source_credentials_ != "") {
    httr::GET(
      url = paste0(
        ## URL to the API:
        source_url_,
        "/",
        ## path for the API endpoint within the API URL:
        source_path_
      ),
      ## pass the API key to the request object:
      config = httr::add_headers(
        ## the API key is passed via a header we call key:
        key = source_credentials_
      )
    ) |>
      ## process returned data:
      httr::content()
  } else {
    httr::GET(
      url = paste0(
        ## URL to the API:
        source_url_,
        "/",
        ## path for the API endpoint within the API URL:
        source_path_
      )
    ) |>
      ## process returned data:
      httr::content()
  }

  return(hosted_data)
}
