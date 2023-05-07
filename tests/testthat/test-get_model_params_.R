test_that(desc = "model data retrieval function is working correctly", {
  ## Run tests:
  expect_error(
    get_model_params_(
      source_url_ = "http://127.0.0.1:808089646",
      source_path_ = "/psaRunParams",
      source_credentials_ = "R-HTA_2023"
    )
  )
})
