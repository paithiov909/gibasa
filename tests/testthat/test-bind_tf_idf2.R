expected_res <- readRDS(file.path("../testdata.rda"))

tbl <-
  data.frame(
    doc_id = seq_along(audubon::polano[1:50]),
    text = audubon::polano[1:50]
  ) |>
  gibasa::tokenize() |>
  gibasa::prettify(col_select = c("POS1", "POS2")) |>
  dplyr::mutate(doc_id = as.character(doc_id),
                POS2 = dplyr::if_else(is.na(POS2), "*", POS2),
                token = stringi::stri_c(token, POS1, POS2, sep = "/")) |>
  dplyr::group_by(doc_id) |>
  dplyr::count(token) |>
  dplyr::ungroup()

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
