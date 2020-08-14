#' Deprecated functions
#'
#' This function is deprecated, please use
#' \code{\link{principal_curve}} and \code{\link{project_to_curve}} instead.
#'
#' @param ... Catch-all for old parameters.
#'
#' @rdname deprecated
#'
#' @export
principal.curve <- function(...) {
  .Defunct("principal_curve", package = "princurve")
}


#' @rdname deprecated
#' @export
lines.principal.curve <- function(...) {
  .Defunct("lines.principal_curve", package = "princurve")
}

#' @rdname deprecated
#' @export
plot.principal.curve <- function(...) {
  .Defunct("plot.principal_curve", package = "princurve")
}

#' @rdname deprecated
#' @export
points.principal.curve <- function(...) {
  .Defunct("points.principal_curve", package = "princurve")
}

#' @rdname deprecated
#' @export
get.lam <- function(...) {
  .Defunct("project_to_curve", package = "princurve")
}

