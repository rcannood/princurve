#' Fits a Principal Curve in Arbitrary Dimension
#'
#' @name princurve-package
#' @aliases princurve-package princurve
#' @docType package
#'
#' @seealso \code{\link{principal.curve}}, \code{\link{get.lam}}
#'
#' @references
#'   \dQuote{Principal Curves} by Hastie, T. and Stuetzle, W. 1989, JASA.
#'   See also Banfield and Raftery (JASA, 1992).
#'
#' @keywords regression smooth nonparametric
#'
#' @importFrom graphics lines plot points
#' @importFrom stats approx lowess predict smooth.spline var
#'
#' @useDynLib princurve, .registration=TRUE
NULL



