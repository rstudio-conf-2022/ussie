test_that("uss_make_matches works", {
  
  local_warn_partial_match()
  
  # we have tested the behaviors of the validators elsewhere,
  # here, we're just making sure the *right* error got thrown
  expect_error(uss_make_matches(3, "foo"), class = "ussie_error_data")
  expect_error(uss_make_matches(mtcars, "foo"), class = "ussie_error_cols")
  
  italy <- uss_make_matches(engsoccerdata::italy, "Italy")
  
  expect_true(tibble::is_tibble(italy))
  expect_named(italy, cols_matches())
  expect_identical(unique(italy$country), "Italy")

  expect_s3_class(italy$tier, "factor")
  
  # not as robust as a full "identical" comparison
  #  - still useful for column names, types, values for first few rows
  expect_snapshot(dplyr::glimpse(italy))
})