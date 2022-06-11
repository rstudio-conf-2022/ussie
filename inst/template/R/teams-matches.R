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
  
  # 2.3.3 tidy eval (!!!splice) 
  #  - `!!!` splice operator, reflects `...` - unpacks contents for splicing
  #  - use to replace contents of `dplyr::rename()` with `rename_home()`
  #  - do the same with `teams_matches_visitor`, for `rename_visitor()`
  #
  teams_matches_home <-
    data_matches |>
    dplyr::rename(
      team = "home",
      opponent = "visitor",
      goals_for = "goals_home",
      goals_against = "goals_visitor"
    ) |>
    dplyr::mutate(at_home = TRUE)
  
  # We can use `at_home` as a bare name because `dplyr::mutate()` takes
  # `...`, which permits named arguments of "unknown" names.
  # As well, this is OK "morally" because `at_home` can refer only to
  # a column in the data frame.
  
  # This is oh-so contrived, but it gives us a chance to show off two more
  # features of tidy eval.
  #
  # 2.3.2 tidy eval (pronouns)
  #  - `.env` pronoun, don't forget `usethis::use_import_from("rlang", ".env")`
  #
  at_home <- FALSE
  
  # 2.3.4 tidy eval (naming new columns)
  #  - `:=` to invoke naming, `"{}"` glue syntax in name
  #
  name_of_at_home <- "at_home"
  
  teams_matches_visitor <-
    data_matches |>
    dplyr::rename(
      team = "visitor",
      opponent = "home",
      goals_against = "goals_home",
      goals_for = "goals_visitor"
    ) |>
    dplyr::mutate(at_home = .env$at_home)
  
  # 2.3.5 tidy eval (across())
  # Arrange `result` by `c("country", "tier", "season", "team", "date")`
  #  - `dplyr::arrange()` is a data-masking function, it evaluates 
  #  - a character vector ("country", etc.) is a tidy-selection specification,
  #    it specifies columns
  #  - to use tidy-select spec in a data-masking function, use `dplyr::across()`
  #    - to specify that all the specified columns must be present (or error),
  #      use `dplyr::all_of()`
  #
  result <-
    teams_matches_home |>
    dplyr::bind_rows(teams_matches_visitor) |>
    dplyr::select(dplyr::all_of(cols_teams_matches())) 

  # I'm finding that `dplyr::all_of()` does not seem to be strictly necessary.
  # It's bulky, but I think it remains a good practice because it asserts that
  # these columns shall be in the data frame; something is wrong if not.
  
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
