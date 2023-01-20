testdata <- readRDS(system.file("testdata/testdata.rda", package = "audubon"))

### as_tokens ----
test_that("as_tokens works", {
  skip_on_cran()

  lst <-
    tokenize(
      data.frame(
        doc_id = factor("text1"),
        text = c("\u3053\u3093\u306b\u3061\u306f")
      )
    ) |>
    prettify(col_select = 1) |>
    as_tokens()
  expect_named(lst, "text1")
})

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

### dictionary_info ----
test_that("dictionary_info works", {
  skip_on_cran()

  res <- dictionary_info()
  expect_s3_class(res, "data.frame")
  expect_equal(ncol(res), 7L)
})

### transition_cost ----
test_that("transition_cost works", {
  skip_on_cran()

  expect_type(get_transition_cost(0, 0), "integer")
  expect_error(get_transition_cost(-1, 0))
  expect_error(get_transition_cost(1318, 0))
})

### pack ----
test_that("pack works", {
  res <- pack(testdata[[7]])
  expect_equal(nrow(res), 50L)
})

### prettify ----
test_that("prettify works", {
  skip_on_cran()

  df <- tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"))
  expect_error(prettify(df, col_select = c(1, 10)))
  expect_equal(ncol(prettify(df)), 13L)
  expect_equal(ncol(prettify(df, col_select = c(1, 2, 3))), 7L)
  expect_equal(ncol(prettify(df, col_select = 1:3)), 7L)
  expect_equal(ncol(prettify(df, col_select = c("POS1", "POS2", "POS3"))), 7L)
})
