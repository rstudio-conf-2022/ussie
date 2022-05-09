cols_season_grouping <- function() {
  c("country", "tier", "season", "team")
}

cols_season_accumulate <- function() {
  c("matches", "wins", "draws", "losses", "points",
    "goals_for", "goals_against")
}

#' Cal
#'
#'
#' @noRd
#'
season_intermediate <- function(data_teams_matches, fn_points_per_win) {

  result <-
    data_teams_matches |>
    dplyr::group_by(dplyr::across(cols_season_grouping())) |>
    dplyr::transmute(
      date = .data$date,
      matches = TRUE,
      wins = .data$goals_for > .data$goals_against,
      draws = .data$goals_for == .data$goals_against,
      losses = .data$goals_for < .data$goals_against,
      points =
        fn_points_per_win(.data$country, .data$season) * .data$wins +
          .data$draws,
      goals_for = .data$goals_for,
      goals_against = .data$goals_against
    )

  result
}

uss_season_final <- function(data_teams_matches,
                             fn_points_per_win = uss_points_per_win) {
  result <-
    data_teams_matches |>
    season_intermediate(fn_points_per_win) |>
    dplyr::summarise(
      date = max(.data$date),
      dplyr::across(cols_season_accumulate(), sum)
    )

  result
}

uss_season_cumulative <- function(data_teams_matches,
                                  fn_points_per_win = uss_points_per_win) {
  result <-
    data_teams_matches |>
    season_intermediate(fn_points_per_win) |>
    dplyr::mutate(
      dplyr::across(cols_season_accumulate(), cumsum)
    )

  result
}
