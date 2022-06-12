test_that("uss_plot_seasons_tiers() works", {
  
  local_warn_partial_match()
  
  expect_error(uss_plot_seasons_tiers(3), class = "ussie_error_data")
  expect_error(uss_plot_seasons_tiers(mtcars), class = "ussie_error_cols")
  
  leeds_norwich <-
    uss_get_matches("england") |>
    uss_make_teams_matches() |>
    dplyr::filter(team %in% c("Leeds United", "Norwich City")) |>
    uss_make_seasons_final() |>
    dplyr::arrange(team, season)
  
  # default
  expect_snapshot_ggplot("wins", uss_plot_seasons_tiers(leeds_norwich))
  
  # ## 2.3.7 tidy eval (curly-curly)
  # ## different y-axis
  # expect_snapshot_ggplot(
  #   "wins-losses",
  #   uss_plot_seasons_tiers(leeds_norwich, wins - losses)
  # )
  
  # number of columns
  expect_snapshot_ggplot(
    "ncol",
    uss_plot_seasons_tiers(leeds_norwich, ncol = 2),
    width = 8,
    height = 4
  )
})