VERSION <- commandArgs(TRUE)
if (!dir.exists(sprintf("../windows/libmecab-%s", VERSION))) {
  if (getRversion() < "3.3.0") setInternet2()
  download.file(sprintf("https://github.com/paithiov909/libmecab/archive/refs/tags/v%s.zip", VERSION), "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
