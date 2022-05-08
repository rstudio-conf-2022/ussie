test_that("uss_make_matches works", {

  # use helper function to warn on partial matches
  local_warn_partial_match()

  # we have tested the behaviors of the validators elsewhere,
  # here, we're just making sure the *right* error got thrown
  expect_error(uss_make_matches(3, "foo"), class = "ussie_error_data")
  expect_error(uss_make_matches(mtcars, "foo"), class = "ussie_error_cols")

  italy <- uss_make_matches(engsoccerdata::italy, "Italy")

  expect_true(tibble::is_tibble(italy))
  expect_named(italy, cols_matches())
  expect_identical(unique(italy$country), "Italy")

})

test_that("uss_get_matches works", {

  # use helper function to warn on partial matches
  local_warn_partial_match()

  # is there an opportunity here for rlang::match_arg
  # to return a more-specific class?
  expect_error(uss_get_matches("tatooine"), class = "rlang_error")

  italy <- uss_get_matches("italy")
  expect_identical(italy, uss_make_matches(engsoccerdata::italy, "Italy"))

})

