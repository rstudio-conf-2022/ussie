#' Calculate points
#'
#' @inheritParams uss_make_matches
#' @param season `integer`-ish year of the football season.
#'
#' @return `integer` number of points per win
#'
#' @examples
#' uss_points_per_win("england", 1980)
#' uss_points_per_win(c("england", "england"), c(1980, 1981))
#' @export
#'
uss_points_per_win <- function(country, season) {

  # ref: https://en.wikipedia.org/wiki/Three_points_for_a_win#Year_of_adoption_of_three_points_for_a_win
  season_first_three <- c(
    england = 1981,
    germany = 1995,
    holland = 1995,
    italy = 1994,
    spain = 1995
  )

  # validation!
  country <- tolower(country)

  # warn if country not there

  # vectorize!
  pts_per_win <- rlang::rep_along(country, 3) # default

  pts_per_win[season < season_first_three[country]] <- 2

  as.integer(pts_per_win)
}
