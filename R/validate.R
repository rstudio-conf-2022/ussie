#' Validate object as data frame
#'
#' If `.data` is not a data frame, throw an error.
#'
#' @param .data object that inherits from `data.frame`
#'
#' @return Invisible `.data`, called for side-effects.
#' @examples
#' # success :)
#' validate_data_frame(mtcars)
#'
#' # failure :(
#' \dontrun{
#'   validate_data_frame(3)
#' }
#'
#' @noRd
#'
validate_data_frame <- function(.data) {

  # https://cli.r-lib.org/reference/cli_abort.html
  # https://rlang.r-lib.org/reference/abort.html
  #
  # When managing an error, you'll need:
  #  - a predicate
  #    - specify the condition that that initiates the error
  #  - information for user:
  #    - message to print to screen, cli offers formatting tools
  #  - information for developer:
  #    - class: use pattern `<package>_error_<description>`
  #    - other information:
  #        - use to illuminate the predicate
  #        - named items
  #         - reserved: message, class, call, body, footer, trace, parent,
  #                     use_cli_format
  #  - if using from a validation-function (like this)
  #    - use `call = rlang::caller_env()` to tell user about calling function
  #    - return the "thing" you're checking, invisibly
  #
  # potential to update tidyverse design giude:
  #  - https://design.tidyverse.org/err-constructor.html#error-hierarchies

  # predicate
  if (!is.data.frame(.data)) {
    cli::cli_abort(
      # information for user
      c(
        "Must supply a data frame",
        x = "You have supplied a {.cls {class(.data)}}."
      ),
      # information for developer
      class = "ussie_error_data",
      class_data = class(.data),
      # tell user about calling-function, not this one
      call = rlang::caller_env()
    )
  }

  invisible(.data)
}

#  inherit documentation from other functions:
#    https://roxygen2.r-lib.org/articles/rd.html#inheriting-documentation-from-other-topics

#' Validate column-names of data frame
#'
#' If `.data` does not have columns, throw an error.
#'
#' @inherit validate_data_frame params return
#' @param cols_req `character`, name(s) of required columns for `.data`
#'
#' @return Invisible `.data`, called for side-effects.
#' @examples
#' # success :)
#' validate_cols(mtcars, cols_req = c("wt", "mpg"))
#'
#' # failure :(
#' \dontrun{
#'   validate_cols(mtcars, cols_req = c("bill_length_mm"))
#' }
#'
#' @noRd
#'
validate_cols <- function(.data, cols_req) {

  cols_data <- names(.data)
  cols_missing <- cols_req[!(cols_req %in% cols_data)]

  # predicate
  if (length(cols_missing) > 0) {

    # helper function to format quantities
    # - see https://cli.r-lib.org/articles/pluralization.html
    qlen <- function(x) cli::qty(length(x))

    cli::cli_abort(
      # information for user
      c(
        "Data frame needs {qlen(cols_req)} column{?s}: {.var {cols_req}}",
        i = "Has {qlen(cols_data)} column{?s}: {.var {cols_data}}",
        x = "Missing {qlen(cols_missing)} column{?s}: {.var {cols_missing}}"
      ),
      # information for developer
      cols_req = cols_req,
      cols_data = cols_data,
      class = "ussie_error_cols",
      # tell user about calling-function, not this one
      call = rlang::caller_env()
    )
  }

  invisible(.data)
}
