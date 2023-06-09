% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/define_transition_matrix.R
\name{define_transition_matrix}
\alias{define_transition_matrix}
\title{Define a transition matrix}
\usage{
define_transition_matrix(states_nms_, transition_probs_)
}
\arguments{
\item{states_nms_}{A character vector containing the names of the states of a
Markov model.}

\item{transition_probs_}{A numeric vector containing the transition
probabilities of length \verb{n x n}, where \code{n} is the length of, number of names
in, the \code{states_nms_} vector.}
}
\value{
An \verb{n x n}, where \code{n} is the number of states in an STM model,
containing the transition probabilities between the model states.
}
\description{
Define the transition matrix of a State-Transition Markov (STM)
Model.
}
\examples{
\dontrun{
library("sicksickerPack")
define_transition_matrix(
  states_nms_ = c("A", "B"),
  transition_probs_ = c(
    0.2, 0.8, # transitions from state A -> A and A -> B
    0,     1  # transitions from state B -> A and B -> B
  )
 )
}
}
