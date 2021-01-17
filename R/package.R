#' Fit a Principal Curve in Arbitrary Dimension
#'
#' Fit a principal curve which describes a smooth curve that passes through the \code{middle}
#' of the data \code{x} in an orthogonal sense. This curve is a non-parametric generalization
#' of a linear principal component. If a closed curve is fit (using \code{smoother = "periodic_lowess"})
#' then the starting curve defaults to a circle, and each fit is followed by a bias correction
#' suggested by Jeff Banfield.
#'
#' @name princurve-package
#' @aliases princurve-package princurve
#' @docType package
#'
#' @import Rcpp
#'
#' @seealso \code{\link{principal_curve}}, \code{\link{project_to_curve}}
#'
#' @references
#'  Hastie, T. and Stuetzle, W.,
#'  \href{https://www.jstor.org/stable/2289936}{Principal Curves},
#'  JASA, Vol. 84, No. 406 (Jun., 1989), pp. 502-516,
#'  \doi{10.2307/2289936}
#'  (\href{https://web.stanford.edu/~hastie/Papers/principalcurves.pdf}{PDF}).
#'
#'  See also Banfield and Raftery (JASA, 1992).
#'
#' @keywords regression smooth nonparametric
#'
#' @useDynLib princurve
NULL



