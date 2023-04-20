# gibasa 0.9.3

* Removed unnecessary C++ files.

# gibasa 0.9.2

* Prepare for CRAN release.

# gibasa 0.8.1

* For performance, `tokenize` now skips resetting the output encodings to UTF-8.

# gibasa 0.8.0

* [Breaking Change] Changed numbering style of 'sentence_id' when `split` is `FALSE`.
* Added `grain_size` argument to `tokenize`.
* Added new `bind_lr` function.

# gibasa 0.7.4

* Use `RcppParallel::parallelFor` instead of `tbb::parallel_for`. There are no user's visible changes.

# gibasa 0.7.1

* Fix documentations. There are no visible changes.

# gibasa 0.7.0

* `tokenize` can now accept a character vector in addition to a data.frame like object.
* `gbs_tokenize` is now deprecated. Please use the `tokenize` function instead.

# gibasa 0.6.4

* Refactored `is_blank`.

# gibasa 0.6.3

* Added the `partial` argument to `gbs_tokenize` and `tokenize`. This argument controls the partial parsing mode, which forces to extract given chunks of sentences when activated.

# gibasa 0.6.2

* More friendly errors are returned when invalid dictionary path was provided.
* Added new `posDebugRcpp` function.

# gibasa 0.6.1

* Revert some missing examples.

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
* `tokenize` now takes a data.frame as its first argument, returns a data.frame only. The former function that gets character vector and returns a data.frame or named list was renamed as `gbs_tokenize`.
