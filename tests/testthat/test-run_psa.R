test_that(desc = "probabilistic sensitivity analysis function works", {
  ## Run tests:
  expect_error(
    res <- run_psa(
      model_func_ = "run_sickSicker_model",
      model_func_args_ = list(
        age_init_ = 25,
        age_max_  = 55,
        discount_rate_ = 0.035
      ),
      psa_params_names_ = NULL,
      psa_params_dists_ = NULL,
      psa_params_dists_args_ = NULL,
      n_sim_ = 10,
      source_url_ = "http://127.0.0.1:80803463545654",
      source_path_ = "/psaRunParams",
      source_credentials_ = "R-HTA_2023"
    )
  )
})
