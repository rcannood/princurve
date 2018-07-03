#include <Rcpp.h>
using namespace Rcpp;

typedef std::pair<int, double> paired;

bool cmp_second(const paired & left, const paired & right) {
  return left.second < right.second;
}

Rcpp::IntegerVector order(const Rcpp::NumericVector & x) {
  const size_t n = x.size();
  std::vector<paired> pairs;
  pairs.reserve(n);

  for(size_t i = 0; i < n; i++)
    pairs.push_back(std::make_pair(i, x(i)));

  std::sort(pairs.begin(), pairs.end(), cmp_second);

  Rcpp::IntegerVector result = Rcpp::no_init(n);
  for(size_t i = 0; i < n; i++)
    result(i) = pairs[i].first;
  return result;
}

// [[Rcpp::export]]
List project_to_curve_cpp(NumericMatrix x, NumericMatrix s, double stretch) {
  if (stretch > 0) {
    int n = s.nrow();
    NumericVector diff1 = s(0, _) - s(1, _);
    NumericVector diff2 = s(n - 1, _) - s(n - 2, _);
    s(0,_) = s(0,_) + stretch * diff1;
    s(n - 1,_) = s(n - 1,_) + stretch * diff2;
  }

  // calculate differences between subsequent points in s
  int num_segments = s.nrow() - 1;
  NumericMatrix diff(num_segments, s.ncol());
  NumericVector length(num_segments);
  NumericVector lengthsq(num_segments);
  NumericVector lengthcs(num_segments);

  double cs = 0.0;
  for (int i = 0; i < num_segments; ++i) {
    diff(i, _) = s(i + 1, _) - s(i, _);
    length[i] = sum(pow(diff(i, _), 2.0));
    lengthsq[i] = sqrt(length[i]);
    lengthcs[i] = cs;
    cs += lengthsq[i];
  }

  // OUTPUT DATA STRUCTURES
  // projections of x onto s
  NumericMatrix new_s(x.nrow(), x.ncol());

  // distance from start of the curve
  NumericVector lambda(x.nrow());

  // distances between x and new_s
  NumericVector dist_ind(x.nrow());

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
    lambda[i] = lengthcs[bestj] + bestt * lengthsq[bestj];
    dist_ind[i] = bestdi;
  }

  // get ordering from old lambda
  IntegerVector ord = order(lambda);

  // calculate total dist
  double dist = sum(dist_ind);

  // calculate lambda for new_s
  NumericVector new_lambda(ord.length());
  for (int i = 1; i < ord.length(); ++i) {
    int o1 = ord[i];
    int o0 = ord[i - 1];
    NumericVector p1 = new_s(o1, _);
    NumericVector p0 = new_s(o0, _);
    new_lambda[o1] = new_lambda[o0] + sqrt(sum(pow(p1 - p0, 2.0)));
  }

  // return output
  List ret;
  ret["s"] = new_s;
  ret["ord"] = ord + 1;
  ret["lambda"] = new_lambda;
  ret["dist_ind"] = dist_ind;
  ret["dist"] = dist;
  return ret;
}
