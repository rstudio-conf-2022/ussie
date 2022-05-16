# ussie 0.0.0.9000

* Added function to plot values over seasons: `uss_plot_seasons_tiers()` (#7)

* Added functions to calculate performance over a season: `uss_make_seasons_cumulative()`, `uss_make_seasons_final()`, and a helper `uss_points_per_win()`. (#5)

* Added `uss_make_teams_matches()` to convert a `matches` tibble to a `teams-matches` tibble. (#1)

* Changed `_games` to `_matches`, e.g. `uss_make_matches()`. (#2)

* Added a `NEWS.md` file to track changes to the package.
