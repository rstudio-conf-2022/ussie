test_that("validation works", {
  expect_error(uss_make_games(3), class = "ussie_error_data_frame")
})
