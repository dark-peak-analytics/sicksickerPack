test_that(desc = "sickSicker model simulated correctly", {
  ## Define expected outputs:
  expected_output <- c("Cost_no_treatment" = 11318.999306,
                       "Cost_treatment" = 19886.585405,
                       "QALYs_no_treatment" = 4.260124,
                       "QALYs_treatment" = 4.385285)

  ## Define outputs:
  output <- run_sickSicker_model(
    age_init_ = 25,
    age_max_ = 30
  )

  ## Run tests:
  expect_equal(
    expected_output,
    output,
    tolerance = 0.00001
  )
  expect_vector(
    object = run_sickSicker_model(),
    ptype = numeric(),
    size = 4
  )
})
