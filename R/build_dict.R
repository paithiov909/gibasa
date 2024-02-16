#' Build system dictionary
#'
#' Builds a UTF-8 system dictionary from source dictionary files.
#'
#' @details
#' This function is a wrapper around dictionary compiler of 'MeCab'.
#'
#' Running this function will create 4 files:
#' 'char.bin', 'matrix.bin', 'sys.dic', and 'unk.dic' in `out_dir`.
#'
#' To use these compiled dictionary,
#' you also need create a `dicrc` file in `out_dir`.
#' A `dicrc` file is included in source dictionaries,
#' so you can just copy it to `out_dir`.
#'
#' @inheritParams dict_index_sys
#' @returns A `TRUE` is invisibly returned if dictionary is successfully built.
#' @export
#' @examples
#' \donttest{
#' if (requireNamespace("withr")) {
#'   # create a sample dictionary in temporary directory
#'   build_sys_dic(
#'     dic_dir = system.file("latin", package = "gibasa"),
#'     out_dir = tempdir(),
#'     encoding = "utf8"
#'   )
#'   # copy the 'dicrc' file
#'   file.copy(
#'     system.file("latin/dicrc", package = "gibasa"),
#'     tempdir()
#'   )
#'   # mocking a 'mecabrc' file to temporarily use the dictionary
#'   withr::with_envvar(
#'     c(
#'       "MECABRC" = if (.Platform$OS.type == "windows") {
#'         "nul"
#'       } else {
#'         "/dev/null"
#'       },
#'       "RCPP_PARALLEL_BACKEND" = "tinythread"
#'     ),
#'     {
#'       tokenize("katta-wokattauresikatta", sys_dic = tempdir())
#'     }
#'   )
#' }
#' }
build_sys_dic <- function(dic_dir, out_dir, encoding) {
  cond <- dict_index_sys(
    dic_dir = path.expand(dic_dir),
    out_dir = path.expand(out_dir),
    encoding = encoding
  )
  return(invisible(cond))
}

#' Build user dictionary
#'
#' Builds a UTF-8 user dictionary from a csv file.
#'
#' @details
#' This function is a wrapper around dictionary compiler of 'MeCab'.
#'
#' Note that this function does not support auto assignment of word cost field.
#' So, you can't leave any word costs as empty in your input csv file.
#' To estimate word costs, use \code{posDebugRcpp()} function.
#'
#' @inheritParams dict_index_user
#' @returns A `TRUE` is invisibly returned if dictionary is successfully built.
#' @export
#' @examples
#' \donttest{
#' if (requireNamespace("withr")) {
#'   # create a sample dictionary in temporary directory
#'   build_sys_dic(
#'     dic_dir = system.file("latin", package = "gibasa"),
#'     out_dir = tempdir(),
#'     encoding = "utf8"
#'   )
#'   # copy the 'dicrc' file
#'   file.copy(
#'     system.file("latin/dicrc", package = "gibasa"),
#'     tempdir()
#'   )
#'   # write a csv file and compile it into a user dictionary
#'   csv_file <- tempfile(fileext = ".csv")
#'   writeLines(
#'     c(
#'       "qa, 0, 0, 5, \u304f\u3041",
#'       "qi, 0, 0, 5, \u304f\u3043",
#'       "qu, 0, 0, 5, \u304f",
#'       "qe, 0, 0, 5, \u304f\u3047",
#'       "qo, 0, 0, 5, \u304f\u3049"
#'     ),
#'     csv_file
#'   )
#'   build_user_dic(
#'     dic_dir = tempdir(),
#'     file = (user_dic <- tempfile(fileext = ".dic")),
#'     csv_file = csv_file,
#'     encoding = "utf8"
#'   )
#'   # mocking a 'mecabrc' file to temporarily use the dictionary
#'   withr::with_envvar(
#'     c(
#'       "MECABRC" = if (.Platform$OS.type == "windows") {
#'         "nul"
#'       } else {
#'         "/dev/null"
#'       },
#'       "RCPP_PARALLEL_BACKEND" = "tinythread"
#'     ),
#'     {
#'       tokenize("quensan", sys_dic = tempdir(), user_dic = user_dic)
#'     }
#'   )
#' }
#' }
build_user_dic <- function(dic_dir, file, csv_file, encoding) {
  cond <- dict_index_user(
    dic_dir = path.expand(dic_dir),
    file = path.expand(file),
    csv_file = path.expand(csv_file),
    encoding = encoding
  )
  return(invisible(cond))
}
