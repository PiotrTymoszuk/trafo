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
#' by the 'id_variable' variable. If any NA is present in such series,
#' the entire series is discarded.
#' @return a data frame or tibble.
#' @param x a data frame.
#' @param id_variable name of the identifier variable of the observation series.
#' @export

  complete_cases <- function(x, id_variable = 'ID') {

    ## entry control

    if(!is.data.frame(x)) {

      stop('x has to be a data frame.', call. = FALSE)

    }

    if(!id_variable %in% names(x)) {

      stop('id_variable is absent from x.', call. = FALSE)

    }

    cl_check <- tibble::is_tibble(x)

    ## filtering

    ft_lst <-
      plyr::dlply(x,
                  id_variable)

    ft_lst <-
      purrr::map_dfr(ft_lst,
                     function(x) if(any(!complete.cases(x))) NULL else x)

    if(cl_check) {

      return(tibble::as_tibble(ft_lst))

    } else {

      return(as.data.frame(ft_lst))

    }

  }

#END ------
