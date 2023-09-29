# Methods for the 'blast' generic function

# collate ------

#' @include generics.R

  NULL

# blast function --------

#' Split records of a data frame by variable values.
#'
#' @description Splits records of a data frame by values of its variable
#' or variables. If the splitting factor is a single variable, this operation
#' reverts the effects of \code{\link{compress}}.
#'
#' @details S3 generic function.
#'
#' @param x a data frame or tibble.
#' @param ... one or more unquoted variables used for splitting.
#' @param .drop logical, should empty levels of the vector be skipped from
#' the output? Defaults to TRUE.
#' @param .skip logical, should the splitting variables be removed from the
#' output? Defaults to FALSE.
#'
#' @return a list of data frames.
#'
#' @export blast.data.frame
#' @export

  blast.data.frame <- function(x, ..., .drop = TRUE, .skip = FALSE) {

    ## entry control -------

    stopifnot(is.data.frame(x))
    stopifnot(is.logical(.drop))
    stopifnot(is.logical(.skip))

    ## splitting vector --------

    sel_frame <- dplyr::select(x, ...)

    split_vec <- interaction(as.list(sel_frame), drop = .drop)

    ## splitting --------

    if(.skip) {

      x <- x[!names(x) %in% names(sel_frame)]

    }

    split(x, f = split_vec, drop = .drop)

  }

# END -------
