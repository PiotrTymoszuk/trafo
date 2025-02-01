# Methods for the exchange generic

# default method --------

#' Substitute/exchange object elements.
#'
#' @description
#' Substitutes elements of a vector or other object with values
#' provided by a dictionary: a data frame with the re-coding scheme.
#'
#' @details
#' Any numeric object is silently coerced
#' to a character vector.
#' `exchange()` is a S3 generic function.
#'
#' @return a vector, matrix, list or data frame, depending on `x`
#'
#' @param x an object, e.g an atomic vector, matrix, list or a data frame.
#' @param variable a quoted or unquoted variable
#' of the data frame to be re-coded.
#' @param dict a data frame with the re-coding scheme. It has to contain columns
#' specified by the key and value arguments.
#' @param key the name of the dict data frame variable corresponding to
#' the elements of x: the search key.
#' @param value the name of the dict data frame variable containing the elements
#' used for substitution of x: the returned labels/values.
#' @param ... extra arguments, currently none.
#'
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

    trans_vec <- set_names(dict[[value]],
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

#' @rdname exchange.default
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

    map(x,
        exchange,
        dict = dict,
        key = key,
        value = value, ...)

  }

#' @rdname exchange.default
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

    variable <- enexpr(variable)

    #variable <- rlang::as_label(variable)

    ## re-coding

    mutate(x,
           !!variable := exchange(.data[[variable]],
                                  dict = dict,
                                  key = key,
                                  value = value))

  }

# END -----
