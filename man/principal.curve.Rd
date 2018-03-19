\name{principal.curve}
\alias{principal.curve}
\alias{lines.principal.curve}
\alias{plot.principal.curve}
\alias{points.principal.curve}

\title{Fit a Principal Curve}

\usage{
principal.curve(x, start=NULL, thresh=0.001, plot.true=FALSE, maxit=10,
                stretch=2, smoother="smooth.spline", trace=FALSE, \dots)
}

\description{Fits a principal curve which describes a
smooth curve that passes through the \code{middle} of the data \code{x} in
an orthogonal sense.  This curve is a nonparametric generalization of a
linear principal component.  If a closed curve is fit (using
\code{smoother = "periodic.lowess"}) then the starting curve defaults to
a circle, and each fit is followed by a bias correction suggested by
J. Banfield.}

\arguments{
\item{x}{a matrix of points in arbitrary dimension}
\item{start}{either a previously fit principal curve, or else a matrix
    of points that in row order define a starting curve. If missing or NULL,
    then the first principal component is used.  If the smoother is
    \code{"periodic.lowess"}, then a circle is used as the start.}
\item{thresh}{convergence threshold on shortest distances to the curve.}
\item{plot.true}{If \code{TRUE} the iterations are plotted.}
\item{maxit}{maximum number of iterations.}
\item{stretch}{a factor by which the curve can be extrapolated when
    points are projected.  Default is 2 (times the last segment
    length). The default is 0 for \code{smoother} equal to
    \code{"periodic.lowess"}.}
\item{smoother}{choice of smoother. The default is
    \code{"smooth.spline"}, and other choices are \code{"lowess"} and
    \code{"periodic.lowess"}. The latter allows one to fit closed curves.
    Beware, you may want to use \code{iter = 0} with \code{lowess()}.}
\item{trace}{If \code{TRUE}, the iteration information is printed}
\item{\dots}{additional arguments to the smoothers}
}

\value{
An object of class \code{"principal.curve"} is returned. For this object
the following generic methods a currently available: \code{plot, points,
lines}.

It has components:
\item{s}{a matrix corresponding to \code{x}, giving their projections
    onto the curve.}
\item{tag}{an index, such that \code{s[tag, ]} is smooth.}
\item{lambda}{for each point, its arc-length from the beginning of the
    curve. The curve is parametrized approximately by arc-length, and
    hence is \code{unit-speed}.} 
\item{dist}{the sum-of-squared distances from the points to their
    projections.}
\item{converged}{A logical indicating whether the algorithm converged 
    or not.}
\item{nbrOfIterations}{Number of iterations completed before returning.}
\item{call}{the call that created this object; allows it to be
\code{updated()}.}
}

\seealso{
\code{\link{get.lam}}
}

\keyword{regression}
\keyword{smooth}
\keyword{nonparametric}

\references{
  \dQuote{Principal Curves} by Hastie, T. and Stuetzle, W. 1989, JASA.
  See also Banfield and Raftery (JASA, 1992).
}

\examples{
x <- runif(100,-1,1)
x <- cbind(x, x ^ 2 + rnorm(100, sd = 0.1))
fit1 <- principal.curve(x, plot = TRUE)
fit2 <- principal.curve(x, plot = TRUE, smoother = "lowess")
lines(fit1)
points(fit1)
plot(fit1)
whiskers <- function(from, to)
    segments(from[, 1], from[, 2], to[, 1], to[, 2])
whiskers(x, fit1$s)
}
