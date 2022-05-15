uss_plot_seasons_tiers <- function(data_seasons, aes_y = .data$wins, ncol = 1) {

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
    # force() is a base function
    # see: https://github.com/tidyverse/ggplot2/issues/4511#issuecomment-866185530
    ggplot2::scale_alpha_manual(
      values = c(`1` = 0.1, `2` = 0.3, `3` = 0.5, `4` = 0.7),
      limits = force
    ) +
    ggplot2::facet_wrap(ggplot2::vars(.data$team), ncol = ncol)

}
