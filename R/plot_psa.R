#' Generate Probabilistic Sensitivity Analysis (PSA) Plots
#'
#' @description Draw plots using the results from the Probabilistic Sensitivity
#' Analysis (PSA) performed using the \code{\link{run_psa}} function. The PSA
#' outputs are passed to the \code{\link[BCEA]{bcea}} function to generate the
#' plots.
#'
#' @param psa_results_ Data table (dataframe) representing the outputs from the
#' \code{\link{run_psa}} function.
#' @param interventions_ String vector, of length 2 or more, containing the
#' names of the health technologies under comparison.
#' @param reference_ String scalar defining which intervention (columns of in
#' the \code{psa_results_} dataframe) is considered to be the reference
#' strategy. The default value 1 means that the intervention associated with the
#' first column in the \code{psa_results_} dataframe is the reference and the
#' one(s) associated with the other column(s) is(are) the comparators.
#' @param threshold_ Numeric scalar, specifying the cost-per-effect or
#' (cost-per-QALY) to be used in estimating the incremental benefits to be
#' reported in the cost-effectiveness table.
#' @param maximum_threshold_ Numeric scalar, specifying the maximum
#' cost-effectiveness (willingness-to-pay) threshold to be used in generating
#' the PSA plots.
#' @param effects_prefix_ String scalar, defining the prefix of the effects
#' columns in the PSA data table.
#' @param costs_prefix_ String scalar, defining the prefix of the costs columns
#' in the PSA data table.
#'
#' @return A list containing the following elements
#' \describe
#'  \item{CE table}{Cost-Effectiveness Table}
#'  \item{CE plane}{Cost-Effectiveness Plane}
#'  \item{CEAC}{Cost-Effectiveness Acceptability Curve}
#'  \item{CEAF}{Cost-Effectiveness Acceptability Frontier Plot}
#'  \item{EVPI}{Expected Value of Perfect Information Plot}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(sicksickerPack)
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
#'   n_sim_ = 1e4
#' )
#'
#' PSA_plots <- plot_psa(
#'   psa_results_ = PSA_results,
#'   interventions_ = c("Status quo", "Treatment"),
#'   reference_ = 2,
#'   maximum_threshold_ = 1e5,
#'   effects_prefix_ = "QALYs_",
#'   costs_prefix_ = "Cost_"
#' )
#' }
plot_psa <- function(psa_results_,
                     interventions_,
                     reference_ = 1,
                     threshold_ = 3e4,
                     maximum_threshold_ = 1e5,
                     effects_prefix_ = "QALYs_",
                     costs_prefix_ = "Cost_") {
  ## Sanity checks - inputs:

  # confirm params_ is a list or NULL if it was to be passed remotely
  assertthat::assert_that(
    inherits(x = psa_results_, what = "psa"),
    msg = paste(
      "The object passed to the params_ argument is not a psa object"
    )
  )
  # ensure scalar numeric inputs are of correct class and length
  assertthat::assert_that(
    assertthat::is.count(reference_),
    msg = paste(
      "The object passed to the reference_ argument is not a scalar integer"
    )
  )
  for (x in c("threshold_", "maximum_threshold_")) {
    assertthat::assert_that(
      assertthat::is.number(get(x)),
      msg = paste(
        "The object passed to the", x, "argument is not a scalar numeric"
      )
    )
  }
  # ensure scalar string inputs are of correct class and length
  assertthat::assert_that(
    is.character(interventions_),
    msg = paste(
      "The object passed to the interventions_ argument is not a string vector"
    )
  )
  for (x in c("effects_prefix_", "costs_prefix_")) {
    assertthat::assert_that(
      assertthat::is.string(get(x)),
      msg = paste(
        "The object passed to the", x, "argument is not a scalar string"
      )
    )
  }

  ## Prepare BCEA::beca() function inputs:

  results_names_ <- psa_results_ |> colnames()
  effets <- psa_results_[
    results_names_[grepl(pattern = effects_prefix_, x = results_names_)]
  ] |>
    as.matrix()
  costs <- psa_results_[
    results_names_[grepl(pattern = costs_prefix_, x = results_names_)]
  ] |>
    as.matrix()

  ## Call BCEA::beca() to process the PSA results:

  bcea_object <- BCEA::bcea(
    eff = effets,
    cost = costs,
    ref = reference_,
    interventions = interventions_,
    Kmax = maximum_threshold_
  )

  ## Call BCEA plotting functions:

  ce_table = BCEA::ce_table(
    he = bcea_object,
    wtp = threshold_,
    graph = "ggplot2"
  )
  ce_plane = BCEA::ceplane.plot(
    he = bcea_object,
    wtp = threshold_,
    graph = "ggplot2"
  )
  ceac = BCEA::ceac.plot(
    he = bcea_object,
    graph = "ggplot2"
  )
  ceaf = BCEA::ceaf.plot(
    mce = BCEA::multi.ce(
      he = bcea_object
    ),
    graph = "ggplot2"
  )
  evpi = BCEA::evi.plot(
    he = bcea_object,
    graph = "ggplot2"
  )

  ## Return results:

  return(
    list(
      "CE table" = ce_table,
      "CE plane" = ce_plane,
      "CEAC" = ceac,
      "CEAF" = ceaf,
      "EVPI" = evpi
    )
  )
}
