# Functions for safe selection and mutation of data frames

#' Select and manipulate data frame columns in an error-resistant mode.
#'
#' @description
#' The functions select and transform columns of a data frame in an analogical
#' way as \code{\link[dplyr]{select}} and \code{\link[dplyr]{mutate}} but in an
#' error-resistant mode. This means that e.g. modification of
#' non-existing columns does not throw an error. In case of any errors, the
#' unmodified input data frame is returned (`safely_mutate()`) or only the
#' columns found in the data frame are selected (`safely_select()`).
#'
#' @return a data frame.
#'
#' @param .data a data frame.
#' @param ... expressions for modification of data frame columns, see:
#' \code{\link[dplyr]{mutate}} for details.
#' @param cols a character vector with names of columns to select.
#' @param fill value to be inputed. If not `NULL`, any non-existing columns
#' will be created and filled with this value.
#'
#' @export

  safely_mutate <- function(.data, ...) {

    ## enables for error-resistant change of data frame columns
    ## in case of any error, the genuine data frame is returned

    if(!is.data.frame(.data)) {

      stop("'.data' has to be a data frame.", call. = FALSE)

    }

    new_data <- try(mutate(.data, ...),
                    silent = TRUE)

    if(inherits(new_data, 'try-error')) return(.data)

    return(new_data)

  }

#' @rdname safely_mutate
#' @export

  safely_select <- function(.data, cols, fill = NULL) {

    ## selects columns with a character vector of column names
    ## in safe mode, i.e. without errors if the column does not exist
    ##
    ## if `fill` is specified, the non-existing columns are added and filled
    ## with the defined value

    if(!is.data.frame(.data)) {

      stop("'data' has to be a data frame.", call. = FALSE)

    }

    stopifnot(is.character(cols))

    new_data <- select(.data, any_of(cols))

    if(is.null(fill)) return(new_data)

    absent_cols <- cols[!cols %in% names(.data)]

    for(i in absent_cols) {

      new_data[[i]] <- fill

    }

    new_data

  }

# END ---------
