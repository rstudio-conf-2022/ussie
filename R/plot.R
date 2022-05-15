#' Plot over season-final results
#'
#' Returns a ggplot:
#'  - `season` on the x-axis
#'  - faceted by `team`
#'  - has two layers:
#'    - rectangles shaded by tier
#'    - points showing some measure (default `wins`) on the y-axis
#'
#' @param data_seasons, data frame created using [uss_make_seasons_final()].
#' @param aes_y, `<data-masking>` expression used for the y-aesthetic.
#' @param ncol, `integer`-ish number of columns in facet.
#'
#' @return Object with S3 classes `"gg"`, `"ggplot"`, i.e. a ggplot2 object.
#' @examples
#' leeds_norwich <-
#'   uss_get_matches("england") |>
#'   uss_make_teams_matches() |>
#'   dplyr::filter(team %in% c("Leeds United", "Norwich City")) |>
#'   uss_make_seasons_final() |>
#'   dplyr::arrange(team, season)
#'
#' # use default (wins)
#' uss_plot_seasons_tiers(leeds_norwich)
#'
#' # use custom expression
#' uss_plot_seasons_tiers(leeds_norwich, goals_for - goals_against)
#' @export
#'
uss_plot_seasons_tiers <- function(data_seasons, aes_y = .data$wins, ncol = 1) {

  validate_data_frame(data_seasons)
  validate_cols(data_seasons, cols_seasons())

  ggplot2::ggplot(data_seasons) +
    ggplot2::geom_rect(
      ggplot2::aes(
        xmin = .data$season - 0.5,
        xmax = .data$season + 0.5,
        alpha = .data$tier
      ),
      ymin = -Inf,
      ymax = Inf,
      fill = "#0B6603"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(
        x = .data$season,
        y = {{ aes_y }}
      ),
      color = "#333333"
    ) +
    # we want to show only the tiers that appear in the data
    # force() is a base function
    # see: https://github.com/tidyverse/ggplot2/issues/4511#issuecomment-866185530
    ggplot2::scale_alpha_manual(
      values = c(`1` = 0.1, `2` = 0.3, `3` = 0.5, `4` = 0.7),
      limits = force
    ) +
    ggplot2::facet_wrap(ggplot2::vars(.data$team), ncol = ncol)

}
