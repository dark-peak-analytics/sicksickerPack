## code to prepare `dummy_sickSickerModel_params` dataset goes here

dummy_sickSickerModel_params <- data.frame(
  age_init_ = 25,
  age_max_  = 55,
  discount_rate_ = 0.035,
  p_HD    = 0.005,
  p_HS1   = 0.15,
  p_S1H   = 0.5,
  p_S1S2  = 0.105,
  hr_S1   = 3,
  hr_S2   = 10,
  c_H     = 2000,
  c_S1    = 4000,
  c_S2    = 15000,
  c_Trt   = 60000,
  c_D     = 0,
  u_H     = 1,
  u_S1    = 0.75,
  u_S2    = 0.5,
  u_D     = 0,
  u_Trt   = 0.95
)

usethis::use_data(dummy_sickSickerModel_params, overwrite = TRUE)
