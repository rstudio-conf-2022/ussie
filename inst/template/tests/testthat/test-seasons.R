teams_matches_italy <-
  uss_get_matches("italy") |>
  uss_make_teams_matches()

test_that("seasons_intermediate() works", {
  
  local_warn_partial_match()
  
  italy <- seasons_intermediate(teams_matches_italy, uss_points_per_win)
  expect_named(italy, cols_seasons())
  
  # not comprehensive, but may give us a indication if something changes
  expect_snapshot(dplyr::glimpse(italy))
  
  # ## 2.4.1 Misc. (as_function())
  # ## make sure we can pass a purr-style anonymous function for points
  #
  # italy_5_wins <-
  #   seasons_intermediate(teams_matches_italy, ~5L) |>
  #   dplyr::filter(wins == TRUE)
  # 
  # expect_identical(unique(italy_5_wins$points), 5L)
  
})

test_that("uss_make_seasons_cumulative() works", {

  local_warn_partial_match()
  
  expect_error(uss_make_seasons_cumulative(3), class = "ussie_error_data")
  expect_error(uss_make_seasons_cumulative(mtcars), class = "ussie_error_cols")
  
  italy <- uss_make_seasons_cumulative(teams_matches_italy)
  expect_named(italy, cols_seasons())
  
  # not comprehensive, but may give us a indication if something changes
  expect_snapshot(dplyr::glimpse(italy))
  
})

test_that("uss_make_seasons_final() works", {
  
  local_warn_partial_match()
  
  # ## 2.3.7 tidy eval (exercise)
  # ## validate
  # expect_error(uss_make_seasons_final(3), class = "ussie_error_data")
  # expect_error(uss_make_seasons_final(mtcars), class = "ussie_error_cols")
  
  # ## 2.3.7 tidy eval (exercise)
  # ## calculate final results using cumulative results, expect same result 
  #
  # italy_cumulative_final <- 
  #   uss_make_seasons_cumulative(teams_matches_italy) |>
  #   dplyr::group_by(
  #     dplyr::across(cols_seasons_grouping())
  #   ) |>
  #   dplyr::filter(
  #     .data$matches == max(.data$matches),
  #     .preserve = TRUE
  #   ) |>
  #   arrange_final()
  #
  # italy_final <- uss_make_seasons_final(teams_matches_italy) 
  # 
  # expect_identical(italy_final, italy_cumulative_final)

})