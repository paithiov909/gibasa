% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bind_lr.R
\name{bind_lr}
\alias{bind_lr}
\title{Bind importance of bigrams}
\usage{
bind_lr(tbl, term = "token", lr_mode = c("n", "dn"), avg_rate = 1)
}
\arguments{
\item{tbl}{A tidy text dataset.}

\item{term}{<\code{\link[rlang:args_data_masking]{data-masked}}>
Column containing terms.}

\item{lr_mode}{Method for computing 'FL' and 'FR' values.
\code{n} is equivalent to 'LN' and 'RN',
and \code{dn} is equivalent to 'LDN' and 'RDN'.}

\item{avg_rate}{Weight of the 'LR' value.}
}
\value{
A data.frame.
}
\description{
Calculates and binds the importance of bigrams and their synergistic average.
}
\details{
The 'LR' value is the synergistic average of bigram importance
that based on the words and their positions (left or right side).
}
\examples{
\dontrun{
df <- tokenize(
  data.frame(
    doc_id = seq_along(5:8),
    text = ginga[5:8]
  )
)
bind_lr(df) |>
  head()
}
}
\seealso{
\doi{10.5715/jnlp.10.27}
}
