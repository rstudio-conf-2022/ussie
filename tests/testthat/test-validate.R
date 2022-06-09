test_that("validate_data_frame works", {
  
  # ## 2.2.2 side effects (global state)
  # ## add helper function to warn on partial matches
  # ## - https://testthat.r-lib.org/articles/test-fixtures.html
  local_warn_partial_match()
  
  # ## 2.2.1 side effects (errors)
  # ## test the `class` of the error, return error-condition object
  # ##  - https://testthat.r-lib.org/reference/expect_error.html
  error_condition <- expect_error(validate_data_frame(3), class = "ussie_error_data")
  
  # ## 2.2.1 side effects (errors)
  # ## test the parts of error-condition object that you supply
  expect_identical(error_condition$class_data, "numeric")
  
  # ## 2.2.1 side effects (errors)
  # ## test the error-message using a snapshot
  # ##  - https://testthat.r-lib.org/reference/expect_snapshot.html
  # ##  - example output: https://github.com/ijlyttle/ussie/blob/main/tests/testthat/_snaps/validate.md
  expect_snapshot_error(validate_data_frame(3))
  
  # ## 2.2.1 side effects (errors)
  # ## test the return object
  # ##  - https://testthat.r-lib.org/reference/expect_invisible.html
  out <- expect_invisible(validate_data_frame(mtcars))
  expect_identical(out, mtcars)
  
})

test_that("validate_cols works", {
  
  # ## 2.2.2 side effects (global state)
  # ## add helper function to warn on partial matches
  local_warn_partial_match()
  
  # ## 2.2.1 side effects (errors)
  # ## test the `class` of the error, return error-condition object 
  error_condition <- expect_error(
    validate_cols(mtcars, "foo"),
    class = "ussie_error_cols"
  )
  
  # ## 2.2.1 side effects (errors)
  # ## test the parts of error-condition object that you supply
  expect_identical(error_condition$cols_req, "foo")
  expect_identical(error_condition$cols_data, names(mtcars))
 
  # ## 2.2.1 side effects (errors)
  # ## test the error-message using a snapshot
  expect_snapshot_error(validate_cols(mtcars, "foo"))
  
  # ## 2.2.1 side effects (errors)
  # ## add test for the return object
  out <- expect_invisible(validate_cols(mtcars, "mpg"))
  expect_identical(out, mtcars)
})

