% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{posDebugRcpp}
\alias{posDebugRcpp}
\title{Tokenizer for debug use}
\arguments{
\item{text}{A character vector to be tokenized.}

\item{sys_dic}{Character scalar; path to the system dictionary for 'MeCab'.}

\item{user_dic}{Character scalar; path to the user dictionary for 'MeCab'.}

\item{partial}{Logical; If \code{TRUE}, activates partial parsing mode.}

\item{grain_size}{Integer value larger than 1.}
}
\value{
A data.frame.
}
\description{
Tokenizes a character vector
and returns all possible results out of the tokenization process.
The returned data.frame contains additional attributes for debug usage.
}
\keyword{internal}
