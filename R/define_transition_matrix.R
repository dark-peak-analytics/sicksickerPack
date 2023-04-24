#' Define a transition matrix
#'
#' @description Define the transition matrix of a State-Transition Markov (STM)
#' Model.
#'
#' @param states_nms_ A character vector containing the names of the states of a
#' Markov model.
#' @param tranistion_probs_ A numeric vector containing the transition
#' probabilities of length \code{n x n}, where \code{n} is the length of, number
#' of names in, the \code{states_nms_} vector.
#'
#' @return An \code{n x n}, where \code{n} is the number of states in an STM
#' model, containing the transition probabilities between the model states.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' define_transition_matrix(
#'   states_nms_ = c("A", "B"),
#'   tranistion_probs_ = c(
#'     0.2, 0.8, # transitions from state A -> A and A -> B
#'     0,     1  # transitions from state B -> A and B -> B
#'   )
#'  )
#' }
define_transition_matrix <- function(states_nms_,
                                     tranistion_probs_) {
  ## Sanity testing - inputs:

  # confirm names vector is of class character, n = length(states_nms_)
  if(class(states_nms_) != "character") {
    console_message <- paste0(
      "The \"states_nms_\" argument expects a character vector containing the ",
      "names of the markov states."
    )

    rlang::abort(message = console_message)
  }
  # confirm transition probabilities vector is of class numeric
  if(class(tranistion_probs_) != "numeric") {
    console_message <- paste0(
      "The \"tranistion_probs_\" argument expects a numeric vector containing the ",
      "transition probabilities between the model states."
    )

    rlang::abort(message = console_message)
  } else {
    if(any(tranistion_probs_ < 0, tranistion_probs_ > 1)) {
      console_message <- paste0("Transition probabilities should be between 0 and 1.")

      rlang::abort(message = console_message)
    }
  }
  # confirm transition probabilities vector is, n = sqrt(tranistion_probs_)
  if(length(states_nms_) != sqrt(length(tranistion_probs_))) {
    console_message <- paste0(
      "Please pass ",
      length(tranistion_probs_),
      " probabilties for the transition between the ",
      length(states_nms_),
      " markov states."
    )

    rlang::abort(message = console_message)
  }

  ## Construct the transition probabilities' matrix:

  # fill matrix with transition probabilities
  tranistion_matrix <- matrix(
    data = tranistion_probs_,
    nrow = length(states_nms_),
    ncol = length(states_nms_),
    byrow = TRUE,
    dimnames = list(
      states_nms_,
      states_nms_
    )
  )

  ## Sanity testing - outputs:

  # check rows add up to 1
  if(any(round(rowSums(tranistion_matrix), digits = 5) != 1)) {
    console_message <- paste0(
      "Transition probabilities from one or more states do not add up to 1."
    )

    rlang::abort(message = console_message)
  }

  return(tranistion_matrix)
}
