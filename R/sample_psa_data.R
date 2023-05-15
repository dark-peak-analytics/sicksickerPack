#' Sample Probabilistic Sensitivity Analysis (PSA) Configurations
#'
#' @description A general purposes function to generate Probabilistic
#' Sensitivity Analysis (PSA) parameters' configurations. This function allows
#' sampling from any distribution supported by the `base` and `truncnorm`
#' packages - user supplied distributions will be checked against available
#' functions.
#'
#' @param psa_params_names_ String vector of length one or more defining the
#' names of the parameters for which PSA configurations will be sampled.
#' @param psa_params_dists_ String vector of length one or more defining the
#' names of the distributions of each of the corresponding to the PSA parameters
#' named in the vector passed `psa_params_names_`.
#' @param psa_params_dists_args_ List of lists containing named numeric scalar
#' representing the arguments to be passed to the corresponding PSA
#' distributions named in the vector passed to the `psa_params_dists_` argument.
#' @param n_sim_ Numeric scalar setting the number of parameter-configurations
#' to be sampled for PSA purposes.
#'
#' @importFrom truncnorm rtruncnorm
#'
#' @return A data table (dataframe/tibble) containing the parameters'
#' configurations.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
# psa_sets = sample_psa_data(
#   psa_params_names_ = psa_params_names,
#   psa_params_dists_ = psa_params_dists,
#   psa_params_dists_args_ = psa_params_dists_args,
#   n_sim_ = 100
#   )
#' }
sample_psa_data <- function(psa_params_names_,
                            psa_params_dists_,
                            psa_params_dists_args_,
                            n_sim_) {
  ## Prepare inputs:

  loop_list <- list(
    as.list(psa_params_names_),
    as.list(psa_params_dists_),
    psa_params_dists_args_
  )

  ## Generate PSA configurations:

  df_psa <- purrr::pmap(
    .l = loop_list,
    .f = function(name_, dist_, args_) {
      if(dist_ == "fixed") {
        fixed_value <- unlist(args_)

        # ensure a scalar had been supplied
        assertthat::assert_that(
          assertthat::is.scalar(x = fixed_value),
          msg = paste(
            "More than one value passed to the fixed distibution of",
            name_
          )
        )
        # fixed values are repeated n_sim_ times
        rep(fixed_value, n_sim_) |>
          as.data.frame() |>
          `colnames<-`(name_)
      } else {
        func <- paste0("r", dist_)

        # sample from user-defined distribution
        purrr::exec(
          .fn = func,
          n_sim_,
          !!!args_
        ) |>
          as.data.frame() |>
          `colnames<-`(name_)
      }
    }
  ) |>
    purrr::list_cbind()

  return(df_psa)
}
