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

#' Get a league-play tibble
#'
#' Gets league-play data for each game, from {engsoccerdata}, returning
#' a tibble in a standardised format.
#'
#' `uss_countries()` returns the available choices; `"england"` is
#' the default.
#'
#' This function relies on an internal function, `uss_make_matches()`, to parse
#' the source data.
#'
#' @inherit uss_make_matches params return
#'
#' @examples
#' uss_get_matches("england")
#' @export
#'
uss_get_matches <- function(country = uss_countries()) {
  
  # 2.2.1 side effects (errors) 
  #
  # 1. instead, use rlang::arg_match() to validate country
  country <- match.arg(country)
  
  data <- get_soccer_data(country)
  
  # capitalize
  substr(country, 1, 1) <- toupper(substr(country, 1, 1))
  
  # 2.3.1 tidy eval (pass the dots)
  #
  # 1. put `...` into the formals
  # 2. pipe the results to `dplyr::filter(...)`
  # 3. @inheritParams dplyr::filter
  # 4. add a few words to the description
  # 5. add example
  #
  # in other cases, consider using dot-prefix for the other args
  # (but we aren't doing that here)
  # https://design.tidyverse.org/dots-prefix.html
  
  uss_make_matches(data, country) 
}




