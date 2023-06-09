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

  ## Alerting users that remote data is being fetched:

  source_address = paste0(
    ## URL to the API:
    source_url_,
    "/",
    ## path for the API endpoint within the API URL:
    source_path_
  )

  rlang::inform(
    message = paste(
      "Connecting to",
      source_address,
      "..."
    )
  )

  ## Grab remote data:

  hosted_data <- if(source_credentials_ != "") {
    response <- httr::GET(
      url = source_address,
      ## pass the API key to the request object:
      config = httr::add_headers(
        ## the API key is passed via a header we call key:
        key = source_credentials_
      )
    )
    ## Check for errors:
    if(httr::http_error(response)) {
      rlang::abort(
        message = paste(
          "Error connecting to the server/API or the path/endpoint",
          "therewithin. Please check the information passed to the source_url_,",
          "source_path_ and source_credentials_ argumnets and try again."
        )
      )
    }
      ## process returned data:
    response |>
      httr::content()
  } else {
    response <- httr::GET(
      url = source_address
    )

    ## Check for errors:
    if(httr::http_error(response)) {
      rlang::abort(
        message = paste(
          "Error connecting to the server/API or the path/endpoint",
          "therewithin. Please check the information passed to the source_url_,",
          "source_path_ and source_credentials_ argumnets and try again."
        )
      )
    }
    ## process returned data:
    response |>
      httr::content()
  }

  return(hosted_data)
}
