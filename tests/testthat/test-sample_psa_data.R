test_that(desc = "probabilistic sensitivity analysis function works", {
  ## Define expected outputs:
  expected_output <- data.frame(
    "param1" = c(1.874709, 2.036729, 1.832874, 2.319056, 2.065902),
    "param2" = c(0.3162139, 0.4421562, 0.4685036, 0.3648771, 0.5598779)
  )

  ## Define outputs:
  set.seed(1)
  output <- sample_psa_data(
    psa_params_names_ = c("param1", "param2"),
    psa_params_dists_ = c("norm", "beta"),
    psa_params_dists_args_ = list(
      "param1" = list("mean" = 2, "sd" = 0.2),
      "param2" = list("shape1" = 13, "shape2" = 20)
    ),
    n_sim_ = 5
  )

  ## Run tests:
  expect_equal(
    expected_output,
    output,
    tolerance = 0.00001
  )
  expect_type(
    object = output,
    type = "list")
})
