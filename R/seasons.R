#' Make intermediate calculation for seasons
#'
#' Given a teams-matches data frame,
#' for each grouping of country/tier/season/team,
#' make new columns: date/matches/wins/draws/losses/goals_for/goals_against.
#'
#' Each row is local to each match having been played.
#'
#' The purpose is either to set up cumulative results within a season,
#' or to set up final results for the season.
#'
#' @noRd
#'
seasons_intermediate <- function(data_teams_matches, fn_points_per_win) {

  # accept purrr-style anonymous functions
  fn_points_per_win <- rlang::as_function(fn_points_per_win)

  result <-
    data_teams_matches |>
    # across() lets you use tidy-select semantics inside data-masking functions
    # - https://dplyr.tidyverse.org/articles/colwise.html
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(cols_seasons_grouping())
      )
    ) |>
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
#' - cumulative, over the course of each season: `uss_make_seasons_cumulative()`
#' - final result for each season: `uss_make_seasons_final()`
#'
#' @param data_teams_matches data frame created using [uss_make_teams_matches()]
#' @param fn_points_per_win `function` with vectorized arguments `country`,
#'   `season`, that returns a integer indicating points-per-win.
#'   A default function is provided, [uss_points_per_win()], which includes
#'   the countries in [uss_countries()]. You can also provide a purrr-style
#'   anonymous function, e.g. `~3`.
#'
#' @return [tibble][tibble::tibble-package] with columns
#'   `country`, `tier`, `season`, `team`, `date`, `matches`, `wins`,
#'   `draws`, `losses`, `points`, `goals_for`, `goals_against`.
#' @examples
#' italy <- uss_get_matches("italy") |> uss_make_teams_matches()
#' uss_make_seasons_cumulative(italy)
#' uss_make_seasons_final(italy)
#' @export
#'
uss_make_seasons_cumulative <- function(data_teams_matches,
                                        fn_points_per_win = uss_points_per_win) {

  validate_data_frame(data_teams_matches)
  validate_cols(data_teams_matches, cols_teams_matches())

  result <-
    data_teams_matches |>
    seasons_intermediate(fn_points_per_win) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(cols_seasons_accumulate()),
        cumsum
      )
    )

  result
}

#' @rdname uss_make_seasons_cumulative
#' @export
#'
uss_make_seasons_final <- function(data_teams_matches,
                                   fn_points_per_win = uss_points_per_win) {

  # perhaps it could be an exercise to copy/paste uss_make_seasons_cumulative()
  # to make this function.
  #
  # - add minimal roxygen at top
  # - change mutate() to summarise()
  # - add treatment for date
  # - change cumsum to sum

  validate_data_frame(data_teams_matches)
  validate_cols(data_teams_matches, cols_teams_matches())

  result <-
    data_teams_matches |>
    seasons_intermediate(fn_points_per_win) |>
    dplyr::summarise(
      date = max(.data$date),
      dplyr::across(
        dplyr::all_of(cols_seasons_accumulate()),
        sum
      )
    )

  result
}

