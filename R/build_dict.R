#' Build system dictionary
#'
#' Build a UTF-8 system dictionary from source dictionary files.
#'
#' @details
#' This function is a wrapper around dictionary compiler of mecab.
#'
#' Running this function will create 4 files:
#' 'char.bin', 'matrix.bin', 'sys.dic', and 'unk.dic' in `out_dir`.
#' To use these compiled dictionary, you also need create a `dicrc` file to `out_dir`.
#' A `dicrc` file is included in source dictionaries, so you can just copy it to `out_dir`.
#'
#' @inheritParams dict_index_sys
#' @returns A `TRUE` is invisibly returned if dictionary is successfully built.
#' @export
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
#' Build a UTF-8 user dictionary from a csv file.
#'
#' @details
#' This function is a wrapper around dictionary compiler of mecab.
#'
#' Note that this function does not support auto assignment of word cost field.
#' So, you can't leave any word costs as empty in your input csv file.
#' To assume word costs, use \code{posDebugRcpp()} function.
#'
#' @inheritParams dict_index_user
#' @returns A `TRUE` is invisibly returned if dictionary is successfully built.
#' @export
build_user_dic <- function(dic_dir, file, csv_file, encoding) {
  cond <- dict_index_user(
    dic_dir = path.expand(dic_dir),
    file = path.expand(file),
    csv_file = path.expand(csv_file),
    encoding = encoding
  )
  return(invisible(cond))
}
