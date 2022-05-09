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

  points <- uss_points_per_win(country, season) * wins + draws

  points
}

#' @rdname uss_points
#' @export
#'
uss_points_per_win <- function(country, season) {

  # ref: https://en.wikipedia.org/wiki/Three_points_for_a_win#Year_of_adoption_of_three_points_for_a_win
  season_first_three <- list(
    england = 1981,
    germany = 1995,
    holland = 1995,
    italy = 1994,
    spain = 1995
  )

  pts_per_win <- 3
  if (!country %in% names(season_first_three)) {
    # TODO: use cli::cli_warn()
    warning("country not in countries, returning 3")
    return (pts_per_win)
  }

  if (season < season_first_three[country]) {
    pts_per_win <- 2
  }

  pts_per_win
}
