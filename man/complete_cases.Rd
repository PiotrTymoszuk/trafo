% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{complete_cases}
\alias{complete_cases}
\title{Get a complete observation set.}
\usage{
complete_cases(x, id_variable = "ID")
}
\arguments{
\item{x}{a data frame.}

\item{id_variable}{name of the identifier variable of the observation series.}
}
\value{
a data frame or tibble.
}
\description{
Chooses complete observation series. A such series is defined
by the 'id_variable' variable. If any NA is present in such series,
the entire series is discarded.
}
