.onLoad <- function(libname, pkgname) {

  # https://r-pkgs.org/r.html#when-you-do-need-side-effects
  #
  # .onLoad() is used to manage side-effects when your package is loaded.
  #
  # https://memoise.r-lib.org/reference/memoise.html
  #
  # The side-effect we're using here is to memoise uss_get_games():
  #
  # Whenever we call the memoised version, it:
  #  - keeps track of the input arguments
  #  - caches the result
  #  - returns the cached result whenever we call using the same input args

  uss_make_games <<- memoise::memoise(uss_make_games)
}
