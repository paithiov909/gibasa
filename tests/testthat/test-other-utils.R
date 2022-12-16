testdata <- readRDS(system.file("testdata/testdata.rda", package = "audubon"))

### is_blank ----
test_that("is_blank works", {
  expect_true(is_blank(NaN))
  expect_true(is_blank(NA_character_))
  expect_true(is_blank(NULL))
  expect_true(is_blank(list()))
  expect_true(is_blank(c()))
  expect_true(is_blank(data.frame()))
  expect_equal(
    c(TRUE, TRUE, TRUE, FALSE),
    is_blank(list(NA_character_, NA_integer_, NULL, "test"))
  )
})

### pack ----
test_that("pack works", {
  res <- pack(testdata[[7]])
  expect_equal(nrow(res), 50L)
})

### prettify ----
test_that("prettify works", {
  skip_on_cran()

  df <- gbs_tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"))
  expect_error(prettify(df, col_select = c(1, 10)))
  expect_equal(ncol(prettify(df)), 13L)
  expect_equal(ncol(prettify(df, col_select = c(1, 2, 3))), 7L)
  expect_equal(ncol(prettify(df, col_select = 1:3)), 7L)
  expect_equal(ncol(prettify(df, col_select = c("POS1", "POS2", "POS3"))), 7L)
})


