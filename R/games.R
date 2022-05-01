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

get_soccer_data <- function(country) {
  e <- new.env()
  name <- utils::data(list = country, package = "engsoccerdata", envir = e)[1]
  e[[name]]
}

# trick to let R CMD CHECK know that we are using
# engsoccerdata
best_wins_leeds <- function(n = 10, type = NULL) {
  engsoccerdata::bestwins(
    engsoccerdata::england,
    teamname = "Leeds United",
    type = type,
    N = n
  )
}

#' Make a standard league-play tibble
#'
#' @param data_engsoc `data.frame` obtained from {engsoccerdata}.
#' @param country `character` scalar, used to populate `country` column
#'
#' @return `tbl_df` with columns `country`, `date`, `season`, `tier`,
#'   `home`, `visitor`, `goals_home`, `goals_visitor`.
#'
#' @examples
#' uss_make_games(engsoccerdata::italy, "Italy")
#' @keywords internal
#' @export
#'
uss_make_games <- function(data_engsoc, country) {

  # validate
  validate_data_frame(data_engsoc)
  validate_cols(
    data_engsoc,
    c("Date", "Season", "home", "visitor", "hgoal", "vgoal", "tier")
  )

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

# internal function, placeholder for memoise
uss_make_games_mem <- function(data_engsoc, country) {
  uss_make_games(data_engsoc, country)
}

#' Get a league-play tibble
#'
#' @inherit uss_make_games params return
#'
#' @examples
#' uss_get_games("england")
#' @export
#'
uss_get_games <- function(country = uss_countries()) {

  country <- rlang::arg_match(country)

  data <- get_soccer_data(country)

  # capitalize
  substr(country, 1, 1) <- toupper(substr(country, 1, 1))

  uss_make_games_mem(data, country)
}
