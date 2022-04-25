validate_data_frame <- function(.data) {

  # predicate
  if (!is.data.frame(.data)) {
    cli::cli_abort(
      # information for user
      c(
        "Must supply a data frame",
        x = "You have supplied a {.cls {class(.data)}}."
      ),
      # information for developer
      class_data = class(.data),
      class = "ussie_error_data_frame",
      # tell user about calling-function, not this one
      call = rlang::caller_env()
    )
  }

  invisible(.data)
}

validate_cols <- function(.data, cols_req) {

  cols_data <- names(.data)
  cols_missing <- cols_req[!(cols_req %in% cols_data)]

  # predicate
  if (length(cols_missing) > 0) {
    # quantities for formatting
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
