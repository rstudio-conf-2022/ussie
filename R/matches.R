#' Make a standard league-play tibble
#'
#' @description
#' Given a league-play data frame from {engsoccer}, returns a tibble with
#' standardised colomn-names and types, e.g. `date` is a `Date`.
#'
#' There are two versions of this function:
#'
#' \describe{
#'   \item{`uss_make_matches()`}{working version}
#'   \item{`uss_make_matches_mem()`}{memoised (caching) version}
#' }
#'
#' `uss_make_matches_mem()` calls `uss_make_matches()`; they will resturn identical
#' results.
#'
#' @details
#' A memoised version of this function is provided because it takes a little
#' time to parse the dates for nearly 200,000 league-play matches for England.
#'
#' When the package is loaded, the wrapper function, `uss_make_matches_mem()`,
#' is "replaced" by the memoised version: see `zzz.R`.
#'
#' A wrapper function is used for a couple reasons:
#'  - to maintain access to the un-memoised function
#'  - so that R CMD CHECK can see that the {tibble} package is actually used;
#'    it throws a note if the original function, `uss_make_matches_mem()`,
#'    is overwritten
#'
#' @param data_engsoc `data.frame` obtained from {engsoccerdata}.
#' @param country `character` scalar, specifies the league.
#'   `uss_countries()` returns choices available from {engsoccerdata}
#'
#' @return [tibble][tibble::tibble-package] with columns `country`, `date`,
#'  `season`, `tier`, `home`, `visitor`, `goals_home`, `goals_visitor`.
#'
#' @examples
#' uss_make_matches(engsoccerdata::italy, "Italy")
#' uss_make_matches_mem(engsoccerdata::italy, "Italy")
#' @keywords internal
#' @export
#'
uss_make_matches <- function(data_engsoc, country) {

  # validate
  validate_data_frame(data_engsoc)
  validate_cols(data_engsoc, cols_engsoc())

  # The idea here would be to establish this function without using the
  # `.data` pronoun, see that it works but does not pass R CMD CHECK cleanly 🙀
  #
  # 1. usethis::use_import_from("rlang", ".data") to access the `.data` pronoun
  # 2. change `as.integer(tier)` to `as.integer(.data$tier)`, etc.
  #
  # Note: we don't "pass-the-dots" to `dplyr::filter()` here becuase
  # `memoise::memoise()` doesn't work with data-masking expressions.
  # This gets to the idea of referential transparency:
  #  - https://tidyeval.tidyverse.org/sec-why-how.html#unquoting-code
  #
  # `memoise::memoise()` relies on referential transparency, data-masking
  # breaks referential transparency.

  # put into "standard" form
  result <-
    data_engsoc |>
    tibble::as_tibble() |>
    dplyr::transmute(
      country = as.character(country),
      tier = factor(.data$tier, levels = c("1", "2", "3", "4")),
      season = as.integer(.data$Season),
      date = as.Date(.data$Date),
      home = as.character(.data$home),
      visitor = as.character(.data$visitor),
      goals_home = as.integer(.data$hgoal),
      goals_visitor = as.integer(.data$vgoal)
    )

  result
}

#' @rdname uss_make_matches
#' @export
#'
uss_make_matches_mem <- function(data_engsoc, country) {
  uss_make_matches(data_engsoc, country)
}

