local_warn_partial_match <- function(.local_envir = parent.frame()) {

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
}
