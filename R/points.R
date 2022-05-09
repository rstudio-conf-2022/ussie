#' Calculate points
#'
#' @param wins `integer`-ish number of wins
#' @param draws `integer`-ish number of draws
#' @inheritParams uss_make_matches
#' @param season `integer`-ish year of the football season.
#'
#' @return `double`:
#' \describe{
#'   \item{`uss_points()`}{number of points}
#'   \item{`uss_points_per_win()`}{number of points per win}
#' }
#' @examples
#' uss_points_per_win("england", 1980)
#' uss_points(3, 1, country = "england", season = 1980)
#' @export
#'
uss_points <- function(wins, draws, country = NULL, season = NULL) {

  # note: need additional arg for points_per_win function
  points <- uss_points_per_win(country, season) * wins + draws

  points
}

#' @rdname uss_points
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
