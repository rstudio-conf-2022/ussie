season_intermediate <- function(data_teams_matches,
                                fn_points_per_win = uss_points_per_win) {

  result <-
    data_teams_matches |>
    dplyr::group_by(dplyr::across(c("country", "tier", "season", "team"))) |>
    dplyr::transmute(
      date = .data$date,
      matches = TRUE,
      wins = .data$goals_for > .data$goals_against,
      draws = .data$goals_for == .data$goals_against,
      losses = .data$goals_for < .data$goals_against,
      points =
        uss_points_per_win(.data$country, .data$season) * .data$wins +
          .data$draws,
      goals_for = .data$goals_for,
      goals_against = .data$goals_against
    )

  result
}

cols_accumulate <- function() {
  c("matches", "wins", "draws", "points", "goals_for", "goals_against")
}

uss_season_final <- function(data_teams_matches) {
  result <-
    data_teams_matches |>
    season_intermediate() |>
    dplyr::summarise(
      date = max(.data$date),
      dplyr::across(cols_accumulate(), sum)
    ) |>
    dplyr::arrange(dplyr::desc(.data$points), .by_group = TRUE)

  # note: order by season not by tier
  result
}

uss_season_cumulative <- function(data_teams_matches) {
  result <-
    data_teams_matches |>
    season_intermediate() |>
    dplyr::mutate(
      dplyr::across(cols_accumulate(), cumsum)
    )

  result
}
