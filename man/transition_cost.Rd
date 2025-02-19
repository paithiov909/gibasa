% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{transition_cost}
\alias{transition_cost}
\title{Get transition cost between pos attributes}
\arguments{
\item{rcAttr}{Integer; the right context attribute ID of the right-hand side of the transition.}

\item{lcAttr}{Integer; the left context attribute ID of the left-hand side of the transition.}

\item{sys_dic}{Character scalar; path to the system dictionary for 'MeCab'.}

\item{user_dic}{Character scalar; path to the user dictionary for 'MeCab'.}
}
\value{
An integer scalar.
}
\description{
Gets transition cost between two pos attributes for a given dictionary.
Note that the valid range of pos attributes differs depending on the dictionary.
If \code{rcAttr} or \code{lcAttr} is out of range, this function will be aborted.
}
\keyword{internal}
