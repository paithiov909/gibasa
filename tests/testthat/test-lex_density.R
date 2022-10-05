skip_on_cran()

test_that("lex_density works", {
  res <-
    tokenize(
      data.frame(
        doc_id = seq_along(audubon::polano[5:8]),
        text = audubon::polano[5:8]
      )
    ) |>
    prettify(col_select = "POS1") |>
    dplyr::group_by(doc_id) |>
    dplyr::summarise(
      noun_ratio = lex_density(POS1,
        "\u540d\u8a5e",
        c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"),
        negate = c(FALSE, TRUE)
      )
    )
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
