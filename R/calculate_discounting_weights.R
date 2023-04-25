#' Calculate discounting weights
#'
#' @description Calculate the discounting weights that correspond to a defined
#' model time-horizon. Discounting could be employed starting from the initial
#' cycle.
#'
#' @param discount_rate_ Numeric, the rate used to estimate the discounting
#' weights.
#' @param time_horizon_ Numeric, time horizon, number of cycles for which the
#' discounting weights are to be calculated.
#' @param first_cycle_ Logical, for whether to start discounting from the first
#' cycle. Default is FALSE, where the discounting weight corresponding to the
#' first cycle is equal to one.
#'
#' @return A numeric vector containing the discounting weights for
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' calculate_discounting_weights(
#'   discount_rate = 0.035,
#'   time_horizon = 1,
#'   first_cycle = FALSE
#' )
#' }
calculate_discounting_weights <- function(discount_rate = 0.035,
                                          time_horizon,
                                          first_cycle = FALSE) {
  ## Sanity checks:

  if(discount_rate < 0) {
    rlang::abort(message = "The discount rate can not be less than zero")
  }

  ## Calculate discount weights:

  v_dw <- if(!first_cycle) {
    1 / (1 + discount_rate) ^ (0:(time_horizon - 1))
  } else {
    1 / (1 + discount_rate) ^ (1:(time_horizon))
  }

  return(v_dw)
}
