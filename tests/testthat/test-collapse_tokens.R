### collapse_tokens ----
test_that("collapse_tokens works", {
  testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))
  res <-
    testdata[["tokens"]] |>
    dplyr::slice_head(n = 36) |>
    prettify(col_select = "POS1") |>
    collapse_tokens(POS1 == "\u540d\u8a5e")
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
