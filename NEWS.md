# gibasa (development version)

* Added a new function `lex_deinsity` that can calculate lexical density
for dataset.

# gibasa 0.5.0

* gibasa now includes the MeCab source, so that users do not need to pre-install the MeCab library when building and installing the package (to use `tokenize` without specifying dictionaries, it still requires MeCab and its dictionaries installed and available).

# gibasa 0.4.1

* `tokenize` now preserves the original order of `docid_field`.

# gibasa 0.4.0

* Added `bind_tf_idf2` function and `is_blank` function.

# gibasa 0.3.1

* Updated dependencies.

# gibasa 0.3.0

* Changed build process on Windows.
* Added a vignette.

# gibasa 0.2.1

* `prettify` now can extract columns only specified by `col_select`.

# gibasa 0.2.0

* Added a `NEWS.md` file to track changes to the package.
* `tokenize` now gets a data.frame as its first argument, returns a data.frame only. The former function that gets character vector and returns a data.frame or named list was renamed as `gbs_tokenize`.
