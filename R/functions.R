# Non-generic functions

# Unit conversion -------

#' Convert millimeters to inches.
#'
#' @description Converst millimeters to inches.
#' @param x a numeric vector.
#' @return a numeric vector.
#' @export

  mm_inch <- function(x) {

    if(!is.numeric(x)) {

      stop('x has to be numeric.', call. = FALSE)

    }

    0.0393700787 * x

  }

# Complete variable record ------

#' Get a complete observation set.
#'
#' @description Chooses complete observation series. A such series is defined
#' by one or more identifier variables. If any NA is present in such series,
#' the entire series is discarded.
#'
#' @return a data frame or tibble.
#' @param x a data frame.
#' @param ... the identifier variables of the observation series,
#' quoted or unquoted.
#' @inheritParams blast.data.frame
#'
#' @return a data frame.
#'
#' @export

  complete_cases <- function(x, ...,
                             .drop = TRUE,
                             .skip = FALSE) {

    ## entry control

    if(!is.data.frame(x)) {

      stop('x has to be a data frame.', call. = FALSE)

    }

    cl_check <- is_tibble(x)

    ## filtering

    ft_lst <- blast(x, ..., .drop = .drop, .skip = .skip)

    ft_lst <-
      map_dfr(ft_lst,
              function(x) if(any(!complete.cases(x))) NULL else x)

    if(cl_check) {

      return(as_tibble(ft_lst))

    } else {

      return(as.data.frame(ft_lst))

    }

  }

#END ------
