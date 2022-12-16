df <- data.frame(doc_id = seq_along(audubon::polano[1:50]), audubon::polano[1:50])

testdata <-
  purrr::imap(c("tf*idf", "tf2*idf", "tf2*idf2",
                "tf3*idf", "tf2*idf3", "tf2*idf4"),
              \(w, i) {
    rmecab_res <- RMeCab::docDF(df, column = 2, type = 1, Genkei = 1, weight = w)
    rmecab_res |>
      tidyr::pivot_longer(cols = starts_with("Row"),
                          names_to = "doc_id",
                          values_to = "tf_idf",
                          names_transform = function(.x) { stringr::str_remove(.x, "Row") },
                          values_transform = list(tf_idf = function(.x){ ifelse(.x == 0, NA_integer_, .x) }),
                          values_drop_na = TRUE) |>
      dplyr::mutate(token = stringr::str_c(TERM, POS1, POS2, sep = "/")) |>
      dplyr::select(doc_id, token, tf_idf) |>
      dplyr::arrange(doc_id, token, tf_idf)
  })

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

testdata[[7]] <- tbl

saveRDS(testdata, "testdata.rda")
