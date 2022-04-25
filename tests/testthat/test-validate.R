test_that("validate_data_frame works", {

  tmp <- expect_error(validate_data_frame(3), class = "ussie_error_data_frame")

  expect_identical(tmp[["class_data"]], "numeric")

  expect_snapshot_error(validate_data_frame(3))

  expect_identical(validate_data_frame(mtcars), mtcars)
})

test_that("validate_cols works", {

  tmp <- expect_error(
    validate_cols(mtcars, "foo"),
    class = "ussie_error_cols"
  )

  expect_identical(tmp[["cols_req"]], "foo")
  expect_identical(tmp[["cols_data"]], names(mtcars))

  expect_snapshot_error(validate_cols(mtcars, "foo"))

  expect_identical(validate_cols(mtcars, "mpg"), mtcars)
})
