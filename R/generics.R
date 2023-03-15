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

# Compact elements of a list or vector into a data frame -----

#' Compact a vector or a list into a data frame.
#'
#' @description Coverts a named vector or a list to a tibble. Names of the
#' vector are stored in a variable specified by 'names_to'.
#' @details a S3 generic function. Its effect can by inverted e.g. by applying
#' \code{\link[plyr]{dlply}} or \code{\link{blast}}.
#' @return a tibble.
#' @param x an object.
#' @param names_to name of the tibble column storing the names of
#' the input object x.
#' @param ... extra arguments passed to the methods.
#' @export

  compress <- function(x, names_to = 'names', ...) {

    UseMethod('compress')

  }

# Spilt records of a data frame ------

#' Split records of a data frame by variable values.
#'
#' @description Splits records of a data frame by values of its variable
#' or variables. If the splitting factor is a single variable, this operation
#' reverts the effects of \code{\link{compress}}.
#' @param x an object.
#' @param ... extra arguments passed to methods.
#' @export

  blast <- function(x, ...) {

    UseMethod('blast')

  }

# Row and column names --------

#' Set row names of a data frame or matrix.
#'
#' @description Sets row names of a matrix, data frame or tibble.
#' @param x an object.
#' @param ... extra arguments passed to methods.
#' @export

  set_rownames <- function(x, ...) {

    UseMethod('set_rownames')

  }

#' Set column names of a data frame or matrix.
#'
#' @description Sets column names of a matrix, data frame or tibble.
#' @param x an object.
#' @param ... extra arguments passed to methods.
#' @export

  set_colnames <- function(x, ...) {

    UseMethod('set_colnames')

  }

# Row binding ------

#' Full row binding.
#'
#' @description Binds two data frames, matrices or vectors by rows,
#' missing variables are filled with NA
#' @return a data frame, a tibble or matrix.
#' @param x an object.
#' @param y an object.
#' @param ... additional arguments passed to methods.
#' @export

  full_rbind <- function(x, y, ...) {

    UseMethod('full_rbind')

  }

#' Inner row binding.
#'
#' @description Binds two data frames, matrices or vectors by rows,
#' missing variables are removed.
#' @return a data frame, a tibble or a matrix.
#' @param x an object.
#' @param y an object.
#' @param ... additional arguments passed to methods.
#' @export

  inner_rbind <- function(x, y, ...) {

    UseMethod('inner_rbind')

  }

# END -----
