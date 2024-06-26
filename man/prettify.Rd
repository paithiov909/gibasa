% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prettify.R
\name{prettify}
\alias{prettify}
\title{Prettify tokenized output}
\usage{
prettify(
  tbl,
  col = "feature",
  into = get_dict_features("ipa"),
  col_select = seq_along(into),
  delim = ","
)
}
\arguments{
\item{tbl}{A data.frame that has feature column to be prettified.}

\item{col}{<\code{\link[rlang:args_data_masking]{data-masked}}>
Column containing features to be prettified.}

\item{into}{Character vector that is used as column names of
features.}

\item{col_select}{Character or integer vector that will be kept
in prettified features.}

\item{delim}{Character scalar used to separate fields within a feature.}
}
\value{
A data.frame.
}
\description{
Turns a single character column into features
while separating with delimiter.
}
\examples{
prettify(
  data.frame(x = c("x,y", "y,z", "z,x")),
  col = "x",
  into = c("a", "b"),
  col_select = "b"
)

\dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
)
prettify(df, col_select = 1:3)
prettify(df, col_select = c(1, 3, 6))
prettify(df, col_select = c("POS1", "Original"))
}
}
