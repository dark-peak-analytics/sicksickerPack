#' Dummy data to run the Sick-Sicker model
#'
#' A dataframe containing dummy data to help package users to test the
#' run_sickSicker_model function which executes the Sick-Sicker state-transition
#' model.
#'
#' @format ## `dummy_sickSickerModel_params`
#' A dataframe with 1 row and 19 columns:
#' \describe{
#'   \item{age_init_}{Age at baseline}
#'   \item{age_max_}{Maximum age of follow up}
#'   \item{discount_rate_}{Discount rate for costs and QALYs}
#'   \item{p_HD}{Probability to die when healthy}
#'   \item{p_HS1}{Probability to become sick when healthy}
#'   \item{p_S1H}{Probability to become healthy when sick}
#'   \item{p_S1S2}{Probability to become sicker when sick}
#'   \item{hr_S1}{Hazard ratio of death in sick v healthy}
#'   \item{hr_S2}{Hazard ratio of death in sicker v healthy}
#'   \item{c_H}{Cost of remaining one cycle in the healthy state}
#'   \item{c_S1}{Cost of remaining one cycle in the sick state}
#'   \item{c_S2}{Cost of remaining one cycle in the sicker state}
#'   \item{c_Trt}{Cost of treatment(per cycle)}
#'   \item{c_D}{Cost of being in the death state}
#'   \item{u_H}{Utility when healthy}
#'   \item{u_S1}{Utility when sick}
#'   \item{u_S2}{Utility when sicker}
#'   \item{u_D}{Utility when dead}
#'   \item{u_Trt}{Utility when being treated}
#' }
"dummy_sickSickerModel_params"
