test_that("uss_make_teams_matches works", {
  
  # use helper function to warn on partial matches
  local_warn_partial_match()
  
  # we have tested the behaviors of the validators elsewhere,
  # here, we're just making sure the *right* error got thrown
  expect_error(uss_make_teams_matches(3), class = "ussie_error_data")
  expect_error(uss_make_teams_matches(mtcars), class = "ussie_error_cols")
  
  italy <- uss_get_matches("italy") |> uss_make_teams_matches()
  
  expect_true(tibble::is_tibble(italy))
  expect_named(italy, cols_teams_matches())
  
  # not comprehensive, but may give us a indication if something changes
  expect_snapshot(dplyr::glimpse(italy))
  
})