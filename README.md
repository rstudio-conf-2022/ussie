
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ussie

<!-- badges: start -->

[![R-CMD-check](https://github.com/ijlyttle/ussie/workflows/R-CMD-check/badge.svg)](https://github.com/ijlyttle/ussie/actions)
<!-- badges: end -->

The goal of ussie is to make a first attempt at a demo package for folks
to build for the “Building Tidy Tools” course at rstudio::conf(2022L).

## Installation

You can install the development version of ussie from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ijlyttle/ussie")
```

## Notes

I want to note the functions that I used to manage the development of
this package:

[Package-development
setup](https://r-pkgs.org/setup.html#personal-startup-configuration):

-   `usethis::edit_r_profile()`

[Git setup](https://r-pkgs.org/git.html#git-setup) - good for git setup,
but current tidyverse recommendation is to use https rather than ssh:

-   `gert::git_config_global_set()` can use for `"user.name"`,
    `"user.email"`
-   `usethis::git_vaccinate()`
-   `usethis::git_default_branch_configure()` set default for future
    repos
    -   `usethis::git_default_branch_rename()` rename default branch of
        existing repo

[GitHub setup](https://usethis.r-lib.org/articles/git-credentials.html):

-   `usethis::create_github_token()`
-   `gitcreds::gitcreds_set()`

Verification:

-   `usethis::git_sitrep()`

Development:

-   `usethis::create_package()`
-   `usethis::use_git()`
-   `usethis::use_github()`
-   `usethis::use_readme_rmd()`
-   `usethis::use_package()`
-   `usethis::use_test()`
-   `usethis::use_github_action_check_release()` minimal check
    -   `usethis::use_github_action_check__standard()` if thinking of
        CRAN
-   `usethis::use_tidy_eval()`
-   `usethis::use_package_doc()`, then `usethis::use_tibble()` - so this
    may have to be earlier in the process.
-   `usethis::use_pkgdown()`, `usethis::use_github_action("pkgdown")`
