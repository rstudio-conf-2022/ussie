#' Get available countries
#'
#' These are the countries for which there is league-play data available
#' from {engsoccerdata}.
#'
#' @return `character` vector containing names of available countries.
#'
#' @examples
#' uss_countries()
#' @export
#'
uss_countries <- function() {
  c("england", "germany", "holland", "italy", "spain")
}

#' Return data from {engsoccerdata}
#'
#' @param data_name `character` name of a dataset in {engsoccerdata}.
#' @return data frame, presumably
#' @examples
#' get_soccer_data("england")
#' @noRd
#'
get_soccer_data <- function(data_name) {
  # utils::data() writes the data straight into an environment, using
  # the name of the dataset, so we create a sandbox (isolated) environment
  e <- new.env()

  # utils::data() puts the data named by `data_name` into the environment `e`,
  # and returns the `name`, which should be the same as `data_name`
  name <- utils::data(list = data_name, package = "engsoccerdata", envir = e)[1]

  # return the data from the environment
  e[[name]]
}

#' Remind me of the better times
#'
#' I get knocked down, but I get up again...
#'
#' This unexported function serves as a way to let R CMD CHECK know that
#' this package, in fact, imports stuff from {engsoccerdata}.
#'
#' Normally, we are using {engsoccerdata} for its data. However, when we run
#' R CMD CHECK, it complains that we "Import" {engsoccerdata}, we are not using
#' anything that it exports. Package-datasets are
#' [not exported](https://r-pkgs.org/data.html#documenting-data).
#'
#' Hence, this function is a workaround to demonstrate to R CMD CHECK that
#' we are, in fact, using stuff from {engsoccerdata}.
#'
#' @param n `integer`, number of results to return
#'
#' @return data frame
#' @examples
#' best_wins_leeds(20)
#' @noRd
#'
best_wins_leeds <- function(n = 10) {
  engsoccerdata::bestwins(
    engsoccerdata::england,
    teamname = "Leeds United",
    N = n
  )
}

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
#   `season`, `tier`, `home`, `visitor`, `goals_home`, `goals_visitor`.
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
  # 1. usethis::use_tidy_eval() to access the `.data` pronoun
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
      tier = as.integer(.data$tier),
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

#' Get a league-play tibble
#'
#' Gets league-play data for each game, from {engsoccerdata}, returning
#' a tibble in a standardised format. You can pass in filtering expressions
#' via the dots (`...`), these are evaluated using [dplyr::filter()].
#'
#' `uss_countries()` returns the available choices; `"england"` is
#' the default.
#'
#' This function relies on an internal function, `uss_make_matches()`, to parse
#' the source data; to speed up the performance, a memoised (caching) version
#' of this function is used, `uss_make_matches_mem()`.
#'
#' @inherit uss_make_matches params return
#' @inheritDotParams dplyr::filter
#'
#' @examples
#' uss_get_matches("england")
#' @export
#'
uss_get_matches <- function(country = uss_countries(), ...) {

  # The idea here would be to establish the function using only the
  # `country` parameter, then to introduce the "pass-the-dots" concept
  # from tidy eval:
  #
  # 1. put `...` into the formals
  # 2. pipe the results to `dplyr::filter(...)`
  # 3. @inheritDotParams dplyr::filter
  # 4. a few words in the description

  # tidyverse variant of match.arg
  country <- rlang::arg_match(country)

  data <- get_soccer_data(country)

  # capitalize
  substr(country, 1, 1) <- toupper(substr(country, 1, 1))

  # build standardised tibble, caching results
  uss_make_matches_mem(data, country) |>
    dplyr::filter(...)
}
