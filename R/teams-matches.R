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

  # A couple points here:
  #  - `!!!` splice operator, reflects `...` - unpacks contents for splicing
  #  - We can use `at_home` as a bare name because `dplyr::mutate()` takes
  #    `...`, which permits named arguments of "unknown" names.
  #    As well, this is OK "morally" because `at_home` can refer only to
  #    a column in the data frame.
  #
  teams_matches_home <-
    data_matches |>
    dplyr::rename(!!!rename_home()) |>
    dplyr::mutate(at_home = TRUE)

  # This is oh-so contrived, but it gives us a chance to show off two more
  # features of tidy eval:
  #  - `.env` pronoun, don't forget `usethis::use_import_from("rlang", ".env")`
  #  - `:=` to invoke naming, `"{}"` glue syntax in name
  #
  name_of_at_home <- "at_home"
  at_home <- FALSE
  teams_matches_visitor <-
    data_matches |>
    dplyr::rename(!!!rename_visitor()) |>
    dplyr::mutate("{name_of_at_home}" := .env$at_home)

  # I'm finding that `dplyr::all_of()` does not seem to be strictly necessary.
  # It's bulky, but I think it remains a good practice because it asserts that
  # these columns shall be in the data frame; something is wrong if not.
  #
  result <-
    teams_matches_home |>
    dplyr::bind_rows(teams_matches_visitor) |>
    dplyr::select(dplyr::all_of(cols_teams_matches())) |>
    dplyr::arrange(
      dplyr::across(
        dplyr::all_of(
          c("country", "tier", "season", "team", "date")
        )
      )
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

