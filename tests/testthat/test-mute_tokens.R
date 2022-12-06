### mute_tokens ----
test_that("mute_tokens works", {
  skip_on_cran()

  df <-
    tokenize(
      data.frame(
        doc_id = seq_along(audubon::polano[5:8]),
        text = audubon::polano[5:8]
      )
    ) |>
    prettify(col_select = "POS1")
  res <- collapse_tokens(df, POS1 %in% c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"))
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
