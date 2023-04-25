#' Calculate costs
#'
#' @description Calculate the costs associated with certain states in a Markov
#' model.
#'
#' @param Markov_trace_ Numeric matrix representing the Markov trace of the
#' model.
#' @param costs_ Numeric vector defining the costs associated with each state in
#' a Markov model.
#' @param discounting_weights_ Numeric vector containing the discounting weights
#' associated with each cycle.
#'
#' @return A numeric vector containing the costs incurred over a Markov model
#' time horizon, for each state.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' Markov_trace <- matrix(
#'   data = c(1, 0, 0, 0,
#'            0.845, 0.15, 0, 0.005,
#'            0.789025, 0.1837612, 0.01575, 0.01146377,
#'            0.7586067, 0.1881968, 0.03427491, 0.01892157,
#'            0.7351211, 0.1853199, 0.05235988, 0.02719916),
#'  nrow = 5,
#'  byrow = TRUE,
#'  dimnames = list(1:5,
#'                  c("H", "S1", "S2", "D"))
#' )
#' discounted_costs <- calculate_costs(
#'   Markov_trace_ = Markov_trace,
#'   costs_ = c("c_H" = 2000, "c_S1" = 4000, "c_S2" = 15000, "c_Trt" = 12000),
#'   discounting_weights_ = c(0.9661836, 0.9335107, 0.901942, 0.871442, 0.841973)
#' )
#' }
calculate_costs <- function(Markov_trace_,
                            costs_,
                            discounting_weights_) {

  costs <- Markov_trace_ %*% costs_
  discounted_costs <- costs * discounting_weights_

  return(discounted_costs)
}
