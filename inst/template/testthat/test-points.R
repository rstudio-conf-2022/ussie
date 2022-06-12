test_that("uss_points_per_game() works", {
  
  local_warn_partial_match()
  
  expect_identical(
    uss_points_per_win(country = "england", season = 1980),
    2L
  )
  
  expect_identical(
    uss_points_per_win(country = "england", season = 1981),
    3L
  )
  
  expect_identical(
    uss_points_per_win(
      country = c("england", "england"),
      season = c(1980, 1981)
    ),
    c(2L, 3L)
  )
  
  expect_snapshot_warning(
    tatooine <- uss_points_per_win("tatooine", season = 1977, default = 4),
    class = "ussie_warning_points_country"
  )
  
  expect_identical(tatooine, 4L)
  
  expect_snapshot_error(
    uss_points_per_win("tatooine", season = c(1977, 1977)),
    class = "ussie_error_points_lengths"
  )
  
})
