# SPDE approach{#spde}

<!--  You can label chapter and section titles using `{#label}` after them, e.g., we can reference Chapter \@ref(intro). If you do not manually label them, there will be automatic labels anyway, e.g., Chapter \@ref(methods).-->

Observations in the spatial problem setting are considered as realizations of a stationary, isotropic unobserved GP $w(s)$ that we aim to estimate (\@ref(GP)). Before approaching the problem with SPDE, GPs were treated as multivariate Gaussian densities and Cholesky factorizations were applied on the covariance matrices and then fitted with likelihood. Matrices in this settings were very dense and they were scaling with the order of $O\left(n^{3}\right)$, leading to obvious big-n problem. 
The breakthrough, came with @Lindgren2011 that proves that a stationary, isotropic GP with Matérn covariance can be represented as a GMRF using SPDE solutions by finite element method [@Krainski-Rubio]. In other words given a GP whose covariance matrix is $\boldsymbol{Q}$, SPDE can provide a method to approximate $\boldsymbol{Q}$ without computational constraints. As a matter of fact SPDE are equations whose solutions are GPs with a chosen covariance function focused on satisfying the relationship SPDE specifies.
Benefits are many but the most important is that the representation of the GP through a GMRF provides a sparse representation of the spatial effect through a sparse precision matrix $\boldsymbol{Q}^-1$ . Sparse matrices enable convenient inner computation properties of GMRF that can be exploited with INLA. Bayesian inference on GMRF can take advantage of lower computational cost because of these properties stated before leading to a more feasible big-O $O\left(n^{3 / 2}\right)$. The following chapter will provide a intuition on SPDE oriented to practitioners. The chapeter once again will follow the track of Krainski & Rubio -@Krainski-Rubio and Blangiardo and Cameletti -@Blangiardo-Cameletti works, together with the street-opener paper from @Miller2019 as compendium. SPDE might be complex for those who are not used to applied mathematics and physics making it difficult not only to grab the concept, but also to find its applications. One more obstacle regards SPDE software implementation, since without deep technical expertise it might be difficult to customize code with the aim to extend the methodology to different models. For a gentle introduction on what a SPDE is from a mathemathical perspective a valuable reference is @Miller2019 in secction 2.1, then also its application to Matérn in 2.3.


##  Set SPDE Problem

Given the statistical model already encountered in chapter \@ref(univariateregr):

$$
y\left(\mathbf{s}_{i}\right)=\mathbf{x}\left(\mathbf{s}_{i}\right)^{\prime} \beta_{j}+w(\mathbf{s})+\varepsilon\left(\mathbf{s}_{i}\right)
$$

where $\eta(\mathbf{s}_{i}) = g (\mathbf{x}\left(\mathbf{s}_{i}\right)^{\prime}\beta_{j})$ is the linear predictor, whose link function $g( \cdot )$ is identity (can be also extended to GLM), where $w(\mathbf{s})$ is a Gaussian Process with mean structure 0 and $C(\cdot)$ covariance structure ( where $\boldsymbol{Q}$ is the covariance matrix and $Q^{-1}$ precision matrix). Then $w(s) \sim MV\mathcal{N}(0, \boldsymbol{Q}_{i,j}^{-1})$ and where $\varepsilon(\mathbf{s}_{i})$ is white noise error such that $\varepsilon(\mathbf{s}_{i}) \sim \mathcal{N}\left(0, \tau^{2}\right)$.
Comprehending $w$ in the model brings two major issues, specify a covariance function for observations as well as how to fit the model. Among all the possible reachable solutions including the SPDE, the common goal is to define covariance function between locations by approximating the precision matrix $\boldsymbol{Q}^{-1}$, since they are an effective tool to represent covariance function as in section \@ref(LGM).
For those reasons SPDE approach implies finding an SPDE whose solution have the precision matrix, that is desired for $w$. @Lindgren2011 proves that an approximate solution to SPDE equations is to represent $w$ as a sum of basis function multiplied by coefficients -@Miller2019. Moreover the basis function coefficients are in reality a GMRF (for which fast method comptations already exists). 

## SPDE within R-INLA 

First point addresses the assumption that a GP with Matérn covariance function and $\nu >0$ is a solution to *SPDE* equations. 
Second point addressed the issues of solving SPDE when grids are irregular, as opposite with the one seen in first point (regular grid for irregular distribution. In here comes FEM used in mathematics and engineering application with the purpose to solve differential equations. Notation is kept coherent with the one for the previous chapter.

## First Point Krainsky Rubio TOO TECHNICAL 

A regular 2D grid lattice is considered with infinite number of location points as vertices.


![lattice 2D regular grid](images/lattice.png)


