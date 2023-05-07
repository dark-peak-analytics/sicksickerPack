#' Dummy data to perform probabilistic sensitivity analysis for the Sick-Sicker
#' model
#'
#' A list of lists containing dummy data to help package users to test the
#' run_psa function on the Sick-Sicker model, defined by the
#' run_sickSicker_model function.
#'
#' @format ## `dummy_sickSickerModel_psa_params`
#' A list with 1 row and 19 columns:
#' \describe{
#'   \item{psa_params_names}{Names of the parameters for which PSA
#'   configurations will be sampled}
#'   \item{psa_params_dists}{Names of the distributions of each of the
#'   corresponding PSA parameters named in \code{psa_params_names_}}
#'   \item{psa_params_dists_args}{List of arguments (named lists) to be passed
#'   to the corresponding PSA distributions named in \code{psa_params_dists_}
#'   argument.}
#'   \itemize{
#'    \item{p_HD: }{Probability to die when healthy}
#'      \itemize{
#'        \item{shape1: }{Beta distribution (\code{rbeta()}) parameter}
#'        \item{shape2: }{Beta distribution (\code{rbeta()}) parameter}
#'      }
#'    \item{p_HS1: }{Probability to become sick when healthy}
#'      \itemize{
#'        \item{shape1: }{Beta distribution (\code{rbeta()}) parameter}
#'        \item{shape2: }{Beta distribution (\code{rbeta()}) parameter}
#'      }
#'    \item{p_S1H: }{Probability to become healthy when sick}
#'      \itemize{
#'        \item{shape1: }{Beta distribution (\code{rbeta()}) parameter}
#'        \item{shape2: }{Beta distribution (\code{rbeta()}) parameter}
#'      }
#'    \item{p_S1S2: }{Probability to become sicker when sick}
#'      \itemize{
#'        \item{shape1: }{Beta distribution (\code{rbeta()}) parameter}
#'        \item{shape2: }{Beta distribution (\code{rbeta()}) parameter}
#'      }
#'    \item{hr_S1}{ Hazard ratio of death in sick v healthy}
#'      \itemize{
#'        \item{meanlog: }{Log-normal distribution (\code{rlnorm()}) parameter}
#'        \item{sdlog: }{Log-normal distribution (\code{rlnorm()}) parameter}
#'      }
#'    \item{hr_S2: }{Hazard ratio of death in sicker v healthy}
#'      \itemize{
#'        \item{meanlog: }{Log-normal distribution (\code{rlnorm()}) parameter}
#'        \item{sdlog: }{Log-normal distribution (\code{rlnorm()}) parameter}
#'      }
#'    \item{c_H: }{Cost of remaining one cycle in the healthy state}
#'      \itemize{
#'        \item{shape: }{Gamma distribution (\code{rgamma()}) parameter}
#'        \item{scale: }{Gamma distribution (\code{rgamma()}) parameter}
#'      }
#'    \item{c_S1: }{Cost of remaining one cycle in the sick state}
#'      \itemize{
#'        \item{shape: }{Gamma distribution (\code{rgamma()}) parameter}
#'        \item{scale: }{Gamma distribution (\code{rgamma()}) parameter}
#'      }
#'    \item{c_S2: }{Cost of remaining one cycle in the sicker state}
#'      \itemize{
#'        \item{shape: }{Gamma distribution (\code{rgamma()}) parameter}
#'        \item{scale: }{Gamma distribution (\code{rgamma()}) parameter}
#'      }
#'    \item{c_Trt: }{Cost of treatment(per cycle)}
#'    \item{c_D: }{Cost of being in the death state}
#'    \item{u_H: }{Utility when healthy}
#'      \itemize{
#'        \item{mean: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{sd: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{b: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'      }
#'    \item{u_S1: }{Utility when sick}
#'      \itemize{
#'        \item{mean: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{sd: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{b}: {Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'      }
#'    \item{u_S2: }{Utility when sicker}
#'      \itemize{
#'        \item{mean: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{sd: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{b: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'      }
#'    \item{u_D: }{Utility when dead}
#'    \item{u_Trt: }{Utility when being treated}
#'      \itemize{
#'        \item{mean: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{sd: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'        \item{b: }{Truncated Normal distribution (\code{rtruncnorm()})
#'        parameter}
#'      }
#'   }
#' }
"dummy_sickSickerModel_psa_params"
