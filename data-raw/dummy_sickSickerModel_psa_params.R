## code to prepare `dummy_sickSickerModel_psa_params` dataset goes here

dummy_sickSickerModel_psa_params <- list(
  "psa_params_names" = c(
    "p_HS1", "p_S1H", "p_S1S2", "p_HD", "hr_S1", "hr_S2", "c_H", "c_S1", "c_S2",
    "c_D", "c_Trt", "u_H", "u_S1", "u_S2", "u_D", "u_Trt"
  ),
  "psa_params_dists" = c(
    "p_HS1" = "beta", "p_S1H" = "beta", "p_S1S2" = "beta", "p_HD" = "beta",
    "hr_S1" = "lnorm", "hr_S2" = "lnorm", "c_H" = "gamma", "c_S1" = "gamma",
    "c_S2" = "gamma", "c_D" = "fixed", "c_Trt" = "fixed", "u_H" = "truncnorm",
    "u_S1" = "truncnorm", "u_S2" = "truncnorm", "u_D" = "fixed",
    "u_Trt" = "truncnorm"
  ),
  "psa_params_dists_args" = list(
    "p_HS1" = list(
      shape1 = 30,
      shape2 = 170
    ),
    "p_S1H" = list(
      shape1 = 60,
      shape2 = 60
    ),
    "p_S1S2" = list(
      shape1 = 84,
      shape2 = 716
    ),
    "p_HD" = list(
      shape1 = 10,
      shape2 = 1990
    ),
    "hr_S1" = list(
      meanlog = log(3),
      sdlog = 0.01
    ),
    "hr_S2" = list(
      meanlog = log(10),
      sdlog = 0.02
    ),
    "c_H" = list(
      shape = 100,
      scale = 20
    ),
    "c_S1" = list(
      shape = 177.8,
      scale = 22.5
    ),
    "c_S2" = list(
      shape = 225,
      scale = 66.7
    ),
    "c_D" = list(0),
    "c_Trt" = list(60000),
    "u_H" = list(
      mean = 1,
      sd = 0.01,
      b = 1
    ),
    "u_S1" = list(
      mean = 0.75,
      sd = 0.02,
      b = 1
    ),
    "u_S2" = list(
      mean = 0.50,
      sd = 0.03,
      b = 1
    ),
    "u_D" = list(0),
    "u_Trt" = list(
      mean = 0.95,
      sd = 0.02,
      b = 1
    )
  )
)

usethis::use_data(dummy_sickSickerModel_psa_params, overwrite = TRUE)
