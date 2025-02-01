# Method for generics that shift elements of vectors, matrices, or data frames
# to the head or tail of the object

# collate ------

#' @include generics.R

  NULL

# Shifting to the head -------

#' Shift elements or observations to the object's head or tail.
#'
#' @description
#' Function `to_head()` shifts selected elements of an atomic vector or a list,
#' or selected rows of a matrix or a data frame to the object's head, i.e.
#' starting position.
#' Function `to_tail()` places the selected elements or observations at the
#' object's tails, i.e. end position.
#'
#' @details
#' The elements r observations may be specified by their positions or a names.
#' The order of the shifted elements corresponds to the position/name vector.
#' If the object has no names, an error is raised.
#'
#' @return an object of the same class as `x` with the selected elements or
#' rows placed at it's start or end.
#'
#' @param x an object: an atomic vector, list, matrix, or data frame.
#' @param idx a vector of indexes or names of objects to be placed at the object's
#' start or end.
#' @param ... extra arguments passed to the methods.
#'
#' @export

  to_head.default <- function(x, idx, ...) {

    ## entry control ------

    if(!is.atomic(x) & !is.list(x)) {

      stop("'x' has to be an atomic vector or a list.", call. = FALSE)

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    if(!is.character(idx) & !is.integer(idx)) {

      stop("'idx' must be a numeric, integer, or character vector.",
           call. = FALSE)

    }

    if(is.character(idx) & is.null(names(x))) {

      stop("'x' has no names.", call. = FALSE)

    }

    ## index errors are raised by downstream functions

    ## indexing and stitching -------

    header <- x[idx]

    if(is.character(idx)) {

      body <- x[!names(x) %in% idx]

    } else {

      body <- x[-idx]

    }

    c(header, body)

  }

#' @rdname to_head.default
#' @export

  to_tail.default <- function(x, idx, ...) {

    ## entry control ------

    if(!is.atomic(x) & !is.list(x)) {

      stop("'x' has to be an atomic vector or a list.", call. = FALSE)

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    if(!is.character(idx) & !is.integer(idx)) {

      stop("'idx' must be a numeric, integer, or character vector.",
           call. = FALSE)

    }

    if(is.character(idx) & is.null(names(x))) {

      stop("'x' has no names.", call. = FALSE)

    }

    ## index errors are raised by downstream functions

    ## indexing and stitching -------

    trailer <- x[idx]

    if(is.character(idx)) {

      body <- x[!names(x) %in% idx]

    } else {

      body <- x[-idx]

    }

    c(body, trailer)

  }

#' @rdname to_head.default
#' @export

  to_head.matrix <- function(x, idx, ...) {

    ## entry control -------

    if(!is.matrix(x)) {

      stop("'x' has to be a matrix.", call. = FALSE)

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    if(!is.character(idx) & !is.integer(idx)) {

      stop("'idx' must be a numeric, integer, or character vector.",
           call. = FALSE)

    }

    if(is.character(idx) & is.null(rownames(x))) {

      stop("'x' has no row names.", call. = FALSE)

    }

    ## splitting and stitching --------

    header <- x[idx, , drop = FALSE]

    if(is.character(idx)) {

      body <- x[!rownames(x) %in% idx, , drop = FALSE]

    } else {

      body <- x[-idx, , drop = FALSE]

    }

    rbind(header, body)


  }

#' @rdname to_head.default
#' @export

  to_tail.matrix <- function(x, idx, ...) {

    ## entry control -------

    if(!is.matrix(x)) {

      stop("'x' has to be a matrix.", call. = FALSE)

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    if(!is.character(idx) & !is.integer(idx)) {

      stop("'idx' must be a numeric, integer, or character vector.",
           call. = FALSE)

    }

    if(is.character(idx) & is.null(rownames(x))) {

      stop("'x' has no row names.", call. = FALSE)

    }

    ## splitting and stitching --------

    trailer <- x[idx, , drop = FALSE]

    if(is.character(idx)) {

      body <- x[!rownames(x) %in% idx, , drop = FALSE]

    } else {

      body <- x[-idx, , drop = FALSE]

    }

    rbind(body, trailer)


  }

#' @rdname to_head.default
#' @export

  to_head.data.frame <- function(x, idx, ...) {

    ## entry control -------

    if(!is.data.frame(x)) {

      stop("'x' has to be a data frame.", call. = FALSE)

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    if(!is.character(idx) & !is.integer(idx)) {

      stop("'idx' must be a numeric, integer, or character vector.",
           call. = FALSE)

    }

    if(is.character(idx) & is.null(rownames(x))) {

      stop("'x' has no row names.", call. = FALSE)

    }

    ## splitting and stitching --------

    header <- x[idx, , drop = FALSE]

    if(is.character(idx)) {

      body <- x[!rownames(x) %in% idx, , drop = FALSE]

    } else {

      body <- x[-idx, , drop = FALSE]

    }

    rbind(header, body)

  }

#' @rdname to_head.default
#' @export

  to_tail.data.frame <- function(x, idx, ...) {

    ## entry control -------

    if(!is.data.frame(x)) {

      stop("'x' has to be a data frame.", call. = FALSE)

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    if(!is.character(idx) & !is.integer(idx)) {

      stop("'idx' must be a numeric, integer, or character vector.",
           call. = FALSE)

    }

    if(is.character(idx) & is.null(rownames(x))) {

      stop("'x' has no row names.", call. = FALSE)

    }

    ## splitting and stitching --------

    trailer <- x[idx, , drop = FALSE]

    if(is.character(idx)) {

      body <- x[!rownames(x) %in% idx, , drop = FALSE]

    } else {

      body <- x[-idx, , drop = FALSE]

    }

    rbind(body, trailer)

  }

#' @rdname to_head.default
#' @export

  to_head.tbl_df <- function(x, idx, ...) {

    ## entry control -------

    if(!is_tibble(x)) {

      stop("'x' has to be a tibble.", call. = FALSE)

    }

    if(!is.numeric(idx)) {

      stop("'idx' has to be a numeric or integer vector.")

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    ## splitting and stitching --------

    header <- x[idx, ]

    body <- x[-idx, ]

    as_tibble(rbind(header, body))

  }

#' @rdname to_head.default
#' @export

  to_tail.tbl_df <- function(x, idx, ...) {

    ## entry control -------

    if(!is_tibble(x)) {

      stop("'x' has to be a tibble.", call. = FALSE)

    }

    if(!is.numeric(idx)) {

      stop("'idx' has to be a numeric or integer vector.")

    }

    if(is.numeric(idx)) idx <- as.integer(idx)

    ## splitting and stitching --------

    trailer <- x[idx, ]

    body <- x[-idx, ]

    as_tibble(rbind(body, trailer))

  }

# END ------
