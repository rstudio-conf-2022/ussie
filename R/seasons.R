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
  
  # 2.4.1 Misc. (as_function())
  #
  # 1. accept purrr-style anonymus functions
  
  result <-
    data_teams_matches |>
    # across() lets you use tidy-select semantics inside data-masking functions
    # - https://dplyr.tidyverse.org/articles/colwise.html
    dplyr::group_by(
      dplyr::across(cols_seasons_grouping())
    ) |>
    dplyr::arrange(.data$date, .by_group = TRUE) |>
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
#'   the countries in [uss_countries()]. 
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
      dplyr::across(cols_seasons_accumulate(), cumsum)
    ) 
  
  result
}

# 2.3.6 tidy eval (exercise) 
#
# Create a new function: `uss_make_seasons_final()`:
#
# 1. It has the same formal arguments as `uss_make_seasons_cumulative()`.
# 2. You can use `#' @rdname uss_make_seasons_cumulative` to document,
#    then add notes to its documentation.
# 3. Don't forget to `#' @export`.
# 4. You can use the same validation (then test the validation by uncommenting).
# 5. Instead of `dplyr::mutate()`, you can use `dplyr::summarise()`.
# 6  You will want to `sum` quantities, rather than `cumsum`.
# 7. You will have to summarise the `date` differently than 
#    `cols_seasons_accumulate()`.
# 8. Use the `arrange_final()` function to arrange the results into "normal"
#    standings.
# 9. Test the function by uncommenting the tests.

#' @rdname uss_make_seasons_cumulative
#' @export
#'
uss_make_seasons_final <- function(data_teams_matches,
                                   fn_points_per_win = uss_points_per_win) {
  
  validate_data_frame(data_teams_matches)
  validate_cols(data_teams_matches, cols_teams_matches())
  
  result <-
    data_teams_matches |>
    seasons_intermediate(fn_points_per_win) |>
    dplyr::summarise(
      date = max(.data$date),
      dplyr::across(cols_seasons_accumulate(), sum)
    ) |>
    arrange_final()
  
  result  
}

# internal function to arrange season-final standings
arrange_final <- function(data) {
  
    result <-
      data |>
      dplyr::group_by(
        dplyr::across(c("country", "season", "tier"))
      ) |>
      dplyr::arrange(
        dplyr::desc(.data$points),
        dplyr::desc(.data$goals_for - .data$goals_against),
        .data$team,
        .by_group = TRUE
      )

    result
}

