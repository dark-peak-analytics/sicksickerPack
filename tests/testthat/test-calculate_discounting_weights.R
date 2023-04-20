test_that(desc = "discounting weights calculated correctly", {
  ## Define expected outputs:
  expected_output1 <- 1
  expected_output2 <- c(1, 0.9661836)
  expected_output3 <- 0.9661836

  ## Define outputs:
  output1 <- calculate_discounting_weights(n_t = 1)
  output2 <- calculate_discounting_weights(n_t = 2)
  output3 <- calculate_discounting_weights(n_t = 1,
                                           first = TRUE)

  ## Run tests:
  expect_equal(expected_output1, output1, tolerance = 0.00001)
  expect_equal(expected_output2, output2, tolerance = 0.00001)
  expect_equal(expected_output3, output3, tolerance = 0.00001)
  expect_error(calculate_discounting_weights(d_r = -0.1, n_t = 1))
})
