#' Grab data hosted remotely
#'
#' @description Access and download remotely hosted data. This function allows
#' access to secured data.
#'
#' @param source_url_ String identifying the Uniform Resource Locator (URL)
#' for the remote (cloud) storage where the target data is stored.
#' @param source_path_ String identifying the path of the data within the URL
#' passed to the \code{source_url_} argument. If the URL passed to the
#' \code{source_url_} argument is for an API, then the string passed to this
#' argument is the name of the API endpoint which returns the data of interest.
#' @param source_credentials_ String identifying the key required to access the
#' \code{source_url_} or the endpoint identified by the \code{source_path_}
#' argument.
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
#'   source_url_ = "http://127.0.0.1:8080",
#'   source_path_ = "/modelRunParams",
#'   source_credentials_ = "R-HTA_2023"
#' )
#' }
get_model_params_ <- function(source_url_,
                              source_path_,
                              source_credentials_) {
  hosted_data <- httr::GET(
    ## the API URL can also be kept confidential:
    url = source_url_,
    ## path for the API endpoint within the API URL:
    path = source_path_,
    ## pass the API key to the request object:
    config = httr::add_headers(
      ## the API key is passed via a header we call key:
      key = source_credentials_)) |>
    ## process returned data:
    httr::content()

  return(hosted_data)
}
