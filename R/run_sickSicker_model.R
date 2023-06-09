#' Run the SickSicker State-Transition Model
#'
#' @description Run the SickSicker Markov model.
#'
#' @param params_ List containing the model parameters. This list should contain
#' the following objects:
#' \describe{
#'  \item{age_init_}{Age at baseline, default = `25`}
#'  \item{age_max_}{Maximum age of follow up, default = `55`}
#'  \item{discount_rate_}{Discount rate for costs and QALYs}
#'  \item{p_HD}{Probability to die when healthy}
#'  \item{p_HS1}{Probability to become sick when healthy}
#'  \item{p_S1H}{Probability to become healthy when sick}
#'  \item{p_S1S2}{Probability to become sicker when sick}
#'  \item{hr_S1}{Hazard ratio of death in sick v healthy}
#'  \item{hr_S2}{Hazard ratio of death in sicker v healthy}
#'  \item{c_H}{Cost of remaining one cycle in the healthy state}
#'  \item{c_S1}{Cost of remaining one cycle in the sick state}
#'  \item{c_S2}{Cost of remaining one cycle in the sicker state}
#'  \item{c_Trt}{Cost of treatment(per cycle)}
#'  \item{c_D}{Cost of being in the death state}
#'  \item{u_H}{Utility when healthy}
#'  \item{u_S1}{Utility when sick}
#'  \item{u_S2}{Utility when sicker}
#'  \item{u_D}{Utility when dead}
#'  \item{u_Trt}{Utility when being treated}
#' }
#' @param source_url_ String identifying the Uniform Resource Locator (URL)
#' for the remote (cloud) storage where the function could access a version of
#' the data expected in the object passed to the `params_` argument. The
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
#' @return A matrix containing the costs and QALYs generated by running the
#' SickSicker model.
#'
#' @details Users can choose between passing locally stored parameters to the
#' `params_` argument, as in the first example (below), or remote data by
#' passing the URL or Application Programming Interface (API) address, path and
#' any required credentials to the `source_url_`, `source_path_`, and
#' `source_credentials_` arguments. When required, this function calls the
#' \code{\link{get_model_params_}} function to retrieve remote data.
#' See the examples section for a demo code.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#'
#' ## Locally stored data:
#' sickSicker_model_results <- run_sickSicker_model(
#'   params_ = dummy_sickSickerModel_params
#' )
#'
#' ## Remotely stored data:
#' sickSicker_model_results <- run_sickSicker_model(
#'  source_url_ = "https://sicksickerpack-v7po7ubcwa-nw.a.run.app",
#'  source_path_ = "modelRunParams",
#'  source_credentials_ = "R-HTA_2023"
#' )
#' }
run_sickSicker_model <- function(
    params_ = NULL,
    source_url_ = NULL,
    source_path_ = NULL,
    source_credentials_ = NULL
) {
  ## Sanity checks - inputs:

  if(all(is.null(params_),
         !is.null(source_url_),
         !is.null(source_path_),
         !is.null(source_credentials_))) {
    # ensure that user supplied remote information are strings
    for (x in c("source_url_", "source_path_", "source_credentials_")) {
      assertthat::assert_that(
        assertthat::is.string(get(x)),
        msg = paste(
          "The object passed to the", x, "argument is not of class string"
        )
      )
    }
  } else if (all(!is.null(params_),
                 is.null(source_url_),
                 is.null(source_path_),
                 is.null(source_credentials_))) {
    # confirm params_ is a list
    assertthat::assert_that(
      is.list(params_),
      msg = paste(
        "The object passed to the params_ argument is not a list"
      )
    )
  } else {
    assertthat::assert_that(
      FALSE,
      msg = paste(
        "Conflicting arguments detected! Please either pass locally stored",
        "data to the 'params_' argument or remote server/API information to",
        "the 'source_url_', 'source_path_', and 'source_credentials_'",
        "arguments to retrieve remotely stored data. Passing arguments in any",
        "other configuration is prohibited."
      )
    )
  }

  ## Grab model parameters if not passed to the function:

  params <- if(is.null(params_)) {
    temp_params <- get_model_params_(
      source_url_ = source_url_,
      source_path_ = source_path_,
      source_credentials_ = source_credentials_)

    # confirm temp_params is a list
    assertthat::assert_that(
      is.list(temp_params),
      msg = paste(
        "The objects retrieved from the remote server/API is not a list"
      )
    )

    temp_params
  } else {
    params_
  }

  ## Run the model using the objects in the params list:

  with(
    data = params,
    expr = {
      ## Calculate interim parameters:

      # strategy names
      Strategies = c("No Treatment", "Treatment")

      # time horizon, number of cycles
      n_t = age_max_ - age_init_
      # the 4 states of the model: Healthy (H), Sick (S1), Sicker (S2), Dead (D)
      v_n  <- c("H", "S1", "S2", "D")

      # rate of death in healthy
      r_HD    <- - log(1 - p_HD)
      # rate of death in sick
      r_S1D   <- hr_S1 * r_HD
      # rate of death in sicker
      r_S2D   <- hr_S2 * r_HD

      # probability of death in sick
      p_S1D   <- 1 - exp(-r_S1D)
      # probability of death in sicker
      p_S2D   <- 1 - exp(-r_S2D)

      # initial Markov trace
      initial_trace <- c("H" = 1, "S1" = 0, "S2" = 0, "D" = 0)

      # create vectors for the costs and utility of each treatment group
      c_trt    <- c("H" = c_H, "S1" = c_S1 + c_Trt, "S2" = c_S2 + c_Trt, "D" = c_D)
      c_no_trt <- c("H" = c_H, "S1" = c_S1, "S2" = c_S2, "D" = c_D)
      u_trt    <- c("H" = u_H, "S1" = u_Trt, "S2" = u_S2, "D" = u_D)
      u_no_trt <- c("H" = u_H, "S1" = u_S1, "S2" = u_S2, "D" = u_D)

      ## Calculate the discount weight for each cycle:

      v_dw <- calculate_discounting_weights(
        discount_rate_ = discount_rate_,
        time_horizon_ = n_t,
        first_cycle_ = TRUE)

      ## Define the model's transition matirix:

      m_P <- define_transition_matrix(
        states_nms_ = v_n,
        transition_probs_ = c(
          1 - (p_HS1 + p_HD),                        p_HS1,         0,  p_HD,
          p_S1H,              1 - (p_S1H + p_S1S2 + p_S1D),    p_S1S2, p_S1D,
          0,                                             0, 1 - p_S2D, p_S2D,
          0,                                             0,         0,     1
        )
      )

      ## Create the model's Markov trace:

      m_TR <- create_Markov_trace(
        transition_matrix_ = m_P,
        time_horizon_ = n_t,
        states_nms_ = v_n,
        initial_trace_ = initial_trace
      )

      ## Calculate costs:

      v_C_no_trt <- calculate_costs(
        Markov_trace_ = m_TR,
        costs_ = c_no_trt,
        discounting_weights_ = v_dw
      )
      v_C_trt <- calculate_costs(
        Markov_trace_ = m_TR,
        costs_ = c_trt,
        discounting_weights_ = v_dw
      )
      tc_no_trt  <- sum(v_C_no_trt)
      tc_trt     <- sum(v_C_trt)

      ## Calculate QALYs:

      v_E_no_trt <- calculate_QALYs(
        Markov_trace_ = m_TR,
        utilities_ = u_no_trt,
        discounting_weights_ = v_dw
      )
      v_E_trt <- calculate_QALYs(
        Markov_trace_ = m_TR,
        utilities_ = u_trt,
        discounting_weights_ = v_dw
      )
      te_no_trt <- sum(v_E_no_trt)
      te_trt    <- sum(v_E_trt)

      ## Prepare results:
      results <- c(
        "Cost_no_treatment"  = tc_no_trt ,
        "Cost_treatment"     = tc_trt ,
        "QALYs_no_treatment" = te_no_trt,
        "QALYs_treatment"    = te_trt
      )

      return(results)
    }
  )
}
