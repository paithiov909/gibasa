### prettify ----
test_that("prettify works", {
  testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))
  df <- testdata[["tokens"]]
  expect_error(prettify(df, col_select = c(1, 10)))
  expect_equal(ncol(prettify(df)), 13L)
  expect_equal(ncol(prettify(df, col_select = c(1, 2, 3))), 7L)
  expect_equal(ncol(prettify(df, col_select = 1:3)), 7L)
  expect_equal(ncol(prettify(df, col_select = c("POS1", "POS2", "POS3"))), 7L)
})
