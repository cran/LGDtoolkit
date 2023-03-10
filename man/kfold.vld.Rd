% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/08_KFOLD_VLD.R
\name{kfold.vld}
\alias{kfold.vld}
\title{K-fold model cross-validation}
\usage{
kfold.vld(model, k = 10, seed = 1984)
}
\arguments{
\item{model}{Model in use, an object of class inheriting from \code{"lm"}}

\item{k}{Number of folds. If \code{k} is equal or greater than the number of observations of
modeling data frame, then validation procedure is equivalent to leave one out cross-validation (LOOCV)
method. For LOOCV, R-squared is not calculated. Default is set to 10.}

\item{seed}{Random seed needed for ensuring the result reproducibility. Default is 1984.}
}
\value{
The command \code{kfold.vld} returns a list of two objects.\cr
The first object (\code{iter}), returns iteration performance metrics.\cr
The second object (\code{summary}), is the data frame of iterations averages of performance metrics.
}
\description{
\code{kfold.vld} performs k-fold model cross-validation.
The main goal of this procedure is to generate main model performance metrics such as absolute mean
square error, root mean square error or R-squared based on resampling method. Note that functions' argument
model accepts \code{"lm"} and \code{"glm"} class but for \code{"glm"} only \code{"quasibinomial("logit")"}
family will be considered.
}
\examples{
library(monobin)
library(LGDtoolkit)
data(lgd.ds.c)
#discretized some risk factors
num.rf <- c("rf_01", "rf_02", "rf_03", "rf_09", "rf_16")
for	(i in 1:length(num.rf)) {
num.rf.l <- num.rf[i]
lgd.ds.c[, num.rf.l] <- sts.bin(x = lgd.ds.c[, num.rf.l], y = lgd.ds.c[, "lgd"])[[2]]	
}
str(lgd.ds.c)
#run linear regression model
reg.mod.1 <- lm(lgd ~ ., data = lgd.ds.c[, c(num.rf, "lgd")])
summary(reg.mod.1)$coefficients
#perform k-fold validation
LGDtoolkit::kfold.vld(model = reg.mod.1 , k = 10, seed = 1984)
#run fractional logistic regression model
lgd.ds.c$lgd[lgd.ds.c$lgd > 1] <- 1
reg.mod.2 <- glm(lgd ~ ., family = quasibinomial("logit"), data = lgd.ds.c[, c(num.rf, "lgd")])
summary(reg.mod.2)$coefficients
LGDtoolkit::kfold.vld(model = reg.mod.2 , k = 10, seed = 1984)
}
