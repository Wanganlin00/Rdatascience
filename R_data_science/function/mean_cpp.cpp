#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
double mean_cpp(NumericVector x) {     //  NumericVector  IntegerVector CharacterVector LogicalVector
    int i;
    int n = x.size();
    double mean = 0;
    
    for(i = 0; i < n; i=i+1) {
        mean = mean + x[i] / n;
    }
    return mean;
}


// R测试代码

/*** R
x=c(1,2,3,4,5)
mean_cpp(x)
*/
