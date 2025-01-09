\name{bayesmixsurv}
\alias{bayesmixsurv}
\alias{print.bayesmixsurv}
\alias{bayesmixsurv.control}
\title{
Dynamic Bayesian survival model - with stratification and Lasso shrinkage - for right-censored data using two-component additive mixture-of-Weibull hazards.
}
\description{
Bayesian survival model for right-censored data, using a sum of two hazard functions, each having a power dependence on time, corresponding to a Weibull distribution on event density. (Note that event density function for the mixture model does NOT remain a Weibull distribution.) Each component has a different shape and scale parameter, with scale parameters each being the exponential of a linear function of covariates specified in \code{formula1} and \code{formula2}. Stratification is implemented using a common set of intercepts between the two components. Lasso shrinkage - using Laplace prior on coefficients (Park and Casella 2008) - allows for variable selection in the presence of low observation-to-variable ratio. The mixture model allows for time-dependent (and context-dependent) hazard ratios. Confidence intervals for coefficient estimation and prediction are generated using full Bayesian paradigm, i.e. by keeping all samples rather than summarizing them into mean and sd. Posterior distribution is estimated via MCMC sampling, using univariate slice sampler with stepout and shrinkage (Neal 2003).
}
\usage{
bayesmixsurv(formula1, data, formula2=formula1, stratCol=NULL, weights, subset
  , na.action=na.fail, control=bayesmixsurv.control(), print.level=2)
bayesmixsurv.control(single=FALSE, alpha2.fixed=NULL, alpha.boundary=1.0, lambda1=1.0
  , lambda2=lambda1, iter=1000, burnin=round(iter/2), sd.thresh=1e-4, scalex=TRUE
  , nskip=round(iter/10))
\method{print}{bayesmixsurv}(x, ...)
}
\arguments{
  \item{formula1}{Survival formula expressing the time/status variables as well as covariates used in the first component.}
  \item{data}{Data frame containing the covariates and response variable, as well as the stratification column.}
  \item{formula2}{Survival formula expressing the covariates used in the second component. No left-hand side is necessary since the response variable information is extracted from \code{formula1}. Defaults to \code{formula1}.}
  \item{stratCol}{Name of column in \code{data} used for stratification. Must be a factor or coerced into one. Default is no stratification (\code{stratCol=NULL}).}
  \item{weights}{Optional vector of case weights. *Not supported yet*}
  \item{subset}{Subset of the observations to be used in the fit. *Not supported yet*}
  \item{na.action}{Missing-data filter function. *Not supported yet (only na.fail behavior works)*}
  \item{control}{See \code{bayesmixsurv.control} for a description of the parameters inside the \code{control} list.}
  \item{print.level}{Controlling verbosity level.}
  \item{single}{If \code{TRUE}, a single-component model, equivalent to Bayesian Weibull survival regression, with Lasso shrinkage, is implemented. Default is \code{FALSE}, i.e. a two-component mixture-of-Weibull model.}
  \item{alpha2.fixed}{If provided, it specifies the shape parameter of the second component. Default is \code{NULL}, which allows the MCMC sampling to estimate both shape parameters.}
  \item{alpha.boundary}{When \code{single=FALSE} and \code{alpha2.fixed=NULL}, this parameter specifies an upper bound for the shape parameter of the first component, and a lower bound for the shape parameter of the second component. These boundary conditions are enforced in the univariate slice sampler function calls.}
  \item{lambda1}{Lasso Shrinkage parameter used in the Laplace prior on covariates used in the first component.}
  \item{lambda2}{Lasso Shrinkage parameter used in the Laplace prior on covariates used in the second component. Defaults to \code{lambda1}.}
  \item{iter}{Number of posterior MCMC samples to generate.}
  \item{burnin}{Number of initial MCMC samples to discard before calculating summary statistics.}
  \item{sd.thresh}{Threshold for standard deviation of a covariate (after possible centering/scaling). If below the threshold, the corresponding coefficient is removed from sampling, i.e. its value is clamped to zero.}
  \item{scalex}{If \code{TRUE}, each covariate vector is centered and scaled before model estimation. The scaling parameters are saved in return object, and used in subsequent calls to \code{predict} function. Users are strongly advised against turning this feature off, since the quality of Gibbs sampling MCMC is greatly enhanced by covariate centering and scaling.}
  \item{nskip}{Controlling how often to print progress report during MCMC run. For example, if \code{nskip=10}, progress will be reported after 10,20,30,... samples.}
  \item{x}{Object of class 'bayesmixsurv', usually the result of a call to \code{bayesmixsurv}.}
  \item{...}{Arguments to be passed to/from other methods.}
}
\value{
The function \code{bayesmixsurv.control} return a list with the same elements as its input parameters. The function \code{bayesmixsurv} returns object of class \code{bayesmixsurv}, with the following components:
\item{call}{The matched call}
\item{formula1}{Same as input.}
\item{formula2}{Same as input.}
\item{weights}{Same as input. *Not supported yet*}
\item{subset}{Same as input. *Not supported yet*}
\item{na.action}{Same as input. *Not supported yet* (current behavior is \code{na.fail})}
\item{control}{Same as input.}
\item{X1}{Model matrix used for component 1, after potential centering and scaling.}
\item{X2}{Model matrix used for component 2, after potential centering and scaling.}
\item{y}{Survival response variable (time and status) used in the model.}
\item{contrasts1}{The contrasts used for component 1 (where relevant).}
\item{contrasts2}{The contrasts used for component 2 (where relevant).}
\item{xlevels1}{A record of the levels of the factors used in fitting for component 1 (where relevant).}
\item{xlevels2}{A record of the levels of the factors used in fitting for component 2 (where relevant).}
\item{terms1}{The terms object used for component 1.}
\item{terms2}{The terms object used for component 2.}
\item{colnamesX1}{Names of columns for \code{X1}, also names of scale coefficients for component 1.}
\item{colnamesX2}{Names of columns for \code{X1}, also names of scale coefficients for component 2.}
\item{apply.scale.X1}{Index of columns of \code{X1} where scaling has been applied.}
\item{apply.scale.X2}{Index of columns of \code{X2} where scaling has been applied.}
\item{centerVec.X1}{Vector of centering parameters for columns of \code{X1} indicated by \code{apply.scale.X1}.}
\item{centerVec.X2}{Vector of centering parameters for columns of \code{X2} indicated by \code{apply.scale.X2}.}
\item{scaleVec.X1}{Vector of scaling parameters for columns of \code{X1} indicated by \code{apply.scale.X1}.}
\item{scaleVec.X2}{Vector of scaling parameters for columns of \code{X2} indicated by \code{apply.scale.X2}.}
\item{Xg}{Model matrix associated with stratification (if any).}
\item{stratContrasts}{The contrasts used for stratification model matrix, if any.}
\item{stratXlevels}{A record of the levels of the factors used in stratification (if any)).}
\item{stratTerms}{The terms object used for stratification.}
\item{colnamesXg}{Names of columns for \code{Xg}.}
\item{idx1}{Vector of indexes into \code{X1} for which sampling occured. All columns of \code{X1} whose standard deviation falls below \code{sd.thresh} are excluded from sampling and their corresponding coefficients are clamped to \code{0}.}
\item{idx2}{Vector of indexes into \code{X2} for which sampling occured. All columns of \code{X2} whose standard deviation falls below \code{sd.thresh} are excluded from sampling and their corresponding coefficients are clamped to \code{0}.}
\item{median}{List of median values, with elements including \code{alpha1,alpha2} (shape parameter of components 1 and 2), \code{beta1,beta2} (coefficients of scale parameter for components 1 and 2), \code{gamma} (stratification intercept adjustments, shared by 2 comoponents), and \code{sigma.gamma} (standard deviation of zero-mean Gaussian distribution that is the prior for \code{gamma}'s).}
\item{max}{Currently, a list with one element, \code{loglike}, containing the maximum sampled log-likelihood of the model.}

\item{smp}{List of coefficient samples, with elements \code{alpha1,alpha2} (shape parameters for components 1 and 2), \code{beta1,beta2} (scale parameter coefficients for components 1 and 2), \code{loglike} (model log-likelihood), \code{gamma} (stratification intercept adjustments, shared by 2 comoponents), and \code{sigma.gamma} (standard deviation of zero-mean Gaussian distribution that is the prior for \code{gamma}'s). Each parameter has \code{iter} samples. For vector parameters, first dimension is the number of samples (\code{iter}), while the second dimension is the length of the vector.}
}
\references{
Neal R.M. (2003). Slice Sampling. \emph{Annals of Statistics}, \bold{31}, 705-767.

Park T. and Casella G. (2008) The Bayesian Lasso. \emph{Journal of the American Statistical Association}, \bold{103}, 681-686.
}
\author{Alireza S. Mahani, Mansour T.A. Sharabiani}

\examples{
# NOTE: to ensure convergence, typically more than 100 samples are needed
# fit the most general model, with two Weibull components and unspecified shape parameters
ret <- bayesmixsurv(Surv(time, status)~as.factor(trt)+age+as.factor(celltype)+prior, veteran
  , control=bayesmixsurv.control(iter=100))
# fix one of the two shape parameters
ret2 <- bayesmixsurv(Surv(time, status)~as.factor(trt)+age+as.factor(celltype)+prior, veteran
    , control=bayesmixsurv.control(iter=100, alpha2.fixed=1.0))
}
%%\keyword{ ~kwd1 }
%%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
