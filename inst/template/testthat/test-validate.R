test_that("validate_data_frame works", {
  
  # ## 2.2.2 side effects (global state)
  # ## add helper function to warn on partial matches
  # ## - https://testthat.r-lib.org/articles/test-fixtures.html
  
  # ## 2.2.1 side effects (errors)
  # ## test the `class` of the error, return error-condition object
  # ##  - https://testthat.r-lib.org/reference/expect_error.html
  error_condition <- expect_error(validate_data_frame(3), class = "ussie_error_data")
  
  # ## test the parts of error-condition object that you supply
  expect_identical(error_condition$class_data, "numeric")
  
  # ## test the error-message using a snapshot
  # ##  - https://testthat.r-lib.org/reference/expect_snapshot.html
  # ##  - example output: https://github.com/ijlyttle/ussie/blob/main/tests/testthat/_snaps/validate.md
  # expect_snapshot_error(validate_data_frame(3))
  
  # ## test the return object
  # ##  - https://testthat.r-lib.org/reference/expect_invisible.html
  out <- expect_invisible(validate_data_frame(mtcars))
  expect_identical(out, mtcars)
  
})

test_that("validate_cols works", {
  
  # ## 2.2.2 side effects (global state)
  # ## add helper function to warn on partial matches
 
  # ## 2.2.1 side effects (errors)
  # ## test the `class` of the error, return error-condition object 
  # error_condition <- expect_error(
  #   validate_cols(mtcars, "foo"),
  #   class = "ussie_error_cols"
  # )
  
  # ## test the parts of error-condition object that you supply
  # expect_identical(error_condition$cols_req, "foo")
  # expect_identical(error_condition$cols_data, names(mtcars))
 
  # ## test the error-message using a snapshot
  # expect_snapshot_error(validate_cols(mtcars, "foo"))
  
  # ## add test for the return object

})

