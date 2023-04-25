test_that(desc = "sickSicker model simulated correctly", {
  ## Define expected outputs:
  expected_output <- c("Cost - no treatment" = 11318.999306,
                       "Cost - treatment" = 19886.585405,
                       "QALYs - no treatment" = 4.260124,
                       "QALYs - treatment" = 4.385285,
                       "ICER" = 68452.446476)

  ## Define outputs:
  output <- run_sickSicker_model(
    age_init_ = 25,
    age_max_ = 30
  )

  ## Run test:
  expect_equal(
    expected_output,
    output,
    tolerance = 0.00001
  )
})
