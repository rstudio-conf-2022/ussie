# These are created as functions, but we could get away with creating them
# as objects, e.g.:
#
# cols_seasons_grouping <-  c("country", "tier", "season", "team")
#
# I think it's a good idea to write a function because it avoids the build-time
# vs. run-time trap. Let's say we created a stand-alone object in an R/ file:
#
# timestamp <- Sys.time()
#
# Any time we refer to `timestamp` in our package code, it will have the value
# of when the package was *built*, which is likely not what you want. Instead:
#
# timestamp <- function() {
#   Sys.time()
# }
#
# This will be evaluated at run-time, i.e. whenever `timestamp()` is called.
#
# In this case, `Sys.time()` depends on the locale set when it is run, so you
# may wish to take that into account using `withr::with_locale()`.
#
# see: https://r-pkgs.org/package-within.html#package-within-build-time-run-time

cols_engsoc <- function() {
  c("Date", "Season", "home", "visitor", "hgoal", "vgoal", "tier")
}

cols_matches <- function() {
  c("country", "tier", "season", "date", "home",
    "visitor", "goals_home", "goals_visitor")
}

cols_teams_matches <- function() {
  c("country", "tier", "season", "team", "date", "at_home", "opponent",
    "goals_for", "goals_against")
}

cols_seasons <- function() {
  c("country", "tier", "season", "team", "date", "matches", "wins", "draws",
    "losses", "points", "goals_for", "goals_against")
}

cols_seasons_grouping <- function() {
  c("country", "tier", "season", "team")
}

cols_seasons_accumulate <- function() {
  c("matches", "wins", "draws", "losses", "points",
    "goals_for", "goals_against")
}
