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

  // precompute distances between successive points in the curve
  // and the length of each segment
  int num_segments = s.nrow() - 1;
  NumericMatrix diff(num_segments, s.ncol());
  NumericVector length(num_segments);

  for (int i = 0; i < num_segments; ++i) {
    diff(i, _) = s(i + 1, _) - s(i, _);
    length[i] = sum(pow(diff(i, _), 2.0));
  }

  // OUTPUT DATA STRUCTURES
  // projections of x onto s
  NumericMatrix new_s(x.nrow(), x.ncol());
  rownames(new_s) = rownames(x);
  colnames(new_s) = colnames(x);

  // distance from start of the curve
  NumericVector lambda(x.nrow());

  // distances between x and new_s
  NumericVector dist_ind(x.nrow());
  dist_ind.attr("names") = rownames(x);

  // iterate over points in x
  for (int i = 0; i < x.nrow(); ++i) {
    NumericVector p = x(i, _);

    // store information on the closest segment
    int bestj = -1;
    double bestt = -1;
    NumericVector n(x.ncol());
    double bestdi = R_PosInf;

    // iterate over the segments
    for (int j = 0; j < num_segments; ++j) {

      // project p orthogonally onto the segment
      NumericVector diff1 = diff(j, _);
      NumericVector diff2 = p - s(j, _);

      double t = sum(diff1 * diff2) / length(j);
      if (t < 0) {
        t = 0.0;
      }
      if (t > 1) {
        t = 1.0;
      }

      // calculate position of projection and the distance
      NumericVector n_test = s(j, _) + t * diff(j, _);

      // calcualte distance of projection and original point
      double di = sum(pow(n_test - p, 2.0));

      // if this is better than what was found earlier, store it
      if (di < bestdi) {
        bestdi = di;
        n = n_test;
        bestj = j;
        bestt = t;
      }
    }

    // save the best projection to the output data structures
    new_s(i, _) = n;
    lambda[i] = bestj + .1 + .9 * bestt;
    dist_ind[i] = bestdi;
  }

  // get ordering from old lambda
  IntegerVector new_ord = order(lambda);

  // calculate total dist
  double dist = sum(dist_ind);

  // calculate lambda for new_s
  NumericVector new_lambda(new_ord.length());
  new_lambda.attr("names") = rownames(x);

  for (int i = 1; i < new_ord.length(); ++i) {
    int o1 = new_ord[i];
    int o0 = new_ord[i - 1];
    NumericVector p1 = new_s(o1, _);
    NumericVector p0 = new_s(o0, _);
    new_lambda[o1] = new_lambda[o0] + sqrt(sum(pow(p1 - p0, 2.0)));
  }

  // return output
  List ret;
  ret["s"] = new_s;
  ret["ord"] = new_ord + 1;
  ret["lambda"] = new_lambda;
  ret["dist_ind"] = dist_ind;
  ret["dist"] = dist;

  ret.attr("class") = "principal_curve";

  return ret;
}
