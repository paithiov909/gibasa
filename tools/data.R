ginga <-
  ldccr::read_aozora(
    "https://www.aozora.gr.jp/cards/000081/files/43737_ruby_19028.zip",
    directory = tempdir()
  ) |>
  readr::read_lines()

usethis::use_data(ginga)
