#' Get a league-play tibble
#'
#' Gets league-play data for each game, from {engsoccerdata}, returning
#' a tibble in a standardised format. You can pass in filtering expressions
#' via the dots (`...`), these are evaluated using [dplyr::filter()].
#' Filtering is the last step; it operates on the **returned** data.
#'
#' `uss_countries()` returns the available choices; `"england"` is
#' the default.
#'
#' This function relies on an internal function, `uss_make_matches()`, to parse
#' the source data; to speed up the performance, a memoised (caching) version
#' of this function is used, `uss_make_matches_mem()`.
#'
#' @inherit uss_make_matches params return
#' @inheritParams dplyr::filter
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
  #
  # keep in mind to use dot-prefix for the other args
  # (but we aren't doing that here)
  # https://design.tidyverse.org/dots-prefix.html

  # tidyverse variant of match.arg
  country <- rlang::arg_match(country)

  data <- get_soccer_data(country)

  # capitalize
  substr(country, 1, 1) <- toupper(substr(country, 1, 1))

  # build standardised tibble, caching results
  uss_make_matches_mem(data, country) |>
    dplyr::filter(...)
}

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
