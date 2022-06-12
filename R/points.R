#' Calculate points
#'
#' Given `country` and `season`, return the number of points for a win.
#'
#' This function is vectorized over `country` and `season`; they should have
#' the same length. If any `country` is not in `uss_countries`, a warning
#' is issued, and the `default` value is used. 
#'
#' @inheritParams uss_make_matches
#' @param season `integer`-ish year of the football season.
#' @param default `integer`-ish default value for points-per-win, used if
#'   a value of `country` is not in `uss_countries()`.
#'
#' @return `integer` number of points per win
#'
#' @examples
#' uss_points_per_win("england", 1980)
#' uss_points_per_win(c("england", "england"), c(1980, 1981))
#' @export
#'
uss_points_per_win <- function(country, season, default = 3) {
  
  # ref: https://en.wikipedia.org/wiki/Three_points_for_a_win#Year_of_adoption_of_three_points_for_a_win
  season_first_three <- c(
    england = 1981,
    germany = 1995,
    holland = 1995,
    italy = 1994,
    spain = 1995
  )
  
  # validation
  country <- tolower(country)
  
  # predicate
  if (length(country) != length(season)) {
    cli::cli_abort(
      # information for user
      c(
        "{.field country} and {.field season} must have same length:",
        `*` = "{.field country} has length {.val {length(country)}}.",
        `*` = "{.field season} has length {.val {length(season)}}."
      ),
      # class information for developers
      class = "ussie_error_points_lengths",
      # other information for developers
      n_country = length(country),
      n_season = length(season)
      # tell user about this function, no need to set `call`
    )
  }
  
  # predicate
  country_not_available <- setdiff(country, uss_countries())
  n <- length(country_not_available)
  if (n > 0) {
    cli::cli_warn(
      # information for user
      c(
        "Using default value, {.val {default}}, where {.field country} not available:",
        `!` = "{cli::qty(n)} Countr{?y/ies} not available: {.val {country_not_available}}."
      ),
      # class information for developers
      class = "ussie_warning_points_country",
      # other information for developers
      country_not_available = country_not_available
      # tell user about this function, no need to set `call`
    )
  }
  
  # create result-vector using default
  result <- rlang::rep_along(country, default)
  
  result[season < season_first_three[country]] <- 2
  result[season >= season_first_three[country]] <- 3
  
  as.integer(result)
}