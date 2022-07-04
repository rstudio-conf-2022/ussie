#' Structure for printing results
#'
#' For `teams_matches` tibbles, it can be convenient to see the result as a
#' structure, rather than using only `goals_for` and `goals_against`.
#'
#' This function is vectorized over `goals_for` and `goals_against`; they must
#' have the same length.
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
  
  # coerce to integer, lets us accept integer-ish arguments
  goals_for <- vec_cast(goals_for, to = integer())
  goals_against <- vec_cast(goals_against, to = integer())
  
  # call low-level constructor
  new_result(goals_for, goals_against)
}

new_result <- function(goals_for = integer(), goals_against = integer()) {
  
  # low-level constructor
  
  # validate
  vec_assert(goals_for, integer())
  vec_assert(goals_against, integer(), size = length(goals_for))
  
  # construct rcrd class using `vctrs::new_rcrd()`, from man page:
  #  - rcrd composed of 1 or more fields, which must be vectors of same length
  #  - designed specifically for classes that can naturally be decomposed 
  #    into multiple vectors of the same length, like POSIXlt.
  #  - but where the organisation should be considered an implementation detail 
  #    invisible to the user (unlike a data.frame).
  new_rcrd(
    list(goals_for = goals_for, goals_against = goals_against),
    class = "ussie_result"
  )
}

#' @export
format.ussie_result <- function(x, ...) {
  
  # this specifies how a "result" is displayed
  
  # format() is a well-established generic function; we are specifiying 
  # a method for our class.
  
  # field() is a vcrts function to extract a field from a rcrd
  goals_for <- field(x, "goals_for")
  goals_against <- field(x, "goals_against")
  
  outcome <- dplyr::case_when(
    goals_for >  goals_against ~ "W",
    goals_for == goals_against ~ "D",
    goals_for <  goals_against ~ "L",
    TRUE ~ NA_character_
  )
  
  # compose output
  out <- glue::glue("{outcome} {goals_for}-{goals_against}")
  
  # what if something is missing?
  out[is.na(goals_for) | is.na(goals_against)] <- NA_character_
  
  # coerce to character (glue adds a class to character, messes things up)
  as.character(out)
}

# these generics are defined in the vctrs package
# - they control how the class-name is abbreviated when a tibble is printed.

#' @export
vec_ptype_abbr.ussie_result <- function(x, ...) "rslt"

#' @export
vec_ptype_full.ussie_result <- function(x, ...) "result"