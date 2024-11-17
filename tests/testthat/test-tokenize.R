skip_if_no_dict <- function() {
  dict <- suppressWarnings(dictionary_info())
  skip_if(
    nrow(dict) < 1L,
    "There are no available dictionaries."
  )
}

### tokenize ----
test_that("tokenize fails", {
  skip_on_cran()
  withr::with_envvar(
    c("MECABRC" = if (.Platform$OS.type == "windows") {
      "nul"
    } else {
      "/dev/null"
    }),
    {
      expect_error(suppressWarnings(
        tokenize(character(0), sys_dic = "/dict/dir/doesnt/exist")
      ))
    }
  )
})

test_that("tokenize warns if invalid strings are passed", {
  skip_on_cran()
  skip_if_no_dict()

  ## These behaviors are derived from a bug of MeCab.
  ## A sentence fragment before a morpheme fragment cannot end with spaces.
  expect_warning(
    ## Suppressing messages from 'Rcerr'
    capture.output(
      {
        invisible(tokenize("aaa \nbbb\tTAG", partial = TRUE))
      },
      type = "message"
    )
  )
})

test_that("tokenize for character vector works", {
  skip_on_cran()
  skip_if_no_dict()

  df <- tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"))
  expect_s3_class(df$doc_id, "factor")
  expect_equal(df[[1]][1], factor("text1"))
  expect_equal(df$token[1], "\u3053\u3093\u306b\u3061\u306f")

  lst <- tokenize(c(text1 = "\u3053\u3093\u306b\u3061\u306f"), mode = "wakati")
  expect_named(lst, "text1")
})

test_that("tokenize for data.frame works", {
  skip_on_cran()
  skip_if_no_dict()

  df <- tokenize(
    data.frame(
      doc_id = c(1),
      text = c("\u3053\u3093\u306b\u3061\u306f")
    ),
    text_field = text,
    docid_field = doc_id
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
