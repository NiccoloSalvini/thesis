# INLA computation {#inla}



INLA [@Rue2009] stands for Integrated Nested Laplace approximation and constitutes a computational alternative to traditional MCMC methods. INLA does approximate Bayesian inference on special type of models called LGM (Latent Gaussian Models) due to the fact that they are _computationally_ convenient. The benefits are many, some among the other are:

- Low computational costs, even for large models.
- It provides high accuracy.
- Can define very complex models within that framework.
- Most important statistical models are LGM.
- Very good support for spatial models.
- Implementation of spatio-temporal model enabled.

INLA uses a combination of analytics approximations and numerical integration to obtain an approximated posterior distribution of the parameters in a shorter time period.
The chronologic steps in the methodology presentation follows the course sailed by @Moraga2019 blended with the author choice to skip details. As a matter of fact the aim of the chapter is to provide a comprehensive intuition oriented to the immediate application of the methodology, without stepping too long on mathematical details. By the way details e.g model assessment and control options are handled under the hood by the package and can be tuned within the main function, most of them are covered by @Bayesian_INLA_Rubio. Notation is imported from @Blangiardo-Cameletti and @Bayesian_INLA_Rubio, and quite differ from the one presented in the original paper by Rue, Chopin and Martino -@Rue2009. As further notation remarks: bold symbols are considered as vectors, so each time they occur they have to be considered like the _ensamble_ of their values. In addition $\tilde\pi$ in section \@ref(approx) are the Laplace approximation of the underlying integrals. Moreover the inner functioning of Laplace approximation and its special usage within the INLA setting is far from the scope, but an easy shortcut oriented to INLA is in @Blangiardo-Cameletti.

INLA can fit only Latent Gaussian type of models and the following work tries to encapsulate its properties. Then afterwards a problem can be reshaped into the LGM framework with the explicit purpose to explore its benefits. When models are reduced to LGMs then joint posterior distribution can be rewritten and then approximated with INLA. A hierarchical bayesian structure on the model will help to integrate many parameter and hyperparameter levels and simplify interpretation.
Generic Information on the project and the R-INLA package are contained in the introduction to last section \@ref(inla). In the end a brief application on a toy spatial dataset is proposed with the aim to fasten the familiarity with the methodology and to come to grip with INLA results.

## Latent Gaussian Models LGM{#LGM}

Given some observations $y_{i \ldots n}$ in order to define a Latent Gaussain Model within the bayesian framework it is convenient to specify at first an  _exponential family_ (Gaussian, Poisson, Exponential...) distribution function characterized by some parameters $\phi_{i}$ (usually expressed by the mean $\left.E\left(y_{i}\right)\right)$) and some other hyper-parameters $\psi_{k} ,\forall k \in \ 1\ldots K$. The parameter $\phi_{i}$ can be defined as an additive _latent linear predictor_ $\eta_{i}$, as pointed out by Krainski and Rubio (-@Krainski-Rubio) through a link function $g(\cdot)$, i.e. $g\left(\phi_{i}\right)=\eta_{i}$. A comprehensive expression of the linear predictor takes into account all the possible effects on covariates

$$
\eta_{i}=\beta_{0}+\sum_{m=1}^{M} \beta_{m} x_{m i}+\sum_{l=1}^{L} f_{l}\left(z_{l i}\right)
$$

where $\beta_{0}$ is the intercept, $\boldsymbol{\beta}=\left\{\beta_{1}, \ldots, \beta_{M}\right\}$ are the coefficient that quantifies the linear effects on covariates $\boldsymbol{x}=\left({x}_{1}, \ldots, {x}_{M}\right)$ and $f_{l}(\cdot), \forall l \in 1 \ldots L$ are a set of random effects defined in terms of a $\boldsymbol{z}$ set of covariates $\boldsymbol{z}=\left(z_{1}, \ldots, z_{L}\right)$ (e.g. rw, ar1). As a consequence of the last assumption the class of LGM  can receive a wide range of models e.g. GLM, GAM, GLMM, linear models and spatio-temporal models. This constitutes one of the main advantages of INLA, which can fit many different models, starting from simpler and ending with more complex. Contributors recently are extending the methodology to many areas as well as models moreover they are trying to incorporate INLA with non gaussian latent models as Rubio -@Bayesian_INLA_Rubio pointed out.
All the latent components can be conveniently grouped into a variable denoted with $\boldsymbol{\theta}$ such that: $\boldsymbol{\theta}=\left\{\beta_{0}, \boldsymbol{\beta}, f\right\}$ and the same can de done for hyper parameters $\boldsymbol{\psi} = \left\{\psi_{1}, \ldots, \psi_{K}\right\}$. 
Then the probability distribution conditioned to parameters and hyper parameters is then:

$$
y_{i} \mid \boldsymbol{\theta}, \boldsymbol{\psi} \sim \pi\left(y_{i} \mid \boldsymbol{\theta},\boldsymbol{\psi}\right)
$$

Since data $\left(y_{1}, \ldots, y_{n}\right)$ is drawn by the same distribution family but it is conditioned to parameters which are conditional independent  (i.e. $\pi\left(\theta_{i}, \theta_{j} \mid \theta_{-i, j}\right)=\pi\left(\theta_{i} \mid \theta_{-i, j}\right) \pi\left(\theta_{j} \mid \theta_{-i, j}\right)$) [@GMRFRue] then the joint distribution is given by the product of all the independent parameters i.e. the likelihood. Moreover the Product operator index $i$ ranges from 1 to $n$, i.e.  $\mathbf{I} = \left\{1 \ldots n \right\}$. When an observation is missing so the corresponding $i \notin \mathbf{I}$ INLA automatically will not include it in the model avoiding errors -@Bayesian_INLA_Rubio. As a consequence the likelihood expression is:

\begin{equation}
\pi(\boldsymbol{y} \mid \boldsymbol{\theta}, \boldsymbol{\psi})=\prod_{i \in \mathbb{I}} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)
(\#eq:likelihood)
\end{equation}

Each data point is connected to one combination $\theta_{i}$ out of all the possible linear combinations of elements in $\boldsymbol{\theta}$ _latent field_. The latent aspect of the field regards the undergoing existence of many parameter combination alternatives. Furthermore hyper parameters are by definition independent, in other words $\boldsymbol{\psi}$ will be the product of many univariate priors [@Bayesian_INLA_Rubio]. A Multivariate Normal distribution is imposed on the latent field $\boldsymbol{\theta}$ such that it is centered in 0 with precision matrix $\boldsymbol{Q(\psi)}$ (the inverse of the covariance matrix $\boldsymbol{Q}^{-1}(\boldsymbol{\psi})$)  depending only on $\boldsymbol{\psi}$ hyper parameter vector i.e., $\boldsymbol{\theta} \sim \operatorname{Normal}\left(\mathbf{0}, \boldsymbol{Q}^{-1}(\boldsymbol{\psi})\right)$. As a notation remark some authors choose to keep the covariance matrix expression as $\boldsymbol{Q}$ and its inverse precision matrix as $\boldsymbol{Q}^{-1}$. This is strongly not encouraged fro two reasons: the first is that the default hyperpramater option in INLA R package uses the precision matrix, the second it over complicates notation when writing down conditional expectation as Rue pointed out _miss lit_. However notation for covariance function introduced in chapter \@ref(Matern) i.e. Matérn  has to be expressed through covariance matrix, this passage will be cleared out in the dedicated section so that confusion is avoided.
The exponential family density function is then expressed through: 

\begin{equation}
\pi(\boldsymbol{\theta} \mid \boldsymbol{\psi})=(2 \pi)^{-n / 2}| \boldsymbol{Q(\psi)}|^{1 / 2} \exp \left(-\frac{1}{2} \boldsymbol{\theta} \boldsymbol{Q(\psi)} \boldsymbol{\theta}\right)
(\#eq:gmrf)
\end{equation}

The conditional independence assumption on the latent field $\boldsymbol{\theta}$ leads $\boldsymbol{Q(\psi)}$ to be a sparse precision matrix since for a general pair of combinations $\theta_{i}$ and $\theta_{j}$ the resulting element in the precision matrix is 0 i.e. $\theta_{i} \perp \theta_{j} \mid \theta_{-i, j} \Longleftrightarrow Q_{i j}(\boldsymbol{\psi})=0$ -@Blangiardo-Cameletti. 
A probability distribution function with those characteristics is said _Gaussian Markov random field_ (**GMRF**). GMRF as a matter of fact are Gaussian variables with Markov properties which are encoded in the precision matrix $\boldsymbol{Q}$ [@Rue2009]. (puoi dire di più)
From here it comes the source of run time computation saving, inherited using GMRF for inference. As a consequence of GMRF representation of the latent field, matrices are sparse so numerical methods can be exploited [@Blangiardo-Cameletti]. _Moreover when Gaussian Process (see chapter \@ref(GP)), which are used to integrate spatial components, are represented as GMRF through SPDE (Stochastic Partial Differential Equations) approach, then INLA can be used as a computing choice. This last assumption will be framed in chapter \@ref(inla) and verified in chapter \@ref(spde)._
Once priors distributions are specified for $\boldsymbol{\psi}$ then the joint posterior distribution for $\boldsymbol{\theta}$ and $\boldsymbol{\psi}$ is

$$
\pi(\boldsymbol{\theta}, \boldsymbol{\psi} \mid y)\propto  \underbrace{\pi(\boldsymbol{\psi})}_{\text {prior }} \times \underbrace{\pi(\theta \mid \psi)}_{\text {GMRF }} \times \underbrace{\prod_{i=1}^{n} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)}_{\text {likelihood }}
$$

Last expression is said a Latent Gaussian Models, **LGM**, if the whole set of assumptions imposed since now are met. Therefore all models that can be reduced to a LGM representation are able to host INLA methodology.
Then plugging in the _likelihood_ \@ref(eq:likelihood) and _GMRF_ \@ref(eq:gmrf) expression the posterior distribution can be rewritten as


$$
\begin{aligned}
\pi(\boldsymbol{\theta}, \boldsymbol{\psi} \mid y) & \propto \pi(\boldsymbol{\psi}) \times \pi(\boldsymbol{\theta} \mid \boldsymbol{\psi}) \times \pi(y \mid \boldsymbol{\theta}, \boldsymbol{\psi}) \\
& \propto \pi(\boldsymbol{\psi}) \times \pi(\boldsymbol{\theta} \mid \boldsymbol{\psi}) \times \prod_{i=1}^{n} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right) \\
& \propto \pi(\boldsymbol{\psi}) \times|\boldsymbol{Q}(\boldsymbol{\psi})|^{1 / 2} \exp \left(-\frac{1}{2} \boldsymbol{\theta}^{\prime} \boldsymbol{Q}(\boldsymbol{\psi}) \boldsymbol{\theta}\right) \times \prod_{i}^{n} \exp \left(\log \left(\pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)\right)\right)
\end{aligned}
$$

And by joining exponents by their multiplicative property it is obtained

\begin{equation}
\pi(\boldsymbol{\theta}, \boldsymbol{\psi} \mid y) \propto \pi(\psi) \times|\boldsymbol{Q}(\boldsymbol{\psi})|^{1 / 2} \exp \left(-\frac{1}{2} \boldsymbol{\theta}^{\prime} \boldsymbol{Q}(\boldsymbol{\psi}) \boldsymbol{\theta}+\sum^{n} \log \left(\pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)\right)\right)
(\#eq:jointpostdistr)
\end{equation}


## Approximation in INLA setting{#approx}

INLA is not going to try to estimate the whole posterior distribution from expression \@ref(eq:jointpostdistr). Instead it will try to estimate the posterior marginal distribution effects for each $\theta_{i}$ combination in the latent parameter $\boldsymbol{\theta}$, given the hyper parameter priors specification $\psi_{k}$. Proper estimation methods however are beyond the scope of the analysis, further excellent references are suggested in their respective part by Rubio -@Bayesian_INLA_Rubio in section 2.2.2  and Blangiardo & Cameletti -@Blangiardo-Cameletti in section 4.7.2. 
The marginal posterior distribution function for each latent parameter element $\theta_{i}$ is

\begin{equation}
  \pi(\theta_{i} \mid \boldsymbol{y})=\int \pi(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \mathbf{y}) \pi(\boldsymbol{\psi} \mid \mathbf{y}) d \psi
(\#eq:latentparam)
\end{equation}

The posterior marginal integral for each hyper parameter $\psi_{k}, \forall k \in 1, \ldots, K $ is


$$
\pi\left(\psi_{k} \mid y\right)=\int \pi(\boldsymbol{\psi} \mid y) d \psi_{-k}
$$

where the notation $\psi_{-k}$ is a vector of hyper parameters $\psi$ without considering $k$th element $\psi_{k}$.

The goal is to have approximated solution for latent parameter posterior distributions. To this purpose A *hierarchical procedure* is now imposed since the "lower" hyper parameter integral, whose approximation for the moment does not exist, is nested inside the "upper" parameter integral that takes hyper param as integrand. Hierarchical structures are welcomed very warmly since they are convenient later in order to fit a hierarchical bayesian model approached in the next chapter \@ref(hiermod). While many approximation strategies are provided and many others are emerging for both the hyper param and for the latent field, the common ground remains to unnest the structure in two steps such that:

- step 1: compute the Laplace approximation $\tilde\pi\left(\boldsymbol{\psi} \mid \boldsymbol{y}\right)$  for each hyper parameters marginal: $\tilde\pi\left(\psi_{k} \mid \boldsymbol{y}\right)$
- step 2: compute Laplace approximation $\tilde{\pi}\left(\theta_{i} \mid \boldsymbol{\psi}, \boldsymbol{y}\right)$ marginals for the parameters given the hyper parameter approximation in step 1: $\tilde{\pi}\left(\theta_{i} \mid \boldsymbol{y}\right) \approx \int \tilde{\pi}\left(\theta_{i} \mid \boldsymbol{\psi}, \boldsymbol{y}\right) \underbrace{\tilde{\pi}(\boldsymbol{\psi} \mid \boldsymbol{y})}_{\text {Estim. in step 1 }} \mathrm{d} \psi$

Then plugging approximation in the integral observed in \@ref(eq:latentparam) it is obtained:

$$
\tilde{\pi}\left(\theta_{i} \mid y\right) \approx \int \tilde{\pi}\left(\theta_{i} \mid  \boldsymbol{\psi}, y\right) \tilde{\pi}(\boldsymbol{\psi} \mid y) \mathrm{d} \psi
$$

In the end INLA by its default approximation strategy thrpugh  _simplified Laplace approximation_  uses the following numerical approximation to compute marginals: 

$$
\tilde{\pi}\left(\theta_{i} \mid y\right) \approx \sum_{j} \tilde{\pi}\left(\theta_{i} \mid \boldsymbol{\psi}^{(j)}, y\right) \tilde{\pi}\left(\boldsymbol{\psi}^{(j)} \mid y\right) \Delta_{j}
$$

where {$\boldsymbol{\psi}^{(j)}$} are a set of values of the hyper param $\psi$ grid used for numerical integration, each of which associated to a specific weight $\Delta_{j}$. The more the weight $\Delta_{j}$ is heavy the more the integration point is relevant. Details on how INLA finds those points is beyond the scope, but the strategy and grids seraches are offered in the appendix follwing both Rubio and Blangiardo.


### further approximations (prolly do not note include)

INLA focus on this specific integration points by setting up a regular grid about the posterior mode of $\psi$ with CCD (central composite design) centered in the mode [@Bayesian_INLA_Rubio].

![CCD to spdetoy dataset, source @Blangiardo-Cameletti](images/CCDapplied.PNG)

The approximation $\tilde{\pi}\left(\theta_{i} \mid y\right)$ can take different forms and be computed in different ways. @Rue2009 also discuss how this approximation should be in order to reduce the numerical error [@Krainski-Rubio].

Following @Bayesian_INLA_Rubio,  approximations of the joint posterior for the hyper paramer $\tilde\pi\left(\psi_{k} \mid \boldsymbol{y}\right)$  is used to compute the marginals for the latent effects and hyper parameters in this way: 

$$
\left.\tilde{\pi}(\boldsymbol{\psi} \mid \mathbf{y}) \propto \frac{\pi(\boldsymbol{\theta}, \boldsymbol{\psi}, y)}{\tilde{\pi}_{G}(\boldsymbol{\theta} \mid \boldsymbol{\psi}, y)}\right|_{\boldsymbol{\theta}=\boldsymbol{\theta}^{*}(\boldsymbol{\psi})}
$$

In the previous equation $\tilde{\pi}_{G}(\boldsymbol{\theta} \mid \boldsymbol{\psi}, y)$ is a gaussian approximation to the full condition of the latent effect ${\theta}^{*}(\boldsymbol{\psi})$ is the mode for a given value of the hyper param vector $\boldsymbol{\psi}$ 

At this point there exists three types of approximations for $\pi\left(\boldsymbol{\theta} \mid \boldsymbol{\psi}, y\right)$

- first with a gaussian approximation, estimating mean $\mu_{i}(\boldsymbol{\psi})$ and variance $\sigma_{i}^{2}(\boldsymbol{\psi})$. 
- second using the _Laplace Approximation._ 
- third using _simplified Laplace Approximation_

(rivedere meglio)

## R-INLA package in a bayesian hierarchical regression perspective{#rinla}

### Overview

INLA computations and methodology is developed by the R-INLA project whose package is available on their [website](http://www.r-inla.org). Download is not on CRAN (the Comprehensive R Archive Network) so a special source repo link, which is maintained by authors and collaborators, has to be optioned. The website offers also a forum where a daily discussion group is opened and an active community is keen to answer. Moreover It also contains a number of reference books, among which some of them are fully open sourced as gitbook. Furthermore as Havaard Rue has pointed out in a web-lecture on the topic, the project is gaining importance due to its new applications and recent use cases, but by no means it is replacing the older MCMC methods, rather INLA can integrate pre existing procedures.
The core function of the package is `inla()`and it works as many other regression functions like `glm()`, `lm()` or `gam()`. Inla function takes as arguments the formula (where are response and linear predictor), the data (expects a data.frame obj) on which estimation is desired together with the distribution of the data. Many other methods inside the function can be added through lists, such as `control.family` and `control.fixed` which let the analyst specifying priors distribution both for $\boldsymbol{\theta}$ parameters, $\boldsymbol{\psi}$ hyper parameters and the outcome precision $\tau$, default values are non-informative.
`control.fixed` as said regulates prior specification through a plain list when there only a single fixed effect, instead it does it with nested lists when fixed effects are greater than 2, a guided example might better display the behaviour:
`control.fixed = list(mean = list(a = 1, b = 2, default = 0))`
In the chuck above it is assigned prior mean equal to 1 for fixed effect "a" and equal 2 for "b"; the rest of the prior means are set equal to 0.
Inla objects are inla.dataframe summary-type lists containing the results from model fitting. Results contained in the object are specified in the table below, even though some of them requires special method: (se riesco più elegante in kable)
Following Krainski & Rubio -@Krainski-Rubio observations $y(s_{1}), \ldots, y(s_{n})$ are taken from a toy generated dataset and a hierarchical linear regression is fitted. 

![summary table list object, source: @Krainski-Rubio ](images/summarytable.PNG)


### Linear Predictor{#example}

SPDEtoy dataset, that has a spatial component, is generated from a $y_{i}$ Gaussian variable; its moments are $\mu_{i}$ and precision $\tau$.


![SPDEtoy plot, author's source](images/cotour_toy.png)

The formula that describe the linear predictor has to be called directly inside the `inla()` function or it can be stored in the environment into a variable. The mean moment in the gaussian distribution $\mu_{i}$ is expressed as the _linear predictor_ $\eta_{i}$ (i.e. $E\left(y_{i} \mid \beta_{0}, \ldots, \beta_{M}, x_{i 1}, \ldots, x_{i M}\right) = \eta_{i}$ ). The function that maps the linear predictor into the parameter space is identity as in the initial part of section \@ref(LGM) i.e. $\eta_{i}=\beta_{0}+\sum_{m=1}^{M} \beta_{m} x_{m i}+\sum_{l=1}^{L} f_{l}\left(z_{l i}\right)$. 
After including $s_{1}$ and $s_{2}$ spatial covariates the linear predictor takes the following form: $\beta_{0}+\beta_{1} s_{1 i}+\beta_{2} s_{2 i}$, where once again $\beta_{0}$ is the fixed effect i.e. intercept and the $\beta_{j}$ are the linear effect on covariates. INLA allows also to include non-linear effects with the `f()` method inside the formula. `f` are foundamental since they are used to incorporate the spatial component in the model through the Matérn covariance function, this will be shown in section (boh).
Once the formula is decided then priors has to be picked up; for the intercept a customary choice is uniform. Prior for Gaussian latent parameters are vague and they have 0 mean and 0.001 precision, then the prior for $\tau$ is a Gamma with parameters 1 and 0.00005. Prior initial choice can be later adapted.

The summary of the model parameters is:

$$
\begin{aligned}
y_{i} & \sim N\left(\mu_{i}, \tau^{-1}\right), i=1, \ldots, 200 \\
\mu_{i} &=\beta_{0}+\beta_{1} s_{1 i}+\beta_{2} s_{2 i} \\
\beta_{0} & \sim \text { Uniform } \\
\beta_{j} & \sim N\left(0,0.001^{-1}\right), j=1,2 \\
\tau & \sim G a(1,0.00005)
\end{aligned}
$$



```r
data("SPDEtoy")
formula = y ~ s1 + s2
m0 = inla(formula, data = SPDEtoy)
```



\begin{tabular}{lrrrrrrr}
\toprule
  & mean & sd & 0.025quant & 0.5quant & 0.975quant & mode & kld\\
\midrule
(Intercept) & 10.1321487 & 0.2422118 & 9.6561033 & 10.1321422 & 10.6077866 & 10.1321497 & 7e-07\\
s1 & 0.7624296 & 0.4293757 & -0.0814701 & 0.7624179 & 1.6056053 & 0.7624315 & 7e-07\\
s2 & -1.5836768 & 0.4293757 & -2.4275704 & -1.5836906 & -0.7404955 & -1.5836811 & 7e-07\\
\bottomrule
\end{tabular}


The output offers among the others a summary of the posterior marginal values for intercept, coefficient and covariates, as well as precision. Below the plots for the parameters and hyperparameters. From the summary it can be seen that the mean for s2 is negative, so the more the value of the y-coordinates increases the more the output decreases, that is truer looking at the SPDEtoy cotour plot. Plots can be generated by calling the `plot` function on the inla object, however the one generated below are `ggplot2` outputs coming from the $marginals.fixed list object. 

![linear predictor marginals, author's creation](images/marginal_distr.png)



R-Inla also has r-base fashion function to compute statistics on marginal posterior distributions for the density, distribution as well as the quantile function respectively `inla.dmarginal`, `inla.pmarginal` and `inla.qmarginal`. One major option which is conveniently packed into a dedicated function computes the higher posterior density credibility interval `inla.hpdmarginal` for a given covariate's coefficient, such that $\int_{q_{1}}^{q_{2}} \tilde{\pi}\left(\beta_{2} \mid \boldsymbol{y}\right) \mathrm{d} \beta_{2}=0.90$ zwith .1 Confidence Level, in table \@ref(tab:higer_posterior_density_interval).


\begin{tabular}{lrr}
\toprule
  & low & high\\
\midrule
level:0.9 & -2.291268 & -0.879445\\
\bottomrule
\end{tabular}

Recall that the interpretation is different from the frequentist: in Bayesian statistics $\beta_{j}$ comes from probability distribution, while frequenstists considers $\beta_{j}$ as fixed unknown quantity whose estimator (random variable conditioned to data) is used to infer the value -@Blangiardo-Cameletti.

