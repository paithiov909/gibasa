### bind_lr ----
test_that("bind_lr works", {
  testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))
  res <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    prettify(col_select = "POS1") |>
    dplyr::add_count(doc_id, token) |>
    bind_lr() |>
    dplyr::mutate(lr = dplyr::percent_rank(n * lr))
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
