### tokenize ----
test_that("tokenize for character vector works", {
  skip_on_cran()

  df <- tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"))
  expect_s3_class(df$doc_id, "factor")
  expect_equal(df[[1]][1], factor("text1"))
  expect_equal(df$token[1], "\u3053\u3093\u306b\u3061\u306f")

  lst <- tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"), mode = "wakati")
  expect_named(lst, "text1")
})

test_that("tokenize for data.frame works", {
  skip_on_cran()

  df <- tokenize(
    data.frame(
      doc_id = c(1),
      text = c("\u3053\u3093\u306b\u3061\u306f")
    )
  )
  expect_s3_class(df$doc_id, "factor")
  expect_equal(df[[1]][1], factor("1"))
  expect_equal(df$token[1], "\u3053\u3093\u306b\u3061\u306f")

  lst <- tokenize(
    data.frame(
      doc_id = factor("text1"),
      text = c("\u3053\u3093\u306b\u3061\u306f")
    ),
    split = TRUE,
    mode = "wakati"
  )
  expect_named(lst, "text1")
})
