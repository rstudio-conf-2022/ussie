uss_countries <- function() {
  c("england", "germany", "holland", "italy", "spain")
}

get_soccer_data <- function(country) {
  e <- new.env()
  name <- utils::data(list = country, package = "engsoccerdata", envir = e)[1]
  e[[name]]
}

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
      date = as.Date(.data$Date),
      season = as.integer(.data$Season),
      tier = as.integer(.data$tier),
      home = as.character(.data$home),
      visitor = as.character(.data$visitor),
      goals_home = as.integer(.data$hgoal),
      goals_visitor = as.integer(.data$vgoal)
    )

  result
}

uss_get_games <- function(country = uss_countries()) {
  country <- rlang::arg_match(country)

  data <- get_soccer_data(country)

  uss_make_games(data, country)
}
