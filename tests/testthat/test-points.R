test_that("uss_points works", {
  expect_identical(
    uss_points(wins = 3, draws = 1, country = "england", season = 1980),
    7
  )

  expect_identical(
    uss_points(wins = 3, draws = 1, country = "england", season = 1981),
    10
  )

  expect_identical(
    uss_points(
      wins = c(3, 3),
      draws = c(1, 1),
      country = c("england", "england"),
      season = c(1980, 1981)
    ),
    c(7, 10)
  )
})

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

