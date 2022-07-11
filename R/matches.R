#' Make a standard league-play tibble
#'
#' Given a league-play data frame from {engsoccer}, returns a tibble with
#' standardised colomn-names and types, e.g. `date` is a `Date`.
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
#' @keywords internal
#' @export
#'
uss_make_matches <- function(data_engsoc, country) {
  
  # validate
  validate_data_frame(data_engsoc)
  validate_cols(data_engsoc, cols_engsoc())
  
  # put into "standard" form
  result <-
    data_engsoc |>
    tibble::as_tibble() |>
    dplyr::transmute(
      country = as.character(.env$country),
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