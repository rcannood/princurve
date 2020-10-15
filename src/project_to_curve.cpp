#include <Rcpp.h>
using namespace Rcpp;

typedef std::pair<int, double> paired;

bool cmp_second(const paired & left, const paired & right) {
  return left.second < right.second;
}

IntegerVector order(const NumericVector & x) {
  const size_t n = x.size();

  std::vector<paired> pairs;
  pairs.reserve(n);
  for (size_t i = 0; i < n; ++i) {
    pairs.push_back(std::make_pair(i, x(i)));
  }

  std::sort(pairs.begin(), pairs.end(), cmp_second);

  IntegerVector result = no_init(n);
  for(size_t i = 0; i < n; ++i) {
    result[i] = pairs[i].first;
  }

  return result;
}

//' Project a set of points to the closest point on a curve
//'
//' Finds the projection index for a matrix of points \code{x}, when
//' projected onto a curve \code{s}. The curve need not be of the same
//' length as the number of points.
//'
//' @param x a matrix of data points.
//' @param s a parametrized curve, represented by a polygon.
//' @param stretch A stretch factor for the endpoints of the curve,
//'   allowing the curve to grow to avoid bunching at the end.
//'   Must be a numeric value between 0 and 2.
//'
//' @return A structure is returned which represents a fitted curve.  It has components
//'   \item{s}{The fitted points on the curve corresponding to each point \code{x}}
//'   \item{ord}{the order of the fitted points}
//'   \item{lambda}{The projection index for each point}
//'   \item{dist}{The total squared distance from the curve}
//'   \item{dist_ind}{The squared distances from the curve to each of the respective points}
//'
//' @seealso \code{\link{principal_curve}}
//'
//' @keywords regression smooth nonparametric
//'
//' @export
//'
//' @examples
//' t <- runif(100, -1, 1)
//' x <- cbind(t, t ^ 2) + rnorm(200, sd = 0.05)
//' s <- matrix(c(-1, 0, 1, 1, 0, 1), ncol = 2)
//'
//' proj <- project_to_curve(x, s)
//'
//' plot(x)
//' lines(s)
//' segments(x[, 1], x[, 2], proj$s[, 1], proj$s[, 2])
// [[Rcpp::export]]
List project_to_curve(
    const NumericMatrix& x,
    NumericMatrix s,
    const double stretch = 2
) {
  int nseg = s.nrow() - 1;
  int npts = x.nrow();
  int ncols = x.ncol();

  // argument checks
  if (s.ncol() != ncols) {
    stop("'x' and 's' must have an equal number of columns");
  }
  if (s.nrow() < 2) {
    stop("'s' must contain at least two rows.");
  }
  if (x.nrow() == 0) {
    stop("'x' must contain at least one row.");
  }
  if (stretch < 0) {
    stop("Argument 'stretch' should be larger than or equal to 0");
  }

  // perform stretch on end points of s
  // only perform stretch if s contains at least two rows
  if (stretch > 0 && s.nrow() >= 2) {
    s = clone(s);

    int n = s.nrow();
    NumericVector diff1 = s(0, _) - s(1, _);
    NumericVector diff2 = s(n - 1, _) - s(n - 2, _);
    s(0,_) = s(0,_) + stretch * diff1;
    s(n - 1,_) = s(n - 1,_) + stretch * diff2;
  }

  // precompute distances between successive points in the curve
  // and the length of each segment
  NumericMatrix diff = no_init(nseg, ncols);
  NumericVector length = no_init(nseg);

  // preallocate variables
  int i, j, k, l, m;
  double u, v, w;

  for (i = 0; i < nseg; ++i) {
    // OPTIMISATION: compute length manually
    //   diff(i, _) = s(i + 1, _) - s(i, _);
    //   length[i] = sum(pow(diff(i, _), 2));
    w = 0;
    for (k = 0; k < ncols; ++k) {
      v = s(i + 1, k) - s(i, k);
      diff[k * nseg + i] = v;
      w += v * v;
    }
    length[i] = w;
    // END OPTIMISATION
  }

  // allocate output data structures
  NumericMatrix new_s = no_init(npts, ncols);     // projections of x onto s
  NumericVector lambda = no_init(npts);           // distance from start of the curve
  NumericVector dist_ind = no_init(npts);         // distances between x and new_s

  // pre-allocate intermediate vectors
  NumericVector n_test = no_init(ncols);
  NumericVector n = no_init(ncols);
  NumericVector p = no_init(ncols);

  // preallocate
  double bestlam, bestdi;

  // iterate over points in x
  for (i = 0; i < npts; ++i) {
    // store information on the closest segment
    bestlam = -1;
    bestdi = R_PosInf;

    // copy current point to p
    for (k = 0; k < ncols; ++k) {
      p[k] = x(i, k);
    }

    // iterate over the segments
    for (j = 0; j < nseg; ++j) {

      // project p orthogonally onto the segment
      // OPTIMISATION: do not allocate diff1 and diff2; compute t manually
      //   NumericVector diff1 = s(j + 1, _) - s(j, _);
      //   NumericVector diff2 = p - s(j, _);
      //   double t = sum(diff1 * diff2) / length(j);
      v = 0;
      for (k = 0; k < ncols; ++k) {
        v += diff(j, k) * (p[k] - s(j, k));
      }
      v /= length(j);
      // END OPTIMISATION

      if (v < 0) {
        v = 0.0;
      }
      if (v > 1) {
        v = 1.0;
      }

      // calculate position of projection and the distance
      // OPTIMISATION: compute di and n_test manually
      //   NumericVector n_test = s(j, _) + t * diff(j, _);
      //   double di = sum(pow(n_test - p, 2.0));
      w = 0;
      for (k = 0; k < ncols; ++k) {
        u = s(j, k) + v * diff(j, k);
        n_test[k] = u;
        w += (u - p[k]) * (u - p[k]);
      }
      // END OPTIMISATION

      // if this is better than what was found earlier, store it
      if (w < bestdi) {
        bestdi = w;
        bestlam = j + .1 + .9 * v;
        for (k = 0; k < ncols; ++k) {
          n[k] = n_test[k];
        }

      }
    }

    // save the best projection to the output data structures
    lambda[i] = bestlam;
    dist_ind[i] = bestdi;
    for (k = 0; k < ncols; ++k) {
      new_s[k * npts + i] = n[k];
    }
  }

  // get ordering from old lambda
  IntegerVector new_ord = order(lambda);

  // calculate total dist
  double dist = sum(dist_ind);

  // recalculate lambda for new_s
  lambda[new_ord[0]] = 0;

  for (i = 1; i < new_ord.length(); ++i) {
    l = new_ord[i - 1];
    m = new_ord[i];

    // OPTIMISATION: compute lambda[o1] manually
    //   NumericVector p1 = new_s(o1, _);
    //   NumericVector p0 = new_s(o0, _);
    //   lambda[o1] = lambda[o0] + sqrt(sum(pow(p1 - p0, 2.0)));
    w = 0;
    for (k = 0; k < ncols; ++k) {
      v = new_s(m, k) - new_s(l, k);
      w += v * v;
    }
    lambda[m] = lambda[l] + sqrt(w);
    // END OPTIMISATION
  }

  // make sure all dimnames are correct
  new_s.attr("dimnames") = List::create(
    rownames(x),
    colnames(x)
  );
  dist_ind.attr("names") = rownames(x);
  lambda.attr("names") = rownames(x);

  // return output
  List ret;
  ret["s"] = new_s;
  ret["ord"] = new_ord + 1;
  ret["lambda"] = lambda;
  ret["dist_ind"] = dist_ind;
  ret["dist"] = dist;

  ret.attr("class") = "principal_curve";

  return ret;
}
