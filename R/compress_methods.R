# Methods for the compress generic

# collating --------

#' @include generics.R

  NULL

# default and list method -------

#' Convert a named object into a tibble.
#'
#' @description Converts a named object, e.g. an atomic vector or a list
#' into a tibble.
#' The object elements are stored in a variable named as specified by the
#' 'values_to' argument, the names are stored under 'names_to' variable.
#' @details By setting 'simplify' to TRUE, a special behavior for a 'pure' list
#' of data frames is toggled on. The function detects if all data frames have
#' identical column names. If so, the result is coerced into a single tibble or
#' data frame and the values_to argument is ignored.
#' Otherwise or if simplify is set to FALSE, each element is of the list is
#' stored in the variable specified by the values_to argument.
#' The argument simplify set to FALSE makes the function faster.
#' `compress()` is a S3 generic function. Its effect can by inverted e.g.
#' by applying \code{\link[plyr]{dlply}} or \code{\link{blast}}.
#' @return a tibble.
#' @param x a named object, e.g. atomic vector, to be converted to a tibble.
#' @param names_to name of the variable storing the names.
#' @param values_to name of the variable storing the object's elements.
#' @param simplify logical, should a simplified output be considered for a
#' list of compatible data frames? See the details section. Default is TRUE.
#' @param ... extra arguments, currently none.
#' @import rlang
#' @export compress.default
#' @export

  compress.default <- function(x,
                               names_to = 'names',
                               values_to = 'values', ...) {

    ## entry control

    if(!is.atomic(x)) {

      stop('x has to be an atomic vector.', call. = FALSE)

    }

    if(is.null(names(x))) {

      stop('x has to have names.', call. = FALSE)

    }

    ## compression

    tibble(!!names_to := names(x),
           !!values_to := x)

  }

#' @rdname compress.default
#' @export compress.list
#' @export

  compress.list <- function(x,
                            names_to = 'names',
                            values_to = 'values',
                            simplify = TRUE, ...) {

    ## entry control

    if(!is.list(x)) {

      stop('x has to be a named list.', call. = FALSE)

    }

    if(is.null(names(x))) {

      stop('x has to be a named list.', call. = FALSE)

    }

    stopifnot(is.logical(simplify))

    x <- compact(x)

    ## compression

    if(!simplify) {

      return(tibble(!!names_to := names(x),
                    !!values_to := x))

    }

    cl_check <- map_lgl(x, is.data.frame)

    if(any(!cl_check)) {

      return(tibble(!!names_to := names(x),
                    !!values_to := x))

    }

    colname_check <- map(x, colnames)

    cmm_colnames <- reduce(unname(colname_check), intersect)

    if(!identical(colname_check[[1]], cmm_colnames)) {

      return(tibble(!!names_to := names(x),
                    !!values_to := x))

    }

    map2_dfr(x, names(x),
             ~mutate(.x, !!names_to := .y))

  }

# END -------
