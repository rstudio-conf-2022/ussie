#' Make a teams-matches tibble
#'
#' This has essentially the same as the `matches` data; here, a row is returned
#' for every combination of team and match. Thus there are two rows returned
#' for each row in the `data_matches` tibble: one for each team.
#'
#' @param data_matches `data.frame` created using `uss_get_matches()` or `uss_make_matches()`
#'
#' @return [tibble][tibble::tibble-package] with columns `country`, `tier`,
#'   `season`, `team`, `date`, `opponent`, `at_home`,
#'   `goals_for`, `goals_against`; ordered by `country`, `tier`,
#'   `season`, `team`, `date`.
#' @examples
#' uss_get_matches("england") |>
#'   uss_make_teams_matches() |>
#'   dplyr::filter(team == "Leeds United") |>
#'   tail()
#' @export
#'
uss_make_teams_matches <- function(data_matches) {

  # validate
  validate_data_frame(data_matches)
  validate_cols(data_matches, cols_matches())

  teams_matches_home <-
    data_matches |>
    dplyr::rename(!!!rename_home()) |>
    dplyr::mutate(at_home = TRUE)

  teams_matches_visitor <-
    data_matches |>
    dplyr::rename(!!!rename_visitor()) |>
    dplyr::mutate(at_home = FALSE)

  result <-
    teams_matches_home |>
    dplyr::bind_rows(teams_matches_visitor) |>
    dplyr::select(dplyr::all_of(cols_teams_matches())) |>
    dplyr::arrange(
      dplyr::across(c("country", "tier", "season", "team", "date"))
    )

  result
}

rename_home <- function() {
  c(team = "home",
    opponent = "visitor",
    goals_for = "goals_home",
    goals_against = "goals_visitor"
  )
}

rename_visitor <- function() {
  c(team = "visitor",
    opponent = "home",
    goals_against = "goals_home",
    goals_for = "goals_visitor"
  )
}

