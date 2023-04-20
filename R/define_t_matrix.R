#' Define the transition matrix
#'
#' @description Define the transition matrix of the Sick-Sicker State-Transition
#' Model (SS-STM).
#'
#' @param p_HD Numeric, probability to die when healthy.
#' @param p_HS1 Numeric, probability to become sick when healthy.
#' @param p_S1H Numeric, probability to become healthy when sick.
#' @param p_S1S2 Numeric, probability to become sicker when sick.
#' @param hr_S1 Numeric, hazard ratio of death in sick vs healthy.
#' @param hr_S2 Numeric, hazard ratio of death in sicker vs healthy.
#'
#' @return A 4x4 matrix containing the transition probabilities between the Sick
#' -Sicker states.
#' @export
#'
#' @examples
#' \dontrun{
#' library("sicksickerPack")
#' define_t_matrix()
#' }
define_t_matrix <- function(p_HD = 0.005,
                            p_HS1 = 0.15,
                            p_S1H = 0.5,
                            p_S1S2 = 0.105,
                            hr_S1 = 3,
                            hr_S2 = 10) {
  ## Inputs' sanity checks:
  if(any(c(p_HD, p_HS1, p_S1H, p_S1S2) <= 0,
         c(p_HD, p_HS1, p_S1H, p_S1S2) >= 1)) {
    messages <- purrr::map2_chr(
      .x = c("p_HD", "p_HS1", "p_S1H", "p_S1S2"),
      .y = c(p_HD, p_HS1, p_S1H, p_S1S2),
      .f = function(.x, .y) {
        if(.y <= 0 | .y >= 1) {
          paste0("Acceptable values for ", .x, " should be between 0 and 1.")
        } else {
          NA
        }
      }
    )

    messages <- messages[!is.na(messages)]

    rlang::abort(message = messages)
  }

  ## Calculate transition probabilities:

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

  ## Construct transition matrix:

  # model health states
  v_n  <- c("H", "S1", "S2", "D")
  # number of health states
  n_states <- length(v_n)
  # transition probability matrix for NO treatment
  m_P <- matrix(data = NA,
                nrow = n_states,
                ncol = n_states,
                dimnames = list(v_n, v_n))
  # transitions from Healthy
  m_P["H", ]  <- c(1 - (p_HS1 + p_HD), p_HS1, 0, p_HD)
  # transitions from Sick
  m_P["S1", ]  <- c(p_S1H, 1 - (p_S1H + p_S1S2 + p_S1D), p_S1S2, p_S1D)
  # transitions from Sicker
  m_P["S2", ]   <- c(0, 0, 1 - p_S2D, p_S2D)
  # transitions from Dead
  m_P["D", ] <- c(0, 0, 0, 1)

  ## Sanity checks:

  # check rows add up to 1
  if(any(rowSums(m_P) != 1)) {
    rlang::abort(
      message = "Probabilities do not add up to 1 in the transition matrix."
    )
  }

  return(m_P)
}
