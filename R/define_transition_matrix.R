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
  assertthat::assert_that(
    is.vector(x = states_nms_, mode = "character"),
    msg = paste(
      "The states_nms_ argument is not of class character"
    )
  )
  # confirm transition probabilities vector is of class numeric
  assertthat::assert_that(
    is.vector(x = tranistion_probs_, mode = "numeric"),
    msg = paste(
      "The tranistion_probs_ argument is not of class numeric"
    )
  )
  # ensure all transition probabilities are between 0 and 1
  assertthat::assert_that(
    all(tranistion_probs_ >= 0, tranistion_probs_ <= 1),
    msg = paste(
      "One or more of the values passed to the tranistion_probs_ argument are",
      "not between 0 and 1."
    )
  )
  # confirm transition probabilities vector is, n = sqrt(tranistion_probs_)
  assertthat::assert_that(
    length(states_nms_) == sqrt(length(tranistion_probs_)),
    msg = paste(
      "Please pass",
      length(tranistion_probs_),
      "probabilties for the transition between the",
      length(states_nms_),
      "markov states."
    )
  )

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

  # check tranistion_matrix rows add up to 1
  assertthat::assert_that(
    all(round(rowSums(tranistion_matrix), digits = 5) == 1),
    msg = "Transition probabilities from one or more states do not add up to 1."
  )

  return(tranistion_matrix)
}
