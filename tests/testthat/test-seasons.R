teams_matches_italy <-
  uss_get_matches("italy") |>
  uss_make_teams_matches()

test_that("seasons_intermediate() works", {
  italy <- seasons_intermediate(teams_matches_italy, uss_points_per_win)
  expect_named(italy, cols_seasons())
  # not comprehensive, but may give us a indication if something changes
  expect_snapshot(dplyr::glimpse(italy))

  # make sure we can pass a purr-style anonymous function for points
  italy_5_wins <-
    seasons_intermediate(teams_matches_italy, ~5L) |>
    dplyr::filter(wins == TRUE)

  expect_identical(unique(italy_5_wins$points), 5L)
})

test_that("uss_make_seasons_cumulative() works", {

  expect_error(uss_make_seasons_cumulative(3), class = "ussie_error_data")
  expect_error(uss_make_seasons_cumulative(mtcars), class = "ussie_error_cols")

  italy <- uss_make_seasons_cumulative(teams_matches_italy)
  expect_named(italy, cols_seasons())
  # not comprehensive, but may give us a indication if something changes
  expect_snapshot(dplyr::glimpse(italy))
})

test_that("uss_make_seasons_final() works", {

  expect_error(uss_make_seasons_final(3), class = "ussie_error_data")
  expect_error(uss_make_seasons_final(mtcars), class = "ussie_error_cols")

  italy <- uss_make_seasons_final(teams_matches_italy)
  expect_named(italy, cols_seasons())
  # not comprehensive, but may give us a indication if something changes
  expect_snapshot(dplyr::glimpse(italy))
})
