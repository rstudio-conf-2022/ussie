local_warn_partial_match <- function(.local_envir = parent.frame()) {

  # This is a trick to get around an anomaly in the option named
  # "warnPartialMatchDollar"
  #
  # In R 4.2.0, if you set the option to `TRUE`, then to `NULL`, it acts
  # as if it is still `TRUE`. In my mind, `NULL` is equivalent to `FALSE`,
  # so I set them explicity to `FALSE` if they are NULL.
  #
  # see https://github.com/HenrikBengtsson/Wishlist-for-R/issues/134

  # side-effect: if option with `name` is `NULL`, set it to `FALSE`
  set_false_if_option_null <- function(name) {
    if (is.null(getOption(name))) {
      lst <- list()
      lst[[name]] <- FALSE
      options(lst)
    }

    invisible(name)
  }

  set_false_if_option_null("warnPartialMatchDollar")
  set_false_if_option_null("warnPartialMatchArgs")
  set_false_if_option_null("warnPartialMatchAttr")

  # there's a lot of withr::local_*() functions available
  #  - roll your own only if you need to
  #  - https://testthat.r-lib.org/articles/test-fixtures.html

  withr::local_options(

    # set these options
    list(
      warnPartialMatchDollar = TRUE,
      warnPartialMatchArgs = TRUE,
      warnPartialMatchAttr = TRUE
    ),
    # reset when this environment exits
    #  - by default, the environment from which *this* function was called
    .local_envir = .local_envir
  )

  invisible(NULL)
}
