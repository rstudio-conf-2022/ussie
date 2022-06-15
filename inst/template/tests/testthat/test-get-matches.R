test_that("uss_get_matches works", {
  
  # ## 2.2.1 side effects (errors)
  # ## validate the country argument
  # expect_error(uss_get_matches("tatooine"), class = "rlang_error")
  
  # ## 2.1.2 design (create new function)
  italy <- uss_get_matches("italy")
  expect_identical(italy, uss_make_matches(engsoccerdata::italy, "Italy"))
  
  # ## 2.3.1 tidy eval (pass the dots)
  # ## make sure the dots work as a filter
  # expect_identical(
  #   uss_get_matches("italy", season == 1934),
  #   italy |> dplyr::filter(season == 1934)
  # )

})