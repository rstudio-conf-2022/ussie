test_that("uss_make_matches works", {
  
  local_warn_partial_match()
  
  italy <- uss_make_matches(engsoccerdata::italy, "Italy")
  
  expect_true(tibble::is_tibble(italy))
  expect_named(italy, cols_matches())
  expect_identical(unique(italy$country), "Italy")

  expect_s3_class(italy$tier, "factor")
})