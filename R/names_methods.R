# Methods for the 'set_rownames' generic.

# Row names -------

#' Set row names of a data frame or matrix.
#'
#' @description
#' Sets row names of a data frame, tibble or matrix.
#' A tibble is silently converted to a classical data frame.
#'
#' @return a data frame or matrix.
#'
#' @param x a data frame, tibble or matrix.
#' @param row_names a vector of unique row names.
#' @param ... extra parameters, currently none.
#'
#' @export

  set_rownames.data.frame <- function(x, row_names, ...) {

    ## entry control ------

    stopifnot(is.data.frame(x))

    if(length(row_names) != nrow(x)) {

      stop('row names length must fit the x data frame.', call. = FALSE)

    }

    if(any(duplicated(row_names))) {

      stop('Unique row names are required.', call. = FALSE)

    }

    ## setting the rownames ------

    x <- as.data.frame(x)

    rownames(x) <- row_names

    x

  }

#' @rdname set_rownames.data.frame
#' @export

  set_rownames.matrix <- function(x, row_names, ...) {

    ## entry control -------

    stopifnot(is.matrix(x))

    if(length(row_names) != nrow(x)) {

      stop('row names length must fit the x matrix.', call. = FALSE)

    }

    if(any(duplicated(row_names))) {

      stop('Unique row names are required.', call. = FALSE)

    }

    ## setting the rownames ------

    rownames(x) <- row_names

    x

  }

# Column names -------

#' Set column names of a data frame or matrix.
#'
#' @description Sets column names of a data frame, tibble or matrix.
#'
#' @return a data frame, tibble or matrix.
#'
#' @param x a data frame, tibble or matrix.
#' @param col_names a vector of unique column names.
#' @param ... extra parameters, currently none.
#'
#' @export

  set_colnames.data.frame <- function(x, col_names, ...) {

    ## entry control ------

    stopifnot(is.data.frame(x))

    if(length(col_names) != ncol(x)) {

      stop('column names length must fit the x data frame.', call. = FALSE)

    }

    if(any(duplicated(col_names))) {

      stop('Unique rownames are required.', call. = FALSE)

    }

    ## setting the colnames ------

    colnames(x) <- col_names

    x

  }

#' @rdname set_colnames.data.frame
#' @export

  set_colnames.matrix <- function(x, col_names, ...) {

    ## entry control -------

    stopifnot(is.matrix(x))

    if(length(col_names) != ncol(x)) {

      stop('column names length must fit the x matrix.', call. = FALSE)

    }

    if(any(duplicated(col_names))) {

      stop('Unique column names are required.', call. = FALSE)

    }

    ## setting the rownames ------

    colnames(x) <- col_names

    x

  }

# END ------
