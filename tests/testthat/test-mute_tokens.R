### mute_tokens ----
test_that("mute_tokens works", {
  testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))
  res <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    prettify(col_select = "POS1") |>
    mute_tokens(POS1 %in% c("\u52a9\u8a5e", "\u52a9\u52d5\u8a5e"))
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
