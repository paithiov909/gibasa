testdata <- readRDS(system.file("testdata/testdata.rda", package = "gibasa"))

df <- testdata[[7]]

### tf*idf ----
test_that("tf*idf works", {
  res <-
    bind_tf_idf2(df, tf = "tf", idf = "idf") |>
    dplyr::mutate(tf_idf = n * idf) |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(testdata[["tf*idf"]], doc_id, token, tf_idf))
})

### tf2*idf ----
test_that("tf2*idf works", {
  res <-
    bind_tf_idf2(df, tf = "tf2", idf = "idf") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(testdata[["tf2*idf"]], doc_id, token, tf_idf))
})

### tf2*idf2 ----
test_that("tf2*idf2 works", {
  res <-
    bind_tf_idf2(df, tf = "tf2", idf = "idf2") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(testdata[["tf2*idf2"]], doc_id, token, tf_idf))
})

### tf3*idf ----
test_that("tf3*idf works", {
  res <-
    bind_tf_idf2(df, tf = "tf3", idf = "idf") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(testdata[["tf3*idf"]], doc_id, token, tf_idf))
})

### tf2*idf3 ----
test_that("tf2*idf3 works", {
  res <-
    bind_tf_idf2(df, tf = "tf2", idf = "idf3") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(testdata[["tf2*idf3"]], doc_id, token, tf_idf))
})

### tf2*idf4 ----
test_that("tf2*idf4 works", {
  res <-
    bind_tf_idf2(df, tf = "tf2", idf = "idf4") |>
    dplyr::select(doc_id, token, tf_idf) |>
    dplyr::arrange(doc_id, token, tf_idf)
  expect_equal(res, dplyr::arrange(testdata[["tf2*idf4"]], doc_id, token, tf_idf))
})
