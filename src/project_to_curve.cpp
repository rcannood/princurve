#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
List project_to_curve_cpp(NumericMatrix x, NumericMatrix s, double stretch) {


  List ret;
  ret["s"] = NULL;
  ret["ord"] = NULL;
  ret["lambda"] = NULL;
  ret["dist_ind"] = NULL;
  ret["dist"] = NULL;
  return ret;
}
