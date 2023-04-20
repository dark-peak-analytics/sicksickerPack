#' Calculate discounting weights
#'
#' @param d_r Numeric, the rate used to estimate the discounting weights.
#' @param n_t Numeric, time horizon, number of cycles for which the discounting
#' weights are to be calculated.
#' @param first Logical, for whether to start discounting from the first cycle.
#' Default is FALSE, where the discounting weight corresponding to the first
#' cycle is equal to one.
#'
#' @return A numeric vector containing the discounting weights for
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' }
calculate_discounting_weights <- function(d_r = 0.035,
                                          n_t,
                                          first = FALSE) {
  ## Sanity checks:

  if(d_r < 0) {
    rlang::abort(message = "The discount rate \"dr\" can not be less than zero")
  }

  ## Calculate discount weights:

  v_dw <- if(!first) {
    1 / (1 + d_r) ^ (0:(n_t-1))
  } else {
    1 / (1 + d_r) ^ (1:(n_t))
  }

  return(v_dw)
}
