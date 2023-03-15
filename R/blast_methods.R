# Methods for the 'blast' generic function

# blast function --------

#' Split records of a data frame by variable values.
#'
#' @description Splits records of a data frame by values of its variable
#' or variables. If the splitting factor is a single variable, this operation
#' reverts the effects of \code{\link{compress}}.
#' @param x a data frame or tibble.
#' @param ... one or more unquoted variables used for splitting.
#' @param .drop logical, should empty levels of the vector be skipped from
#' the output? Defaults to TRUE.
#' @export blast.data.frame
#' @export

  blast.data.frame <- function(x, ..., .drop = TRUE) {

    ## entry control -------

    stopifnot(is.data.frame(x))
    stopifnot(is.logical(.drop))

    ## splitting vector --------

    sel_frame <- dplyr::select(x, ...)

    split_vec <- interaction(as.list(sel_frame), drop = .drop)

    ## splitting --------

    split(x, f = split_vec, drop = .drop)

  }

# END -------
