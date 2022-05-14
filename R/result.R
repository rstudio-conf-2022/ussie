#' Structure for printing
#'
#' `goals_for` and `goals_against` must have the same length.
#'
#' @param goals_for `integer`-ish number of goals for a team in a match.
#' @param goals_against `integer`-ish number of goals against a team in a match.
#'
#' @return An S3 object with class `ussie_result`.
#' @examples
#' uss_result(3, 2)
#' uss_get_matches("italy") |>
#'   uss_make_teams_matches() |>
#'   dplyr::mutate(
#'     result = uss_result(goals_for, goals_against),
#'     .after = opponent
#'   )
#' @export
#'
uss_result <- function(goals_for = integer(), goals_against = integer()) {

  # high-level constructor

  # coerce to integer
  goals_for <- vec_cast(goals_for, to = integer())
  goals_against <-vec_cast(goals_against, to = integer())

  new_result(goals_for, goals_against)
}

new_result <- function(goals_for = integer(), goals_against = integer()) {

  # low-level constructor

  # validate
  vec_assert(goals_for, integer())
  vec_assert(goals_against, integer())

  # construct
  new_rcrd(
    list(goals_for = goals_for, goals_against = goals_against),
    class = "ussie_result"
  )
}

#' @export
format.ussie_result <- function(x, ...) {
  goals_for <- field(x, "goals_for")
  goals_against <- field(x, "goals_against")

  result <- dplyr::case_when(
    goals_for >  goals_against ~ "W",
    goals_for == goals_against ~ "D",
    goals_for <  goals_against ~ "L",
    TRUE ~ NA_character_
  )

  out <- glue::glue("{result} {goals_for}-{goals_against}")
  out[is.na(goals_for) | is.na(goals_against)] <- NA_character_

  as.character(out)
}

vec_ptype_abbr.ussie_result <- function(x, ...) "rslt"
vec_ptype_full.ussie_result <- function(x, ...) "result"
