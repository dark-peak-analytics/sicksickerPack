#' Run Probabilistic Sensitivity Analysis (PSA)
#'
#' @param model_func_ String scalar naming the function defining the decision
#' analytic model.
#' @param model_func_args_ List of arguments passed to the function named in the
#' \code{model_func} argument.
#' @param psa_params_names_ String vector of length one or more defining the
#' names of the parameters for which PSA configurations will be sampled.
#' @param psa_params_dists_ String vector of length one or more defining the
#' names of the distributions of each of the corresponding PSA parameters
#' named in the vector passed \code{psa_params_names_}.
#' @param psa_params_dists_args_ List of lists containing named numeric scalar
#' representing the arguments to be passed to the corresponding PSA
#' distributions named in the vector passed to the \code{psa_params_dists_}
#' argument.
#' @param n_sim_ Numeric scalar setting the number of parameter-configurations
#' to be sampled for PSA purposes.
#' @param source_url_ String identifying the Uniform Resource Locator (URL)
#' for the remote (cloud) storage where the function could access a version of
#' the PSA data. This function expects PSA data in a list which contains three
#' lists identical to \code{psa_params_names_}, \code{psa_params_dists_} and
#' \code{psa_params_dists_args_}.
#' @param source_path_ String identifying the path of the data within the URL
#' passed to the \code{source_url_} argument. If the URL passed to the
#' \code{source_url_} argument is for an API, then the string passed to this
#' argument is the name of the API endpoint which returns the data of interest.
#' @param source_credentials_ String identifying the key required to access the
#' \code{source_url_}.
#'
#' @return A data table (dataframe) containing the results from the PSA.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' PSA_results <- run_psa(
#'   model_func_ = "run_sickSicker_model",
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
#' PSA_results <- run_psa(
#'   model_func_ = "run_sickSicker_model",
#'   model_func_args_ = list(
#'     age_init_ = 25,
#'     age_max_  = 55,
#'     discount_rate_ = 0.035
#'   ),
#'   psa_params_names_ = NULL,
#'   psa_params_dists_ = NULL,
#'   psa_params_dists_args_ = NULL,
#'   n_sim_ = 2,
#'   source_url_ = "http://127.0.0.1:8080",
#'   source_path_ = "/psaRunParams",
#'   source_credentials_ = "R-HTA_2023"
#' )
#' }
run_psa <- function(model_func_,
                    model_func_args_,
                    psa_params_names_,
                    psa_params_dists_,
                    psa_params_dists_args_,
                    n_sim_,
                    source_url_ = NULL,
                    source_path_ = NULL,
                    source_credentials_ = NULL) {
  ## Sanity checks - inputs:

  # ensure the model function "model_func" is an available/accessible function
  assertthat::assert_that(
    is.function(get(model_func_)),
    msg = paste(
      "There is no function named",
      model_func_,
      "in the global environment or the loaded packages"
    )
  )
  # assert "model_func_args_" and psa_params_dists_args_ are of type list
  for (x in c("model_func_args_", "psa_params_dists_args_")) {
    assertthat::assert_that(
      any(is.list(x = get(x)), is.null(x = get(x))),
      msg = paste(
        "The object passed to the", x, "argument is not a list or not NULL"
      )
    )
  }
  # confirm "psa_params_names_" and "psa_params_dists_" are NULL or string
  for (x in c("psa_params_names_", "psa_params_dists_")) {
    assertthat::assert_that(
      any(is.vector(x = get(x), mode = "character"), is.null(x = get(x))),
      msg = paste(
        "The object passed to the", x, "argument is not of class string or NULL"
      )
    )
  }
  # ensure that the user supplied remote location and credentials
  if(all(is.null(psa_params_names_),
         is.null(psa_params_dists_),
         is.null(psa_params_dists_args_))) {
    for (x in c("source_url_", "source_path_", "source_credentials_")) {
      assertthat::assert_that(
        assertthat::is.string(get(x)),
        msg = paste(
          "The object passed to the", x, "argument is not of class string"
        )
      )
    }
  }

  ## Grab remotely stored data, if any:
  if(all(is.null(psa_params_names_),
         is.null(psa_params_dists_),
         is.null(psa_params_dists_args_))) {
    remote_data <- get_model_params_(
      source_url_ = source_url_,
      source_path_ = source_path_,
      source_credentials_ = source_credentials_
    )

    psa_params_names_ <- remote_data$psa_params_names
    psa_params_dists_ <- remote_data$psa_params_dists
    psa_params_dists_args_ <- remote_data$psa_params_dists_args
  }

  ## Sample PSA configurations:

  psa_params <- sample_psa_data(
    psa_params_names_ = psa_params_names_,
    psa_params_dists_ = psa_params_dists_,
    psa_params_dists_args_ = psa_params_dists_args_,
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
