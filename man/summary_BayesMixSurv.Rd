\name{summary.bayesmixsurv}
\alias{summary.bayesmixsurv}
\alias{print.summary.bayesmixsurv}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Summarizing BayesMixSurv model fits
}
\description{
\code{summary} method for class "bayesmixsurv".
}
\usage{
\method{summary}{bayesmixsurv}(object, pval = 0.05, burnin = object$control$burnin, ...)
\method{print}{summary.bayesmixsurv}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{An object of class 'bayesmixsurv', usually the result of a call to \link{bayesmixsurv}.}
  \item{x}{An object of class "summary.bayesmixsurv", usually the result of a call to \code{summary.bayesmixsurv}.}
  \item{pval}{Desired p-value, based on which lower/upper bounds will be calculated. Default is 0.05.}
  \item{burnin}{Number of samples to discard from the beginning of each MCMC chain before calculating median and lower/upper bounds.}
  \item{...}{Further arguments to be passed to/from other methods.}
}
\value{
An object of class \code{summary.bayesmixsurv}, with the following elements:
  \item{call}{The matched call.}
  \item{pval}{Same as input.}
  \item{burnin}{Same as input.}
  \item{single}{Copied from \code{object$control$single}. See \link{bayesmixsurv.control} for explanation.}
  \item{coefficients}{A list including matrices \code{alpha}, \code{beta1}, \code{beta2}, and \code{gamma} (if stratification is used). Each matrix has columns named 'Estimate', 'Lower Bound', 'Upper Bound', and 'P-val'. \code{alpha} has two rows, one for each components, while each of \code{beta1} and \code{beta2} has one row per covariate. \code{gamma} has one row per stratum (except for the reference stratum).}
}

\author{Alireza S. Mahani, Mansour T.A. Sharabiani}
\seealso{
See \link{summary} for a description of the generic method. 

The model fitting function is \link{bayesmixsurv}.
}
\examples{
est <- bayesmixsurv(Surv(futime, fustat) ~ ecog.ps + rx, ovarian
            , control=bayesmixsurv.control(iter=800, nskip=100))
summary(est, pval=0.1)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%%\keyword{ ~kwd1 }
%%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
