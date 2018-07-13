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
    result(i) = pairs[i].first;
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
// [[Rcpp::export]]
List project_to_curve(NumericMatrix x, NumericMatrix s, double stretch = 2) {
  if (stretch > 0) {
    int n = s.nrow();
    NumericVector diff1 = s(0, _) - s(1, _);
    NumericVector diff2 = s(n - 1, _) - s(n - 2, _);
    s(0,_) = s(0,_) + stretch * diff1;
    s(n - 1,_) = s(n - 1,_) + stretch * diff2;
  } else if (stretch < 0) {
    stop("Argument 'stretch' should be larger than or equal to 0");
  }

  int nseg = s.nrow() - 1;
  int npts = x.nrow();
  int ncols = x.ncol();

  if (s.ncol() != ncols) {
    stop("'x' and 's' must have an equal number of columns");
  }

  // precompute distances between successive points in the curve
  // and the length of each segment
  NumericMatrix diff = no_init(nseg, ncols);
  NumericVector length = no_init(nseg);

  for (int i = 0; i < nseg; ++i) {
    // OPTIMISATION: compute length manually
    //   diff(i, _) = s(i + 1, _) - s(i, _);
    //   length[i] = sum(pow(diff(i, _), 2));
    double l = 0;
    for (int k = 0; k < ncols; ++k) {
      double value = s(i + 1, k) - s(i, k);
      diff(i, k) = value;
      l += value * value;
    }
    length[i] = l;
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

  // iterate over points in x
  for (int i = 0; i < npts; ++i) {
    // store information on the closest segment
    double bestlam = -1;
    double bestdi = R_PosInf;

    // copy current point to p
    for (int k = 0; k < ncols; ++k) {
      p[k] = x(i, k);
    }

    // iterate over the segments
    for (int j = 0; j < nseg; ++j) {

      // project p orthogonally onto the segment
      // OPTIMISATION: do not allocate diff1 and diff2; compute t manually
      //   NumericVector diff1 = s(j + 1, _) - s(j, _);
      //   NumericVector diff2 = p - s(j, _);
      //   double t = sum(diff1 * diff2) / length(j);
      double t = 0;
      for (int k = 0; k < ncols; ++k) {
        t += diff(j, k) * (p[k] - s(j, k));
      }
      t /= length(j);
      // END OPTIMISATION

      if (t < 0) {
        t = 0.0;
      }
      if (t > 1) {
        t = 1.0;
      }

      // calculate position of projection and the distance
      // OPTIMISATION: compute di and n_test manually
      //   NumericVector n_test = s(j, _) + t * diff(j, _);
      //   double di = sum(pow(n_test - p, 2.0));
      double di = 0;
      for (int k = 0; k < ncols; ++k) {
        double value = s(j, k) + t * diff(j, k);
        n_test(k) = value;
        di += (value - p[k]) * (value - p[k]);
      }
      // END OPTIMISATION

      // if this is better than what was found earlier, store it
      if (di < bestdi) {
        bestdi = di;
        bestlam = j + .1 + .9 * t;
        for (int k = 0; k < ncols; ++k) {
          n[k] = n_test[k];
        }

      }
    }

    // save the best projection to the output data structures
    lambda[i] = bestlam;
    dist_ind[i] = bestdi;
    for (int k = 0; k < ncols; ++k) {
      new_s(i, k) = n[k];
    }
  }

  // get ordering from old lambda
  IntegerVector new_ord = order(lambda);

  // calculate total dist
  double dist = sum(dist_ind);

  // recalculate lambda for new_s
  lambda[new_ord[0]] = 0;

  for (int i = 1; i < new_ord.length(); ++i) {
    int o1 = new_ord[i];
    int o0 = new_ord[i - 1];

    // OPTIMISATION: compute lambda[o1] manually
    //   NumericVector p1 = new_s(o1, _);
    //   NumericVector p0 = new_s(o0, _);
    //   lambda[o1] = lambda[o0] + sqrt(sum(pow(p1 - p0, 2.0)));
    double o0o1 = 0;
    for (int k = 0; k < ncols; ++k) {
      double val = new_s(o1, k) - new_s(o0, k);
      o0o1 += val * val;
    }
    lambda[o1] = lambda[o0] + sqrt(o0o1);
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
