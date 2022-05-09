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
