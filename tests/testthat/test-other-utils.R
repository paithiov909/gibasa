skip_if_no_dict <- function() {
  dict <- suppressWarnings(dictionary_info())
  skip_if(
    nrow(dict) < 1L,
    "There are no available dictionaries."
  )
}
testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))

### as_tokens ----
test_that("as_tokens works", {
  lst1 <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    prettify(col_select = 1) |>
    as_tokens()

  lst2 <-
    testdata[["tokens"]] |>
    dplyr::filter(as.integer(doc_id) < 5) |>
    prettify(col_select = 1) |>
    as_tokens(token)

  expect_equal(lst1, lst2)
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

### transition_cost ----
test_that("transition_cost works", {
  skip_on_cran()
  skip_if_no_dict()

  expect_type(get_transition_cost(0, 0), "integer")
  expect_error(get_transition_cost(-1, 0))
  expect_error(get_transition_cost(1318, 0))
})
test_that("transition_cost fails", {
  skip_on_cran()
  expect_error(suppressWarnings(
    get_transition_cost(0, 0, sys_dic = "/dict/dir/doesnt/exist")
  ))
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
  expect_equal(length(get_dict_features("sudachi")), 9L)
})
