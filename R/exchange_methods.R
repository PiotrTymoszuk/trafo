# Methods for the exchange generic

# default method --------

#' Substitute/exchange object elements.
#'
#' @description Substitutes elements of a vector or other object with values
#' provided by a dictionary: a data frame with the re-coding scheme.
#' @details Any numeric object is silently coerced
#' to a character vector.
#' @return a vector.
#' @param x an object, e.g an atomic vector or a matrix.
#' @param dict a data frame with the recoding scheme. It has to contain columns
#' specified by the key and value arguments.
#' @param key the name of the dict data frame variable corresponding to
#' the elements of x: the search key.
#' @param value the name of the dict data frame variable containing the elements
#' used for substitution of x: the returned labels/values.
#' @param ... extra arguments, currently none.
#' @export exchange.default
#' @export

  exchange.default <- function(x,
                               dict,
                               key = 'variable',
                               value = 'label', ...) {

    ## entry control

    if(!is.atomic(x)) {

      stop('x has to be an atomic vector.', call. = FALSE)

    }

    if(!is.data.frame(dict)) {

      stop('The dictionary needs to be a data frame.', call. = FALSE)

    }

    if(any(!c(key, value) %in% names(dict))) {

      stop('Key or value absent from the dictionary.', call. = FALSE)

    }

    ## annotation

    trans_vec <- rlang::set_names(dict[[value]],
                                  dict[[key]])

    if(!is.matrix(x)) {

      if(is.numeric(x)) {

        x <- as.character(x)

      }

      return(trans_vec[x])

    }

    row_n = nrow(x)
    col_n = ncol(x)

    if(is.numeric(x)) {

      x <- as.character(x)

    }

    matrix(trans_vec[x],
           ncol = col_n,
           nrow = row_n)


  }

# list ------

#' Substitute/exchange elements of a list.
#'
#' @description Substitutes elements of a list with values
#' provided by a dictionary: a data frame with the re-coding scheme.
#' @details Numeric elements are silently coerced
#' to character.
#' @return a list.
#' @param x a list, storing the elements to be substituted.
#' @param ... extra arguments. Those can be parameters passed to specific
#' exchange methods, e.g. variable argument passed to
#' \code{\link{exchange.data.frame}}, if a list of data frames is handled.
#' @inheritParams exchange.default
#' @export exchange.list
#' @export

  exchange.list <- function(x,
                            dict,
                            key = 'variable',
                            value = 'label', ...) {

    ## entry control

    if(!is.list(x)) {

      stop('x has to be a list.', call. = FALSE)

    }

    ## re-coding

    purrr::map(x,
               exchange,
               dict = dict,
               key = key,
               value = value, ...)

  }

# data frame -------

#' Substitute/exchange elements of a data frame variable.
#'
#' @description Substitutes elements of a data frame variable with values
#' provided by a dictionary: a data frame with the re-coding scheme.
#' @details Any numeric variable is silently coerced
#' to a character one.
#' @return a vector.
#' @param x a data frame, storing the variable to be substituted.
#' @param variable name of the variable to be substituted.
#' @inheritParams exchange.default
#' @export exchange.data.frame
#' @export

  exchange.data.frame <- function(x,
                                  variable,
                                  dict,
                                  key = 'variable',
                                  value = 'label', ...) {

    ## entry control

    if(!is.data.frame(x)) {

      stop('x has to be a data frame.', call. = FALSE)

    }

    if(!variable %in% names(x)) {

      stop('variable absent from x.', call. = FALSE)

    }

    ## re-coding

    dplyr::mutate(x,
                  !!variable := exchange(.data[[variable]],
                                         dict = dict,
                                         key = key,
                                         value = value))

  }

# END -----
