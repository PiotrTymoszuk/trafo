# S3 generics

# Exchange/substitute vector or variable elements -----

#' @rdname exchange.default
#' @param ... extra arguments passed to the methods.
#' @export

  exchange <- function(x, ...) {

    UseMethod('exchange')

  }

# Compact elements of a list or vector into a data frame -----

#' @rdname compress.default
#' @export

  compress <- function(x, names_to = 'names', ...) {

    UseMethod('compress')

  }

# Spilt records of a data frame ------

#' @rdname blast.data.frame
#' @export

  blast <- function(x, ...) {

    UseMethod('blast')

  }

# Row and column names --------

#' @rdname set_rownames.data.frame
#' @export

  set_rownames <- function(x, ...) {

    UseMethod('set_rownames')

  }

#' @rdname set_colnames.data.frame
#' @export

  set_colnames <- function(x, ...) {

    UseMethod('set_colnames')

  }

# Row binding ------

#' @rdname full_rbind.data.frame
#' @export

  full_rbind <- function(x, y, ...) {

    UseMethod('full_rbind')

  }

#' @rdname inner_rbind.data.frame
#' @export

  inner_rbind <- function(x, y, ...) {

    UseMethod('inner_rbind')

  }

# END -----
