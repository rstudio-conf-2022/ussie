# Adapted from:
#   https://testthat.r-lib.org/reference/expect_snapshot_file.html
#
# The big changes here are:
#  - using ggsave, withr functions
#  - do everything in one function
#
# Question: could a function like this be useful as a part of ggplot2?
#
expect_snapshot_ggplot <- function(name, code, width = 4, height = 4) {
  
  # Other packages might affect results
  testthat::skip_if_not_installed("ggplot2", "2.0.0")
  
  testthat::skip_on_ci()
  
  name <- paste0(name, ".png")
  
  # Announce the file before touching `code`. This way, if `code`
  # unexpectedly fails or skips, testthat will not auto-delete the
  # corresponding snapshot file.
  testthat::announce_snapshot_file(name = name)
  
  # temp file at `path` deleted when `expect_snapshot_plot()` exits
  path <- withr::local_tempfile(fileext = ".png")
  
  # ggsave() uses inches for `width`, `height`
  ggplot2::ggsave(path, plot = code, width = width, height = height)
  
  testthat::expect_snapshot_file(path, name)
}