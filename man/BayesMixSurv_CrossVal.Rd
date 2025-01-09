\name{bayesmixsurv.crossval}
\alias{bayesmixsurv.crossval}
\alias{bayesmixsurv.crossval.wrapper}
\alias{bayesmixsurv.generate.folds}
\alias{bayesmixsurv.generate.folds.eventbalanced}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Convenience functions for cross-validation-based selection of shrinkage parameter in the bayesmixsurv model.}
\description{
\code{bayesmixsurv.crossval} calculates cross-validation-based, out-of-sample log-likelihood of a bsgw model for a data set, given the supplied folds. \code{bayesmixsurv.crossval.wrapper} applies \code{bayesmixsurv.crossval} to a set of combinations of shrinkage parameters (\code{lambda1},\code{lambda2}) and produces the resulting vector of log-likelihood values as well as the specific combination of shrinkage parameters associated with the maximum log-likelihood. \code{bayesmixsurv.generate.folds} generates random partitions, while \code{bayesmixsurv.generate.folds.eventbalanced} generates random partitions with events evenly distributed across partitions. The latter feature is useful for cross-valiation of small data sets with low event rates, since it prevents over-accumulation of events in one or two partitions, and lack of events altogether in other partitions.
}
\usage{
bayesmixsurv.generate.folds(ntot, nfold=5)
bayesmixsurv.generate.folds.eventbalanced(formula, data, nfold=5)
bayesmixsurv.crossval(data, folds, all=FALSE, print.level=1
  , control=bayesmixsurv.control(), ...)
bayesmixsurv.crossval.wrapper(data, folds, all=FALSE, print.level=1
  , control=bayesmixsurv.control(), lambda.min=0.01, lambda.max=100, nlambda=10
  , lambda1.vec=exp(seq(from=log(lambda.min), to=log(lambda.max), length.out = nlambda))
  , lambda2.vec=NULL
  , lambda12=if (is.null(lambda2.vec)) cbind(lambda1=lambda1.vec, lambda2=lambda1.vec)
    else as.matrix(expand.grid(lambda1=lambda1.vec, lambda2=lambda2.vec)), plot=TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ntot}{Number of observations to create partitions for. It must typically be set to \code{nrow(data)}.}
  \item{nfold}{Number of folds or partitions to generate.}
  \item{formula}{Formula specifying the covariates to be used in component 1, and the time/status response variable in the survival model.}
  \item{data}{Data frame containing the covariates and response, used in training and prediction.}
  \item{folds}{An integer vector of length \code{nrow(data)}, defining fold/partition membership of each observation. For example, in 5-fold cross-validation for a data set of 200 observations, \code{folds} must be a 200-long vector with elements from the set \code{{1,2,3,4,5}}. Convenience functions \code{bayesmixsurv.generate.folds} and \code{bayesmixsurv.generate.folds.eventbalanced} can be used to generate the \code{folds} vector for a given survival data frame.}
  \item{all}{If \code{TRUE}, estimation objects from each cross-validation task is collected and returned for diagnostics purposes.}
  \item{print.level}{Verbosity of progress report.}
  \item{control}{List of control parameters, usually the output of \link{bayesmixsurv.control}.}
  \item{lambda.min}{Minimum value used to generate \code{lambda.vec}.}
  \item{lambda.max}{Maximum value used to generate \code{lambda.vec}.}
  \item{nlambda}{Length of \code{lambda.vec} vector.}
  \item{lambda1.vec}{Vector of shrinkage parameters to be tested for component-1 coefficients.}
  \item{lambda2.vec}{Vector of shrinkage parameters to be tested for component-2 coefficients.}
  \item{lambda12}{A data frame that enumerates all combinations of \code{lambda1} and \code{lambda2} to be tested. By default, it is constructed from forming all permutations of \code{lambda1.vec} and \code{lambda2.vec}. If \code{lambda2.vec=NULL}, it will only try equal values of the two parameters in each combination.}
  \item{plot}{If \code{TRUE}, and if the \code{lambda1} and \code{lambda2} entries in \code{lambda12} are identical, a plot of \code{loglike} as a function of either vector is produced.}
  \item{...}{Further arguments passed to \code{bayesmixsurv}.}
}
\value{
Functions \code{bayesmixsurv.generate.folds} and \code{bayesmixsurv.generate.folds.eventbalanced} produce integer vectors of length \code{ntot} or \code{nrow(data)} respectively. The output of these functions can be directly passed to \code{bayesmixsurv.crossval} or \code{bayesmixsurv.crossval.wrapper}. Function \code{bayesmixsurv.crossval} returns the log-likelihood of data under the assumed bsgw model, calculated using a cross-validation scheme with the supplied \code{fold} parameter. If \code{all=TRUE}, the estimation objects for each of the \code{nfold} estimation jobs will be returned as the "estobjs" attribute of the returned value. Function \code{bayesmixsurv.crossval.wrapper} returns a list with elements \code{lambda1} and \code{lambda2}, the optimal shrinkage parameters for components 1 and 2, respectively. Additionally, the following attributes are attached:
\item{loglike.vec}{Vector of log-likelihood values, one for each tested combination of \code{lambda1} and \code{lambda2}.}
\item{loglike.opt}{The maximum log-likelihood value from the \code{loglike.vec}.}
\item{lambda12}{Data frame with columns \code{lambda1} and \code{lambda2}. Each row of this data frame contains one combination of shrinkage parameters that are tested in the wrapper function.}
\item{estobjs}{If \code{all=TRUE}, a list of length \code{nrow(lambda12)} is returned, with each element being itself a list of \code{nfold} estimation objects associated with each call to the \code{bayesmixsurv} function. This object can be examined by the user for diagnostic purposes, e.g. by applying \code{plot} against each object.}
}

\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\examples{
# NOTE: to ensure convergence, typically more than 30 samples are needed
folds <- bayesmixsurv.generate.folds.eventbalanced(Surv(futime, fustat) ~ 1, ovarian, 5)
cv <- bayesmixsurv.crossval(ovarian, folds, formula1=Surv(futime, fustat) ~ ecog.ps + rx
  , control=bayesmixsurv.control(iter=30, nskip=10), print.level = 3)
cv2 <- bayesmixsurv.crossval.wrapper(ovarian, folds, formula1=Surv(futime, fustat) ~ ecog.ps + rx
  , control=bayesmixsurv.control(iter=30, nskip=10)
  , lambda1.vec=exp(seq(from=log(0.1), to=log(1), length.out = 3)))
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%%\keyword{ ~kwd1 }
%%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
