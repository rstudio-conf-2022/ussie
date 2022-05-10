# seasons_intermediate() works

    Code
      dplyr::glimpse(italy)
    Output
      Rows: 50,808
      Columns: 12
      Groups: country, tier, season, team [1,516]
      $ country       <chr> "Italy", "Italy", "Italy", "Italy", "Italy", "Italy", "I~
      $ tier          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,~
      $ season        <int> 1929, 1929, 1929, 1929, 1929, 1929, 1929, 1929, 1929, 19~
      $ team          <chr> "AC Milan", "AC Milan", "AC Milan", "AC Milan", "AC Mila~
      $ date          <date> 1929-10-06, 1929-10-13, 1929-10-20, 1929-10-27, 1929-11~
      $ matches       <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR~
      $ wins          <lgl> TRUE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALS~
      $ draws         <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, F~
      $ losses        <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, TRU~
      $ points        <int> 2, 2, 0, 2, 1, 0, 0, 2, 0, 2, 0, 1, 2, 2, 2, 0, 1, 0, 1,~
      $ goals_for     <int> 4, 1, 1, 3, 1, 1, 1, 2, 1, 5, 0, 1, 3, 1, 2, 1, 2, 1, 1,~
      $ goals_against <int> 1, 0, 2, 1, 1, 2, 4, 1, 3, 2, 1, 1, 2, 0, 1, 2, 2, 4, 1,~

# uss_make_seasons_cumulative() works

    Code
      dplyr::glimpse(italy)
    Output
      Rows: 50,808
      Columns: 12
      Groups: country, tier, season, team [1,516]
      $ country       <chr> "Italy", "Italy", "Italy", "Italy", "Italy", "Italy", "I~
      $ tier          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,~
      $ season        <int> 1929, 1929, 1929, 1929, 1929, 1929, 1929, 1929, 1929, 19~
      $ team          <chr> "AC Milan", "AC Milan", "AC Milan", "AC Milan", "AC Mila~
      $ date          <date> 1929-10-06, 1929-10-13, 1929-10-20, 1929-10-27, 1929-11~
      $ matches       <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1~
      $ wins          <int> 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 5, 5, 6, 7, 8, 8, 8, 8, 8,~
      $ draws         <int> 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4,~
      $ losses        <int> 0, 0, 1, 1, 1, 2, 3, 3, 4, 4, 5, 5, 5, 5, 5, 6, 6, 7, 7,~
      $ points        <int> 2, 4, 4, 6, 7, 7, 7, 9, 9, 11, 11, 12, 14, 16, 18, 18, 1~
      $ goals_for     <int> 4, 5, 6, 9, 10, 11, 12, 14, 15, 20, 20, 21, 24, 25, 27, ~
      $ goals_against <int> 1, 1, 3, 4, 5, 7, 11, 12, 15, 17, 18, 19, 21, 21, 22, 24~

# uss_make_seasons_final() works

    Code
      dplyr::glimpse(italy)
    Output
      Rows: 1,516
      Columns: 12
      Groups: country, tier, season [85]
      $ country       <chr> "Italy", "Italy", "Italy", "Italy", "Italy", "Italy", "I~
      $ tier          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,~
      $ season        <int> 1929, 1929, 1929, 1929, 1929, 1929, 1929, 1929, 1929, 19~
      $ team          <chr> "AC Milan", "AS Roma", "Bologna FC", "Brescia Calcio", "~
      $ date          <date> 1930-07-06, 1930-07-06, 1930-07-06, 1930-07-06, 1930-07~
      $ matches       <int> 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, ~
      $ wins          <int> 11, 15, 14, 13, 11, 20, 22, 19, 10, 11, 12, 12, 14, 16, ~
      $ draws         <int> 10, 6, 8, 7, 4, 8, 6, 7, 8, 8, 6, 9, 9, 7, 8, 8, 5, 6, 7~
      $ losses        <int> 13, 13, 12, 14, 19, 6, 6, 8, 16, 15, 16, 13, 11, 11, 12,~
      $ points        <int> 32, 36, 36, 33, 26, 48, 50, 45, 28, 30, 30, 33, 37, 39, ~
      $ goals_for     <int> 53, 73, 56, 45, 52, 63, 85, 56, 49, 48, 46, 52, 61, 52, ~
      $ goals_against <int> 48, 52, 46, 56, 78, 39, 38, 31, 50, 55, 64, 60, 51, 31, ~

