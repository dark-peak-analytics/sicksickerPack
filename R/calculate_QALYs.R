#' Calculate QALYs
#'
#' @description Calculate the QALYs associated with certain states in a Markov
#' model.
#'
#' @param Markov_trace_ Numeric matrix representing the Markov trace of the
#' model.
#' @param utilities_ Numeric vector defining the utilities associated with each
#' state in a Markov model.
#' @param discounting_weights_ Numeric vector containing the discounting weights
#' associated with each cycle.
#'
#' @return A numeric vector containing the QALYs accrued over a Markov model
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
#'   nrow = 5,
#'   byrow = TRUE,
#'   dimnames = list(1:5,
#'                  c("H", "S1", "S2", "D"))
#'  )
#' )
#' discounted_QALYs <- calculate_QALYs(
#'   Markov_trace_ = Markov_trace,
#'   utilities_ = c("u_H" = 1, "u_S1" = 0.75, "u_S2" = 0.5, "u_D" = 0),
#'   discounting_weights_ = c(0.9661836, 0.9335107, 0.901942, 0.871442, 0.841973)
#' )
#' }
calculate_QALYs <- function(Markov_trace_,
                            utilities_,
                            discounting_weights_) {

  QALYs <- Markov_trace_ %*% utilities_
  discounted_QALYs <- QALYs * discounting_weights_

  return(discounted_QALYs)
}
