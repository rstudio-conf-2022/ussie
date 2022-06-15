goals_for <- c(1L, 2L, 3L)
goals_against <- c(2L, 2L, 2L)

test_that("low-level constructor works", {
  
  # use helper function to warn on partial matches
  local_warn_partial_match()
  
  expect_error(new_result("3", 3L), class = "vctrs_error_assert_ptype")
  expect_error(new_result(3L, "3"), class = "vctrs_error_assert_ptype")
  expect_error(new_result(c(3L, 3L), 3L), class = "vctrs_error_assert_size")
  
  result <- new_result(goals_for, goals_against)
  
  expect_s3_class(result, "ussie_result")
  
  result_data <- vctrs::vec_data(result)
  expect_identical(result_data$goals_for, goals_for)
  expect_identical(result_data$goals_against, goals_against)
  
})


test_that("high-level constructor works", {
  
  result_low <- new_result(goals_for, goals_against)
  
  # same input
  expect_identical(uss_result(goals_for, goals_against), result_low)
  
  # numeric (not integer) input
  expect_identical(
    uss_result(as.numeric(goals_for), as.numeric(goals_against)),
    result_low
  )
  
})

test_that("formatting works", {
  
  result <- uss_result(goals_for, goals_against)
  
  expect_snapshot(print(result))
  
})