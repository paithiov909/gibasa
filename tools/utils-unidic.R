#' List of available 'UniDic'
unidic_availables <- function() {
  jsonlite::read_json(
    "https://raw.githubusercontent.com/polm/unidic-py/master/dicts.json"
  )
}

#' Download and unzip 'UniDic'
#'
#' Download 'UniDic' of specified version into `dirname`.
#' This function is partial port of \href{https://github.com/polm/unidic-py}{polm/unidic-py}.
#' Note that to unzip dictionary will take up 770MB on disk after downloading.
#'
#' @param version String; version of 'UniDic'.
#' @param dirname String; directory where unzip the dictionary.
#' @return full path to `dirname` is returned invisibly.
download_unidic <- function(version = "latest", dirname = "unidic") {
  json <- unidic_availables()
  version <- rlang::arg_match(version, values = names(json))

  if (yesno::yesno(sprintf("Download UniDic version %s ?", version))) {
    rlang::inform(
      sprintf("Downloading UniDic version %s ...", version)
    )
    temp <- tempfile(fileext = ".zip")
    utils::download.file(json[[version]]$url, temp)
    utils::unzip(temp, exdir = file.path(dirname))
  }
  on.exit(
    rlang::inform(
      sprintf("Downloaded UniDic version %s", version)
    )
  )
  return(invisible(file.path(dirname)))
}
