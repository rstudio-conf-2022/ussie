cols_season_grouping <- function() {
  c("country", "tier", "season", "team")
}

cols_season_accumulate <- function() {
  c("matches", "wins", "draws", "losses", "points",
    "goals_for", "goals_against")
}

#' Make intermediate calculation for seasons
#'
#' Given a teams-matches data frame,
#' for each grouping of country/tier/season/team,
#' make new columns: date/matches/wins/draws/losses/goals_for/goals_against.
#'
#' Each row is local to each match having been played.
#'
#' The purpose is either to set up cumulative results within a season,
#' ot to set up final results for the season.
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

#' Make season-based calculations
#'
#' @description
#' Given a teams-matches data frame (returned by [uss_make_teams_matches()]),
#' return return a data frame on wins, losses, points, etc.:
#'
#' - cumulative, over the course of each season: `uss_make_season_cumulative()`
#' - final result for each season: `uss_make_season_final()`
#'
#' @param data_teams_matches data frame created using [uss_make_teams_matches()]
#' @param fn_points_per_win `function` with vectorized arguments `country`,
#'   `season`, that returns a integer indicating points-per-win.
#'   A default function is provided, [uss_points_per_win()], which includes
#'   the countries in [uss_countries()].
#'
#' @return [tibble][tibble::tibble-package] with columns
#'   `country`, `tier`, `season`, `team`, `date`, `matches`, `wins`,
#'   `draws`, `losses`, `points`, `goals_for`, `goals_against`.
#' @examples
#' italy <- uss_get_matches("italy") |> uss_make_teams_matches()
#' uss_make_season_cumulative(italy)
#' uss_make_season_final(italy)
#' @export
#'
uss_make_season_cumulative <- function(data_teams_matches,
                                       fn_points_per_win = uss_points_per_win) {

  validate_data_frame(data_teams_matches)
  validate_cols(data_teams_matches, cols_teams_matches())

  result <-
    data_teams_matches |>
    season_intermediate(fn_points_per_win) |>
    dplyr::mutate(
      dplyr::across(cols_season_accumulate(), cumsum)
    )

  result
}

#' @rdname uss_make_season_cumulative
#' @export
#'
uss_make_season_final <- function(data_teams_matches,
                                  fn_points_per_win = uss_points_per_win) {

  validate_data_frame(data_teams_matches)
  validate_cols(data_teams_matches, cols_teams_matches())

  result <-
    data_teams_matches |>
    season_intermediate(fn_points_per_win) |>
    dplyr::summarise(
      date = max(.data$date),
      dplyr::across(cols_season_accumulate(), sum)
    )

  result
}

