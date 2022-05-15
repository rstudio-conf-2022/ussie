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
      )
    ) +
    ggplot2::facet_wrap(ggplot2::vars(.data$team), ncol = ncol)

}
