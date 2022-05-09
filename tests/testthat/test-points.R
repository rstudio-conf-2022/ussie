test_that("uss_points_per_game() works", {
  expect_identical(
    uss_points_per_win(country = "england", season = 1980),
    2L
  )

  expect_identical(
    uss_points_per_win(country = "england", season = 1981),
    3L
  )

  # expect_warning(
  #   tatooine <- uss_points_per_win("tatooine", season = 1977),
  #   "country"
  # )
  #
  # expect_identical(tatooine, 3)
})

