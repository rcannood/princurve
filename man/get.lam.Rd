\name{get.lam}
\alias{get.lam}

\title{Projection Index}

\usage{
get.lam(x, s, tag, stretch = 2)
}

\arguments{
\item{x}{a matrix of data points}
\item{s}{a parametrized curve, represented by a polygon.}
\item{tag}{the order of the point in \code{s}.  Default is the given
order.}
\item{stretch}{A stretch factor for the endpoints of the curve; a
maximum of 2. it allows the curve to grow, if required, and helps avoid
bunching at the end.}
}

\description{
Finds the projection index for a matrix of points \code{x}, when
projected onto a curve \code{s}.  The curve need not be of the same
length as the number of points.  If the points on the curve are not in
order, this order needs to be given as well, in \code{tag}.
}

\value{
A structure is returned which represents a fitted curve.  It has
components
\item{s}{The fitted points on the curve corresponding to each point
\code{x}.}
\item{tag}{the order of the fitted points}
\item{lambda}{The projection index for each point}
\item{dist}{The total squared distance from the curve}
}

\seealso{
\code{\link{principal.curve}}
}

\keyword{regression}
\keyword{smooth}
\keyword{nonparametric}



