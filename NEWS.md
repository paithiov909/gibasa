# gibasa 0.6.0

* Functions added in version '0.5.1' was moved to 'audubon' package (>= 0.4.0).

# gibasa 0.5.1

* Added some new functions.
  * `bind_tf_idf2` can calculate and bind the term frequency, inverse document frequency, and tf-idf of the tidy text dataset.
  * `collapse_tokens`, `mute_tokens`, and `lexical_density` can be used for handling a tidy text dataset of tokens.

# gibasa 0.5.0

* gibasa now includes the MeCab source, so that users do not need to pre-install the MeCab library when building and installing the package (to use `tokenize`, it still requires MeCab and its dictionaries installed and available).

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
