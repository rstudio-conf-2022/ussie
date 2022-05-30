test_that("uss_get_matches works", {

  # is there an opportunity here for rlang::match_arg
  # to return a more-specific class?
  expect_error(uss_get_matches("tatooine"), class = "rlang_error")

  ## initial tests: start
  italy <- uss_get_matches("italy")
  expect_identical(italy, uss_make_matches(engsoccerdata::italy, "Italy"))
  ## initial tests: end

})
