# Non-generic functions

# Rownames -------

#' Set rownames of a data frame.
#'
#' @description Sets rownames of a data frame. A tibble is sielnty connverted
#' to a classical data frame.
#' @return a data frame.
#' @param x a data frame.
#' @param rown_names a vector of unique rownames.
#' @export

  set_rownames <- function(x, row_names) {

    ## entry control

    if(!is.data.frame(x)) {

      stop('x has to be data frame.', call. = FALSE)

    }

    if(length(row_names) != nrow(x)) {

      stop('rownames length must fit the x data frame.', call. = FALSE)

    }

    if(any(duplicated(row_names))) {

      stop('Unique rownames are required.', call. = FALSE)

    }

    ## setting the rownames

    x <- as.data.frame(x)

    rownames(x) <- row_names

    x

  }

# Full row binding ------

#' Full row binding of two data frames.
#'
#' @description Binds two data frames by rows, missing variables
#' are filled with NA
#' @return a data frame or a tibble.
#' @param x a data frame.
#' @param y a data frame.
#' @export

  full_rbind <- function(x, y) {

    ## entry control

    if(!is.data.frame(x) | !is.data.frame(y)) {

      stop('x and y have to be data frames', call. = FALSE)

    }

    ## missing variables

    miss1 <- names(y)[!names(y) %in% names(x)]
    miss2 <- names(x)[!names(x) %in% names(y)]

    ## filling the tables

    for(i in miss1){

      x <-  dplyr::mutate(x, !!i := NA)

    }

    for(i in miss2){

      y <- dplyr::mutate(y, !!i := NA)

    }

    rbind(x, y)

  }

# Inner row binding --------

#' Inner row binding of two data frames.
#'
#' @description Binds two data frames by rows, missing variables
#' are removed.
#' @return a data frame or a tibble.
#' @param x a data frame.
#' @param y a data frame.
#' @export

  inner_rbind <- function(x, y) {

    ## entry control

    if(!is.data.frame(x) | !is.data.frame(y)) {

      stop('x and y have to be data frames', call. = FALSE)

    }

    ## common variables

    cmm_vars <- intersect(names(x), names(y))

    ## binding

    rbind(x[cmm_vars],
          y[cmm_vars])

  }

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
