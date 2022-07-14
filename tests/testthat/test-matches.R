test_that("uss_make_matches works", {
  
  italy <- uss_make_matches(engsoccerdata::italy, "Italy")
  
  expect_true(tibble::is_tibble(italy))
  expect_named(italy, cols_matches())
  expect_identical(unique(italy$country), "Italy")

  expect_s3_class(italy$tier, "factor")
})