skip_on_cran()
skip_on_os("mac")

### gbs_tokenize ----
test_that("gbs_tokenize works", {
  df <- gbs_tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"))
  expect_s3_class(df$doc_id, "factor")
  expect_equal(df[1, 1], factor("text1"))
  expect_equal(df$token[1], "\u3053\u3093\u306b\u3061\u306f")

  vec <- gbs_tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"), mode = "wakati")
  expect_equal(names(vec), c("text1"))
})

### tokenize ----
test_that("tokenize works", {
  df <- tokenize(
    data.frame(
      doc_id = c(1),
      text = c("\u3053\u3093\u306b\u3061\u306f")
    )
  )
  expect_s3_class(df$doc_id, "factor")
  expect_equal(df[1, 1], factor("1"))
  expect_equal(df$token[1], "\u3053\u3093\u306b\u3061\u306f")
})
