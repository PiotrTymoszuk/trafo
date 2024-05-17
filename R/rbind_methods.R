# Methods for row binding generics.

# Full row binding ------

#' Full row binding of two data frames, matrices or vectors.
#'
#' @description Binds two data frames, tibbles, matrices or vectors by rows,
#' missing variables are filled with NA.
#' @details Binding of objects of the same class allowed.
#' If a data frame binds with a tibble, the result is a data frame.
#' The binding partners need to be named (i.e. have column or vector names).
#' `full_rbind()` is a S3 generic function.
#' @return a data frame, a tibble or a matrix.
#' @param x a data frame, tibble, matrix or vector.
#' @param y a data frame, tibble, matrix or vector.
#' @param ... extra arguments, currently none.
#' @import rlang
#' @export full_rbind.data.frame
#' @export

  full_rbind.data.frame <- function(x, y, ...) {

    ## entry control -------

    stopifnot(is.data.frame(x))

    if(!is.data.frame(x) | !is.data.frame(y)) {

      stop('x and y have to be data frames', call. = FALSE)

    }

    if(!is_tibble(x) | !is_tibble(y)) {

      x <- as.data.frame(x)
      y <- as.data.frame(y)

    }

    ## missing variables -------

    miss1 <- names(y)[!names(y) %in% names(x)]
    miss2 <- names(x)[!names(x) %in% names(y)]

    ## filling the tables -------

    for(i in miss1){

      x <-  mutate(x, !!i := NA)

    }

    for(i in miss2){

      y <- mutate(y, !!i := NA)

    }

    rbind(x, y)

  }

#' @rdname full_rbind.data.frame
#' @export full_rbind.matrix
#' @export

  full_rbind.matrix <- function(x, y, ...) {

    ## entry control -------

    stopifnot(is.matrix(x))

    if(!is.matrix(x) | !is.matrix(y)) {

      stop('x and y have to be matrices', call. = FALSE)

    }

    if(is.null(colnames(x)) | is.null(colnames(y))) {

      stop('x and y need to have column names', call. = FALSE)

    }

    ## missing variables -------

    miss1 <- colnames(y)[!colnames(y) %in% colnames(x)]
    miss2 <- colnames(x)[!colnames(x) %in% colnames(y)]

    miss1_mtx <- matrix(data = NA,
                        nrow = nrow(x),
                        ncol = length(miss1))

    colnames(miss1_mtx) <- miss1

    if(!is.null(rownames(x))) rownames(miss1_mtx) <- rownames(x)

    miss2_mtx <- matrix(data = NA,
                        nrow = nrow(y),
                        ncol = length(miss2))

    colnames(miss2_mtx) <- miss2

    if(!is.null(rownames(y))) rownames(miss2_mtx) <- rownames(y)

    ## padding the missing values -------

    rbind(cbind(x, miss1_mtx),
          cbind(miss2_mtx, y))

  }

#' @rdname full_rbind.data.frame
#' @export full_rbind.default
#' @export

  full_rbind.default <- function(x, y, ...) {

    ## entry control ------

    stopifnot(is.atomic(x))

    if(!is.atomic(x) | !is.atomic(y)) {

      stop('x and y have to be atomic vectors', call. = FALSE)

    }

    if(is.null(names(x)) | is.null(names(y))) {

      stop('x and y have to be named vectors', call. = FALSE)

    }

    ## binding -------

    x <- set_colnames(matrix(data = unname(x), nrow = 1),
                      names(x))

    y <- set_colnames(matrix(data = unname(y), nrow = 1),
                      names(y))
    full_rbind(x, y)

  }

# Inner row binding --------

#' Inner row binding of two data frames.
#'
#' @description Binds two data frames, tibbles, matrices or vectors by rows,
#' variables missing in one of the binding partners are removed.
#' @details Binding of objects of the same class allowed.
#' If a data frame binds with a tibble, the result is a data frame.
#' The binding partners need to be named (i.e. have column or vector names).
#' `inner_rbind()` is a S3 generic function.
#' @return a data frame, tibble or a matrix.
#' @inheritParams full_rbind.data.frame
#' @export inner_rbind.data.frame
#' @export

  inner_rbind.data.frame <- function(x, y, ...) {

    ## entry control -------

    stopifnot(is.data.frame(x))

    if(!is.data.frame(x) | !is.data.frame(y)) {

      stop('x and y have to be data frames', call. = FALSE)

    }

    if(!is_tibble(x) | !is_tibble(y)) {

      x <- as.data.frame(x)
      y <- as.data.frame(y)

    }

    ## common variables ----

    cmm_vars <- intersect(names(x), names(y))

    ## binding

    rbind(x[cmm_vars],
          y[cmm_vars])

  }

#' @rdname inner_rbind.data.frame
#' @export inner_rbind.matrix
#' @export

  inner_rbind.matrix <- function(x, y, ...) {

    ## entry control -------

    stopifnot(is.matrix(x))

    if(!is.matrix(x) | !is.matrix(y)) {

      stop('x and y have to be matrices', call. = FALSE)

    }

    if(is.null(colnames(x)) | is.null(colnames(y))) {

      stop('x and y need to have column names', call. = FALSE)

    }

    ## common variables and binding -------

    cmm_vars <- intersect(colnames(x), colnames(y))

    rbind(x[, cmm_vars],
          y[, cmm_vars])

  }

#' @rdname inner_rbind.data.frame
#' @export inner_rbind.default
#' @export

  inner_rbind.default <- function(x, y, ...) {

    ## entry control ------

    stopifnot(is.atomic(x))

    if(!is.atomic(x) | !is.atomic(y)) {

      stop('x and y have to be atomic vectors', call. = FALSE)

    }

    if(is.null(names(x)) | is.null(names(y))) {

      stop('x and y have to be named vectors', call. = FALSE)

    }

    ## common element and binding ------

    cmm_names <- intersect(names(x), names(y))

    rbind(x[cmm_names], y[cmm_names])

  }

# END -------
