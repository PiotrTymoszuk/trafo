% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{inner_rbind}
\alias{inner_rbind}
\title{Inner row binding of two data frames.}
\usage{
inner_rbind(x, y)
}
\arguments{
\item{x}{a data frame.}

\item{y}{a data frame.}
}
\value{
a data frame or a tibble.
}
\description{
Binds two data frames by rows, missing variables
are removed.
}
