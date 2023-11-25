testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))

### pack ----
test_that("pack works", {
  res <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    pack()
  expect_equal(nrow(res), 4L)
  res <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    pack(token)
  expect_equal(nrow(res), 4L)
})

test_that("packing into ngrams works", {
  res <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    pack(n = 2)
  expect_snapshot_value(res, style = "json2", cran = FALSE)
})
