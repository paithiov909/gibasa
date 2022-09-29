# skip_on_cran()

expected_res <- readRDS(file.path("../testdata.rda"))

tbl <- testdata[[6]]

test_that("tf*idf works", {
  res <-
    bind_tf_idf2(tbl, tf = "tf", idf = "idf") |>
    dplyr::mutate(tf_idf = n * idf) |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(expected_res[[1]], doc_id, token, tf_idf))
})

test_that("tf2*idf works", {
  res <-
    bind_tf_idf2(tbl, tf = "tf2", idf = "idf") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(expected_res[[2]], doc_id, token, tf_idf))
})

test_that("tf2*idf2 works", {
  res <-
    bind_tf_idf2(tbl, tf = "tf2", idf = "idf2") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(expected_res[[3]], doc_id, token, tf_idf))
})

test_that("tf3*idf works", {
  res <-
    bind_tf_idf2(tbl, tf = "tf3", idf = "idf") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(expected_res[[4]], doc_id, token, tf_idf))
})

test_that("tf2*idf4 works", {
  res <-
    bind_tf_idf2(tbl, tf = "tf2", idf = "idf4") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(expected_res[[5]], doc_id, token, tf_idf))
})
