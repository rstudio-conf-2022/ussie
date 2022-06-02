test_that("uss_get_matches works", {
  
  # ## 2.2 side effects
  # ## validate the country argument
  # expect_error(uss_get_matches("tatooine"), class = "rlang_error")
  
  italy <- uss_get_matches("italy")
  expect_identical(italy, uss_make_matches(engsoccerdata::italy, "Italy"))
  
  # ## 2.3 tidy eval 
  # ## make sure the dots work as a filter
  # expect_identical(
  #   uss_get_matches("italy", season == 1934),
  #   italy |> dplyr::filter(season == 1934)
  # )

})