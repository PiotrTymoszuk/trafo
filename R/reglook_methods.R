# Methods for the reglook generic imported from the 'figur' package

# reglook -------

#' Search an object by regular expression.
#'
#' @description Select elements of a vector or data frame records which match
#' the given regular expression.
#' @param object an object to be searched.
#' @param regex a regular expression.
#' @param keys a vector of data frame variable names to be included
#' in the search. Defaults to NULL, which means that all variables will be
#' looked up.
#' @param multiple ignored when a single search key is provided.
#' It describes how searching results from multiple data frame columns will
#' be handled. 'OR' (default) specifies that the multiply column search results
#' will be merged by logical sum, for 'AND' they will be merged by logical
#' intersection.
#' @param ... extra arguments, currently none.
#' @return an object of the same class as the input one.
#' @importFrom figur reglook reglook.default reglook.data.frame
#' @export

  reglook <- figur::reglook

#' @rdname reglook
#' @export reglook.default
#' @export

  reglook.default <- figur::reglook.default

#' @rdname reglook
#' @export reglook.data.frame
#' @export

  reglook.data.frame <- figur::reglook.data.frame

# END -----
