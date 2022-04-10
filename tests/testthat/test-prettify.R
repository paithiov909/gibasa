### prettify ----
test_that("prettify works", {
  df <- gbs_tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"))
  expect_error(prettify(df, col_select = c(1, 10)))
  expect_equal(ncol(prettify(df)), 13L)
  expect_equal(ncol(prettify(df, col_select = c(1, 2, 3))), 7L)
  expect_equal(ncol(prettify(df, col_select = 1:3)), 7L)
  expect_equal(ncol(prettify(df, col_select = c("POS1", "POS2", "POS3"))), 7L)
})

### get_dict_features ----
test_that("get_dict_features works", {
  expect_equal(length(get_dict_features()), 9L)
  expect_equal(length(get_dict_features("unidic17")), 17L)
  expect_equal(length(get_dict_features("unidic26")), 26L)
  expect_equal(length(get_dict_features("unidic29")), 29L)
  expect_equal(length(get_dict_features("cc-cedict")), 8L)
  expect_equal(length(get_dict_features("ko-dic")), 8L)
  expect_equal(length(get_dict_features("naist11")), 11L)
})
