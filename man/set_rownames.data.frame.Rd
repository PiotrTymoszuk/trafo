% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generics.R, R/names_methods.R
\name{set_rownames}
\alias{set_rownames}
\alias{set_rownames.data.frame}
\alias{set_rownames.matrix}
\title{Set row names of a data frame or matrix.}
\usage{
set_rownames(x, ...)

\method{set_rownames}{data.frame}(x, row_names, ...)

\method{set_rownames}{matrix}(x, row_names, ...)
}
\arguments{
\item{x}{a data frame, tibble or matrix.}

\item{...}{extra parameters, currently none.}

\item{row_names}{a vector of unique row names.}
}
\value{
a data frame or matrix.
}
\description{
Sets row names of a data frame, tibble or matrix.
A tibble is silently converted to a classical data frame.
}
\details{
`set_rownames()` is a S3 generic function.
}
