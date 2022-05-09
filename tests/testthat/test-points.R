test_that("uss_points works", {
  expect_identical(
    uss_points(wins = 3, draws = 1, country = "england", season = 1980),
    7
  )

  expect_identical(
    uss_points(wins = 3, draws = 1, country = "england", season = 1981),
    10
  )
})

test_that("uss_points_per_game() works", {
  expect_identical(
    uss_points_per_win(country = "england", season = 1980),
    2
  )

  expect_identical(
    uss_points_per_win(country = "england", season = 1981),
    3
  )
})

