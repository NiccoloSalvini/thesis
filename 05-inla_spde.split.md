
# INLA bayesian computation {#inla-spde}

INLA [@Rue2009] stands for Integrated Nested Laplace approximation and constitutes an computational alternative to traditional MCMC method. INLA does approximate bayesian inference on special type of models called LGM latent gaussian models due to the fact that they are _computationally_ convenient. The benefits are many:
- low computational costs, even for large models-
- it provides high accuracy 
- can define very comolex models within that framework 
- most important statistical models are LGM (latent gaussian models)
- very good support for spatial models
[ puoi parlare del big-O problem, puoi pa]

INLA uses a combination of analytics approximations and numerical integration to obtain an approximated posterior distribution of the parameters much faster.
The combination of INLA and SPDE (Stochastic Partial Differential Equations) allows to analyze point level data.

## Latent Gaussian Models LGM 

Following the notation imposed in [@Blangiardo-Cameletti] and in [@Moraga2019] a reversed approach might better offer the intuition. In order to define a Latent Gaussain Model Within the bayesian framework it is convenient to specify at first, given some observations  $y_{i \ldots n}$, an  _exponential family_ (Gaussian Poisson Exponential) distribution function characterized by some parameters $\phi_{i}$ (usually expressed by the mean $\left.E\left(y_{i}\right)\right$) and some other hyper-parameters  $\psi_{k}$. The parameter  $\phi_{i}$ can be defined as an additive latent linear predictor $\eta_{i}$ [@Krainski-Rubio] by a link function $g(\cdot)$, i.e. $g\left(\phi_{i}\right)=\eta_{i}$. A comprehensive expression of the linear predictor take into account all the possible effects: 

$$
\eta_{i}=\beta_{0}+\sum_{m=1}^{M} \beta_{m} x_{m i}+\sum_{l=1}^{L} f_{l}\left(z_{l i}\right)
$$

where $\beta_{0}$ is the intercept, $\boldsymbol{\beta}=\left\{\beta_{1}, \ldots, \beta_{M}\right\}$ are the coefficient that quantifies the linear effects on covariates $\boldsymbol{x}=\left({x}_{1}, \ldots, {x}_{M}\right)$  and $f$ are a set of random effects defined in terms of a set of covariates $\boldsymbol{z}=\left(z_{1}, \ldots, z_{L}\right)$ (e.g. rw, ar1). [estendibile a tanti modelli] . All the latent components can be conveniently grouped into a varibale denoted with $\boldsymbol{\theta}$ such that. $\boldsymbol{\theta}=\left\{\beta_{0}, \beta, f\right\}$ and the same can be done for hyper parameters: . Then the distribution probability conditioned to parameters and hyper parameters $\boldsymbol{\psi}=\left\{\psi_{1}, \ldots, \psi_{K}\right\}$:

$$y_{i} \mid \boldsymbol{\theta}, \boldsymbol{\psi} \sim \pi\left(y_{i} \mid \boldsymbol{\theta},\boldsymbol{\psi}\right)$$ 
Since they are conditionally independent the joint distribution is given by the likelihood: 
$$\pi(\boldsymbol{y} \mid \boldsymbol{\theta}, \boldsymbol{\psi})=\prod_{i=1}^{n} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)$$
Each data point is connected to a linear combination of each element in $\boldsymbol{\theta}$ _latent field_ . Hyper parameters are going to be ex-ante independent, therefore $\boldsymbol{\theta}$ will be the product of many univariate priors [@Bayesian_INLA_Rubio]. A multivariate Normal distribution on $\boldsymbol{\theta}$ is imposed centered in 0 with a precision matrix $Q(\psi),$ i.e., $\theta \sim \operatorname{Normal}\left(\mathbf{0}, Q^{-1}(\psi)\right)$ depending on the hyper parameter vector $\boldsymbol{\psi}$. As side note some authors choose to approach the precision matrix as a covariance function in the setting seen before. This is strongly not encouraged since it compicates notation. However This has to be forcly done in next chpater since a special covariance function is used. The density function is expressed through: 

$$
\pi(\theta \mid \psi)=(2 \pi)^{-n / 2}|Q(\psi)|^{1 / 2} \exp \left(-\frac{1}{2} \theta^{\prime} Q(\psi) \theta\right)
$$
Each component of the latent files is supposed to be conditionally independent, this leads to $\boldsymbol{Q(\psi)}$ being a sparse precision matrix, that is called _Gaussian Markov random field_ (**GMRF**). From here comes the computational power inherited usgn latent models, matrices are sparse so numerical methods can be exploited [@Blangiardo-Cameletti].
Once priors are specified for $\boldsymbol{\psi}$ then the following holds:

$$
\underbrace{\pi(\boldsymbol{\psi})}_{\text {prior }} \times \underbrace{\pi(\theta \mid \psi)}_{\text {GMRF }} \times \underbrace{\prod_{i=1}^{n} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)}_{\text {likelihood }}
$$
Then the joint posterior distribution plugging in the likelihood and GMRF:

$$
\begin{aligned}
\pi(\theta, \psi \mid y) & \propto \pi(\psi) \times \pi(\theta \mid \psi) \times \pi(y \mid \theta, \psi) \\
& \propto     \pi(\psi) \times \pi(\theta \mid \psi) \times \prod_{i=1}^{n} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right) \\
& \propto \pi(\psi) \times|Q(\psi)|^{1 / 2} \exp \left(-\frac{1}{2} \theta^{\prime} Q(\psi) \theta\right) \times \prod_{i=1}^{n} \exp \left(\log \left(\pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)\right)\right) \\
& \propto \pi(\psi) \times|Q(\psi)|^{1 / 2} \exp \left(-\frac{1}{2} \theta^{\prime} Q(\psi) \theta+\sum_{i=1}^{n} \log \left(\pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi}\right)\right)\right)
\end{aligned}
$$

## Approximation in INLA setting

INLA is not going to try to estimate posterior distribution solving the integral, instead marginals effects and hyper parameters. For latent parameter $\boldsymbol{\theta}$ :

$$
\pi\left( \boldsymbol{\theta}\mid y \right)=\int \pi\left(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \mathbf{y}\right) \pi(\boldsymbol{\psi} \mid \mathbf{y}) d \boldsymbol{\psi}
$$

The posterior marginal for the hyoerparameter is $\boldsymbol{\psi}$ since  $\boldsymbol{\psi}=\left\{\psi_{1}, \ldots, \psi_{K}\right\}$ :


$$
\pi\left(\psi_{k} \mid y\right)=\int \pi(\boldsymbol{\psi} \mid y) d \psi_{-k}
$$
where $\psi_{-k}$ is a vector of hyper parameters $\psi$ without the element $\psi_{k}$.



[[[[[[[[[[[[[[[[[[[[[[ DA RIMETTERE DA QUI ]]]]]]]]]]]]]]]]]]]]]]


## Laplace Approximation

An alternative approach to the simulation- based MC integration is analytic approximation with the Laplace method. Suppose we are interested in computing the
following integral:

$$\int f(x) \mathrm{d} x=\int \exp (\log f(x)) \mathrm{d} x$$

where $f(x)$ is the density function of a random variable X. We represent $log f(x)$ by
means of a Taylor series expansion evaluated in x = x0:

$$\log f(x) \approx \log f\left(x_{0}\right)+\left.\left(x-x_{0}\right) \frac{\partial \log f(x)}{\partial x}\right|_{x=x_{0}}+\left.\frac{\left(x-x_{0}\right)^{2}}{2} \frac{\partial^{2} \log f(x)}{\partial x^{2}}\right|_{x=x_{0}}$$


If x0 is set equal to the mode $x∗ = argmax$, log f(x) then  log f(x)$\left.\frac{\partial \log f(x)}{\partial x}\right|_{x=x^{*}}=0$  and the approximation becomes


$$\log f(x) \approx \log f\left(x^{*}\right)+\left.\frac{\left(x-x^{*}\right)^{2}}{2} \frac{\partial^{2} \log f(x)}{\partial x^{2}}\right|_{x=x^{*}}$$


The integral of interest is then approximated as follows:

$$\int f(x) \mathrm{d} x \approx \int \exp \left(\log f\left(x^{*}\right)+\left.\frac{\left(x-x^{*}\right)^{2}}{2} \frac{\partial^{2} \log f(x)}{\partial x^{2}}\right|_{x=x^{*}}\right) \mathrm{d} x$$

$$=\exp \left(\log f\left(x^{*}\right)\right) \int \exp \left(\left.\frac{\left(x-x^{*}\right)^{2}}{2} \frac{\partial^{2} \log f(x)}{\partial x^{2}}\right|_{x=x^{*}}\right) \mathrm{d} x$$


where the integrand can be associated with the density of a Normal distribution. In
fact, by setting $$\sigma^{2 *}=-1 /\left.\frac{\partial^{2} \log f(x)}{\partial x^{2}}\right|_{x=x^{*}}$$  we obtain: 

$$\int f(x) \mathrm{d} x \approx \exp \left(\log f\left(x^{*}\right)\right) \int \exp \left(-\frac{\left(x-x^{*}\right)^{2}}{2 \sigma^{2 *}}\right) \mathrm{d} x$$

where the integrand is the kernel of a Normal distribution with mean equal to x∗
and variance $\sigma^{2*}$. More precisely, the integral evaluated in the interval $(\alpha, \beta)$ is
approximated by:

$$\int_{\alpha}^{\beta} f(x) \mathrm{d} x \approx f\left(x^{*}\right) \sqrt{2 \pi \sigma^{2 *}}(\Phi(\beta)-\Phi(\alpha))$$

where $\Phi(⋅)$ denotes the cumulative density function of th $Normal(x_i, \sigma^{2*})$ distribution.

as an example this a logistic regression xample bivariate noramle we have wo obsservation we just wna ot compute the marginal essentially whe ahv to approxiamte this integral, so what the cpmputaion twe need to do we chose a value for x 1 sand the we approxaimte thsi inegral this is how w e itntegratem to do we have to comoute the mode ant the curvature and then use laplace spproximation

[couple figures]


INLA compute the posterior marignals for the LGM:

$$
\pi\left(x_{i} \mid \boldsymbol{y}\right)=\int \pi\left(x_{i} \mid \boldsymbol{\theta}, \boldsymbol{y}\right) \pi(\boldsymbol{\theta} \mid \boldsymbol{y}) d \boldsymbol{\theta}, \pi\left(\theta_{j} \mid \boldsymbol{y}\right)=\int \pi(\boldsymbol{\theta} \mid \boldsymbol{y}) d \boldsymbol{\theta}_{-j}
$$


## Approximate Bayesian inference with INLA

The objectives of Bayesian inference are the marginal posterior distributions for
each element of the parameter vector

$$p\left(\theta_{i} \mid \boldsymbol{y}\right)=\int p\left(\theta_{i}, \boldsymbol{\psi} \mid \boldsymbol{y}\right) \mathrm{d} \boldsymbol{\psi}=\int p\left(\theta_{i} \mid \boldsymbol{\psi}, \boldsymbol{y}\right) p(\boldsymbol{\psi} \mid \boldsymbol{y}) \mathrm{d} \boldsymbol{\psi}$$

and for each element of the hyperparameter vector

$$p\left(\psi_{k} \mid \boldsymbol{y}\right)=\int p(\boldsymbol{\psi} \mid \boldsymbol{y}) \mathrm{d} \boldsymbol{\psi}_{-k}$$

Thus, we need to perform the following tasks:
(i) compute $p(\boldsymbol{\psi} \mid \boldsymbol{y})$, from which also all the relevant marginals p(𝜓k|y) can be
obtained;
(ii) compute $p\left(\theta_{i} \mid \boldsymbol{\psi}, \boldsymbol{y}\right)$ which is needed to compute the parameter marginal posteriors $p\left(\theta_{i} \mid \boldsymbol{y}\right)$

The INLA approach exploits the assumptions of the model to produce a numerical
approximation to the posteriors of interest based on the Laplace approximation
method introduced in Section 4.7 (Tierney and Kadane, 1986).
The first task (i) consists of the computation of an approximation to the joint
posterior of the hyperparameters as:


$$\begin{aligned} p(\boldsymbol{\psi} \mid \boldsymbol{y}) &=\frac{p(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \boldsymbol{y})}{p(\boldsymbol{\theta} \mid \boldsymbol{\psi}, \boldsymbol{y})} \\ &=\frac{p(\boldsymbol{y} \mid \boldsymbol{\theta}, \boldsymbol{\psi}) p(\boldsymbol{\theta}, \boldsymbol{\psi})}{p(\boldsymbol{y})} \frac{1}{p(\boldsymbol{\theta} \mid \boldsymbol{\psi}, \boldsymbol{y})} \\ &=\frac{p(\boldsymbol{y} \mid \boldsymbol{\theta}, \boldsymbol{\psi}) p(\boldsymbol{\theta} \mid \boldsymbol{\psi}) p(\boldsymbol{\psi})}{p(\boldsymbol{y})} \frac{1}{p(\boldsymbol{\theta} \mid \boldsymbol{\psi}, \boldsymbol{y})} \\ & \propto \frac{p(\boldsymbol{y} \mid \boldsymbol{\theta}, \boldsymbol{\psi}) p(\boldsymbol{\theta} \mid \boldsymbol{\psi}) p(\boldsymbol{\psi})}{p(\boldsymbol{\theta} \mid \boldsymbol{\psi}, \boldsymbol{y})} \\ &\left.\approx \frac{p(\boldsymbol{y} \mid \boldsymbol{\theta}, \boldsymbol{\psi}) p(\boldsymbol{\theta} \mid \boldsymbol{\psi}) p(\boldsymbol{\psi})}{\tilde{p}(\boldsymbol{\theta} \mid \boldsymbol{\psi}, \boldsymbol{y})}\right|_{\boldsymbol{\theta}=\boldsymbol{\theta}^{*} \boldsymbol{\psi}}=: \tilde{p}(\boldsymbol{\psi} \mid \boldsymbol{y}) \end{aligned}$$

where $\tilde{p}(\theta \mid \psi, y)$ is the Gaussian approximation – given by the Laplace method – of $p(\theta \mid \psi, y)$ and $\theta^{*}(\psi)$  is the mode for a given $\psi$ the Gaussian approximation turns out to be accurate since $p(\theta \mid \psi, y)$appears to be almost Gaussian as it is a priori dis-
tributed like a GMRF, y is generally not informative and the observation distribution
is usually well-behaved.
The second task (ii) is slightly more complex, because in general there will
be more elements in 𝜽 than in 𝝍, and thus this computation is more expensive.
A first easy possibility is to approximate the posterior conditional distributions
$p(\theta \mid \psi, y)$ directly as the marginals from $\tilde{p}(\theta \mid \psi, y)$  i.e. using a Normal distribution, where the Cholesky decomposition is used for the precision matrix (Rue
and Martino, 2007). While this is very fast, the approximation is generally
not very good. The second possibility is to rewrite the vector of parameters as
$\theta=\left(\theta_{i}, \theta_{-i}\right)$ and use again Laplace approximation to obtain


$$\begin{aligned} p\left(\theta_{i} \mid \boldsymbol{\psi}, \boldsymbol{y}\right) &=\frac{p\left(\left(\theta_{i}, \boldsymbol{\theta}_{-i}\right) \mid \boldsymbol{\psi}, \boldsymbol{y}\right)}{p\left(\boldsymbol{\theta}_{-i} \mid \theta_{i}, \boldsymbol{\psi}, \boldsymbol{y}\right)} \\ &=\frac{p(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \boldsymbol{y})}{p(\boldsymbol{\psi} \mid \boldsymbol{y})} \frac{1}{p\left(\boldsymbol{\theta}_{-i} \mid \theta_{i}, \boldsymbol{\psi}, \boldsymbol{y}\right)} \\ & \propto \frac{p(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \boldsymbol{y})}{p\left(\boldsymbol{\theta}_{-i} \mid \theta_{i}, \boldsymbol{\psi}, \boldsymbol{y}\right)} \\ &\left.\approx \frac{p(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \boldsymbol{y})}{\tilde{p}\left(\boldsymbol{\theta}_{-i} \mid \theta_{i}, \boldsymbol{\psi}, \boldsymbol{y}\right)}\right|_{\boldsymbol{\theta}_{-i}=\boldsymbol{\theta}_{-i}^{*}\left(\theta_{i}, \boldsymbol{\psi}\right)}=: \tilde{p}\left(\theta_{i} \mid \boldsymbol{\psi}, \boldsymbol{y}\right) \end{aligned}$$

where $\tilde{p}\left(\boldsymbol{\theta}_{-i} \mid \theta_{i}, \boldsymbol{\psi}, \boldsymbol{y}\right)$  is the Laplace Gaussian approximation to $p\left(\boldsymbol{\theta}_{-i} \mid \theta_{i}, \boldsymbol{\psi}, \boldsymbol{y}\right)$ and $\boldsymbol{\theta}_{-i}^{*}\left(\theta_{i}, \boldsymbol{\psi}\right)$ is its mode.  Because the random variables $\theta_{-i} \mid \theta_{i}, \psi, y$ re in general
reasonably Normal, the approximation provided by (4.20) typically works very
well. This strategy, however, can be very expensive in computational terms as $\tilde{p}\left(\theta_{-i} \mid \theta_{i}, \psi, y\right)$ must be recomputed for each value of 𝜽 and 𝝍 (some modifications
to the Laplace approximation in order to reduce the computational costs are
described in Rue et al., 2009).


 Operationally, INLA proceeds as follows:
(i) first it explores the hyperparameter joint posterior distribution $\tilde{p}(\psi \mid \boldsymbol{y})$ of Eq. (4.18) in a nonparametric way, in order to detect good points $\left\{\psi^{(j)}\right\}$ for
the numerical integration required in Eq. (4.22). Rue et al. (2009) propose
two different exploration schemes, both requiring a reparameterization of
the $\psi$-space – in order to deal with more regular densities – through the
following steps:

a) Locate the mode $\psi^{*}$ of $\tilde{p}(\boldsymbol{\psi} \mid \boldsymbol{y})$ by optimizing log $\tilde{p}(\boldsymbol{\psi} \mid \boldsymbol{y})$ with respect to
𝝍 (e.g., through the Newton–Raphson method).
b) Compute the negative Hessian $H$ at the modal configuration.
c) Compute the eigen-decomposition $\mathbf{\Sigma}=\boldsymbol{V} \Lambda^{1 / 2} \boldsymbol{V}^{\prime}$, with $\Sigma=H^{-1}$.
d) Define the new variable z, with standardized and mutually orthogonal
components, such that:

$$\boldsymbol{\psi}(z)=\boldsymbol{\psi}^{*}+\boldsymbol{V} \Lambda^{1 / 2} z$$

The first exploration scheme (named grid strategy) builds, using the
z-parameterization, a grid of points associated with the bulk of the mass of $\tilde{p}(\boldsymbol{\psi} \mid \boldsymbol{y})$ . This approach has a computational cost which grows exponentially
with the number of hyperparameters; therefore the advice is to adopt it
when K, the dimension of $\psi$, is lower than 4. Otherwise, the second explo-
ration scheme, named central composite design (CCD) strategy, should be
used as it reduces the computational costs. With the CCD approach, the
integration problem is seen as a design problem; using the mode $\psi^{*}$ and the
Hessian H, some relevant points in the 𝝍-space are selected for performing
a second-order approximation to a response variable (see Section 6.5 of
Rue et al., 2009 for details). In general, the CCD strategy uses much less
points, but still is able to capture the variability of the hyperparameter
distribution. For this reason it is the default option in R-INLA.


## The Projector Matrix

We need to construct a projection matrix **A** to project the GRF from the observations to thetriangulation vertices.  The matrix **A** as the number of rows equal to the number of observations, and the number of columns equal to the number of vertices of the triangulation. Row $i$ of **A** corresponding to an observation at location $s_{i}$ ossibly has three non-zero values at the columns that correspond to the vertices of the triangle that contains the location. If  $s_{i}$ within the triangle, these values are equal to the barycentric coordinates. That is, they are proportional to the areas of each of the three subtriangles defined by the location $s_{i}$ 
and the triangle’s vertices, and sum to 1. If $s_{i}$ s equal to a vertex of the triangle, row  
$i$ has just one non-zero value equal to 1 at the column that corresponds to the vertex. Intuitively, the value $Z(\boldsymbol{s})$ at a location that lies within one triangle is the projection of the plane formed by the triangle vertices weights at location $s$ .

An example of a projection matrix is given below. This projection matrix projects  $n$ observations to  $G$  triangulation vertices. The first row of the matrix corresponds to an observation with location that coincides with vertex number 3. The second and last rows correspond to observations with locations lying within triangles.


$4=\left[\begin{array}{ccccc}A_{11} & A_{12} & A_{13} & \ldots & A_{1 G} \\ A_{21} & A_{22} & A_{23} & \ldots & A_{2 G} \\ \vdots & \vdots & \vdots & \ddots & \vdots \\ A_{n 1} & A_{n 2} & A_{n 3} & \ldots & A_{n G}\end{array}\right]=\left[\begin{array}{ccccc}0 & 0 & 1 & \ldots & 0 \\ A_{21} & A_{22} & 0 & \ldots & A_{2 G} \\ \vdots & \vdots & \vdots & \ddots & \vdots \\ A_{n 1} & A_{n 2} & A_{n 3} & \ldots & 0\end{array}\right]$


igure 8.6 shows a location  $s$  that lies within one of the triangles of a triangulated mesh. The value of the process  $Z(\cdot)$  at  $s$  is expressed as a weighted average of the values of the process at the vertices of the triangle ($Z_{1}$, $Z_{2}$ and $Z_{3}$)and with weights equal to 
$T_{1} / T$, $T_{2} / T$ and  $T_{3} / T$ where $T$denotes the area of the big triangle that contains $s$ and $T_{1}$, $T_{2}$ and $T_{3}$ are the areas of the subtriangles

$Z(\boldsymbol{s}) \approx \frac{T_{1}}{T} Z_{1}+\frac{T_{2}}{T} Z_{2}+\frac{T_{3}}{T} Z_{3}$

![triangle-mesh-1](images/triangle-mesh-1.png)
`R-INLA` provides the `inla.spde.make.A()` function to easily construct a projection matrix **A**
We create the projection matrix of our example by using `inla.spde.make.A()`  passing the triangulated mesh `mesh` and the coordinates `coo`.

```
A <- inla.spde.make.A(mesh = mesh, loc = coo)
```










































<!--chapter:end:05-inla_spde.Rmd-->
