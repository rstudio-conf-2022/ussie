.onLoad <- function(libname, pkgname) {
  uss_get_games <<- memoise::memoise(uss_get_games)
}
