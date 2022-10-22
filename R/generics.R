# S3 generics

# Exchange/substitute vector or variable elements -----

#' Exchange/substitute vector of data frame variable elements.
#'
#' @description Substitutes elements of a vector or a data frame column
#' with values provided by a dictionary: a data frame with the re-coding scheme.
#' @details a S3 generic function.
#' @return a vector or a data frame.
#' @param x an object.
#' @param ... extra arguments passed to the methods.
#' @export

  exchange <- function(x, ...) {

    UseMethod('exchange')

  }

# Compact elements of a list of vector into a data frame -----

#' Compact a vector or a list into a data frame.
#'
#' @description Coverts a named vector or a list to a tibble. Names of the
#' vector are stored in a variable specified by 'names_to'.
#' @details a S3 generic function. Its effect can by inverted e.g. by applying
#' \code{\link[plyr]{dlply}}.
#' @return a tibble.
#' @param x an object.
#' @param names_to name of the tibble column storing the names of
#' the input object x.
#' @param ... extra arguments passed to the methods.
#' @export

  compress <- function(x, names_to = 'names', ...) {

    UseMethod('compress')

  }

# END -----
