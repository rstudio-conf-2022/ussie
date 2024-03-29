test_that("uss_make_matches works", {

  # use helper function to warn on partial matches
  local_warn_partial_match()

  # we have tested the behaviors of the validators elsewhere,
  # here, we're just making sure the *right* error got thrown
  expect_error(uss_make_matches(3, "foo"), class = "ussie_error_data")
  expect_error(uss_make_matches(mtcars, "foo"), class = "ussie_error_cols")

  ## initial tests: start
  italy <- uss_make_matches(engsoccerdata::italy, "Italy")

  expect_true(tibble::is_tibble(italy))
  expect_named(italy, cols_matches())
  expect_identical(unique(italy$country), "Italy")
  ## initial tests: end

  expect_snapshot(dplyr::glimpse(italy))

})


