#' Run Probabilistic Sensitivity Analysis (PSA)
#'
#' @description A generic function that performs Probabilistic Sensitivity
#' Analysis (PSA) given a decision-analytic model.
#'
#' @param model_func_ Function defining the decision analytic model for which
#' the PSA will be performed.
#' @param model_func_args_ List of arguments passed to the function named in the
#' \code{model_func} argument.
#' @param psa_params_names_ String vector of length one or more defining the
#' names of the parameters for which PSA configurations will be sampled.
#' @param psa_params_dists_ String vector of length one or more defining the
#' names of the distributions of each of the corresponding PSA parameters
#' named in the vector passed `psa_params_names_`.
#' @param psa_params_dists_args_ List of lists containing named numeric scalar
#' representing the arguments to be passed to the corresponding PSA
#' distributions named in the vector passed to the `psa_params_dists_` argument.
#' @param n_sim_ Numeric scalar setting the number of parameter-configurations
#' to be sampled for PSA purposes.
#' @param source_url_ String identifying the Uniform Resource Locator (URL)
#' for the remote (cloud) storage where the function could access a version of
#' the PSA data. This function expects PSA data in a list which contains three
#' lists identical to `psa_params_names_`, `psa_params_dists_` and
#' `psa_params_dists_args_`. The `source_url_` should not include a trailing
#' forward-slash (`/`).
#' @param source_path_ String identifying the path of the data within the URL
#' passed to the `source_url_` argument. If the URL passed to the `source_url_`
#' argument is for an API, then the string passed to this argument is the name
#' of the API endpoint which returns the data of interest. The `source_path_`
#' should not include a preceding forward-slash (`/`).
#' @param source_credentials_ String identifying the key required to access the
#' `source_url_`. Pass an empty string (`""`) if the source does not require a
#' key, password, or other credentials.
#'
#' @return A data table (dataframe) containing the results from the PSA.
#'
#' @details This function uses the \code{\link{sample_psa_data}} together with
#' the parameters - passed to the `psa_params_names_`, `psa_params_dists_`, and
#' `psa_params_dists_args_` arguments to generate PSA parameter configuration.
#' The sampled PSA sets are then evaluated by the model - passed to the
#' `model_func_` arguments.
#'
#' Note that this function loops through the PSA parameter sets using the
#' \code{\link[purrr]{pmap}} function.
#'
#' Users can choose between passing local data, as in the above example, or
#' remote PSA data by passing the URL or Application Programming Interface (API)
#' address, path and any required credentials to the `source_url_`,
#' `source_path_`, and `source_credentials_` arguments. The remote data is then
#' retrieved by the \code{\link{get_model_params_}} function.
#' See the examples section for a demo code.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#'
#' ## Locally stored data:
#' PSA_results <- run_psa(
#'   model_func_ = sicksickerPack::run_sickSicker_model,
#'   model_func_args_ = list(
#'     age_init_ = 25,
#'     age_max_  = 55,
#'     discount_rate_ = 0.035
#'   ),
#'   psa_params_names_ = dummy_sickSickerModel_psa_params$
#'     psa_params_names,
#'   psa_params_dists_ = dummy_sickSickerModel_psa_params$
#'     psa_params_dists,
#'   psa_params_dists_args_ = dummy_sickSickerModel_psa_params$
#'     psa_params_dists_args,
#'   n_sim_ = 2
#' )
#'
#' ## Remotely stored data:
#' PSA_results <- run_psa(
#'   model_func_ = sicksickerPack::run_sickSicker_model,
#'   model_func_args_ = list(
#'     age_init_ = 25,
#'     age_max_  = 55,
#'     discount_rate_ = 0.035
#'   ),
#'   n_sim_ = 2,
#'   source_url_ = "https://sicksickerpack-v7po7ubcwa-nw.a.run.app",
#'   source_path_ = "psaRunParams",
#'   source_credentials_ = "R-HTA_2023"
#' )
#' }
run_psa <- function(model_func_ = sicksickerPack::run_sickSicker_model,
                    model_func_args_ =  list(
                      age_init_ = 25,
                      age_max_  = 55,
                      discount_rate_ = 0.035
                    ),
                    psa_params_names_ = NULL,
                    psa_params_dists_ = NULL,
                    psa_params_dists_args_ = NULL,
                    n_sim_ = 1e3,
                    source_url_ = NULL,
                    source_path_ = NULL,
                    source_credentials_ = NULL) {
  ## Sanity checks - inputs:

  # ensure the model function "model_func" is an available/accessible function
  assertthat::assert_that(
    is.function(model_func_),
    msg = paste(
      "The object passed to the 'model_func_' argument is either not a",
      "function or such a function is not in the global environment or the",
      "loaded packages"
    )
  )
  # assert "model_func_args_" are of type list, if not NULL
  assertthat::assert_that(
    any(is.list(model_func_args_), is.null(model_func_args_)),
    msg = paste(
      "The object passed to the 'model_func_args_' argument is not a list or",
      "not NULL"
    )
  )
  # ensure that the user supplied remote location and credentials
  if(all(is.null(source_url_),
         is.null(source_path_),
         is.null(source_credentials_),
         !is.null(psa_params_names_),
         !is.null(psa_params_dists_),
         !is.null(psa_params_dists_args_))) {
    # confirm "psa_params_names_" and "psa_params_dists_" are NULL or string
    for (x in c("psa_params_names_", "psa_params_dists_")) {
      assertthat::assert_that(
        is.vector(x = get(x), mode = "character"),
        msg = paste(
          "The object passed to the", x, "argument is not of class string"
        )
      )
    }

    assertthat::assert_that(
      is.list(psa_params_dists_args_),
      msg = paste(
        "The object passed to the 'psa_params_dists_args_' argument is not a",
        "list"
      )
    )

    psa_params_names <- psa_params_names_
    psa_params_dists <- psa_params_dists_
    psa_params_dists_args <- psa_params_dists_args_
  } else if (all(!is.null(source_url_),
                 !is.null(source_path_),
                 !is.null(source_credentials_),
                 is.null(psa_params_names_),
                 is.null(psa_params_dists_),
                 is.null(psa_params_dists_args_))){
    # ensure that user supplied remote information are strings
    for (x in c("source_url_", "source_path_", "source_credentials_")) {
      assertthat::assert_that(
        assertthat::is.string(get(x)),
        msg = paste(
          "The object passed to the", x, "argument is not of class string"
        )
      )
    }

    ## Grab remotely stored data, if any:

    remote_data <- get_model_params_(
      source_url_ = source_url_,
      source_path_ = source_path_,
      source_credentials_ = source_credentials_
    )

    # ensure remotely stored object is a list
    assertthat::assert_that(
      is.list(remote_data),
      msg = paste(
        "The object retrieved from the remote server/API is not a list"
      )
    )
    # confirm (cloud) psa_params_names and psa_params_dists are strings
    for (x in c("psa_params_names", "psa_params_dists")) {
      assertthat::assert_that(
        is.list(x = get(x, pos = remote_data)),
        msg = paste(
          "The objects stored remotely as", x, "is not a list"
        )
      )
    }

    psa_params_names <- remote_data$psa_params_names
    psa_params_dists <- remote_data$psa_params_dists
    psa_params_dists_args <- remote_data$psa_params_dists_args
  } else {
    assertthat::assert_that(
      FALSE,
      msg = paste(
        "Conflicting arguments detected! To perform PSA using locally stored",
        "data, pass the appropriate objects to the 'psa_params_names_',",
        "'psa_params_dists_', and 'psa_params_dists_args_' arguments;",
        "otherwise, provide the required server/API information to the",
        "'source_url_', 'source_path_', and 'source_credentials_' arguments to",
        "retrieve PSA arguments from the cloud. Passing arguments in any other",
        "configuration is prohibited."
      )
    )
  }

  ## Sample PSA configurations:

  psa_params <- sample_psa_data(
    psa_params_names_ = psa_params_names,
    psa_params_dists_ = psa_params_dists,
    psa_params_dists_args_ = psa_params_dists_args,
    n_sim_ = n_sim_
  )

  ## Loop through each PSA set:

  psa_results <- purrr::pmap(
    .l = as.list(psa_params),
    .f = function(...) {
      params <- list(...)
      params <- c(
        model_func_args_,
        params
      )

      run_results <- purrr::exec(
        .fn = model_func_,
        params_ = params
      )

      # flip the results if it was of class vector
      run_results <- if(is.numeric(run_results)) {
        run_results |>
          t() |>
          as.data.frame()
      } else {
        run_results |>
          as.data.frame()
      }
    },
    .progress = list(name = "Running PSA")
  ) |>
    purrr::list_rbind()

  ## Tag the outputs object as "psa":

  class(psa_results) <- c(class(psa_results), "psa")

  return(psa_results)
}
