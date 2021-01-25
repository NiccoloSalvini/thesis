# Model Selection & Fitting{#modelspec}

In this chapter is applied all the theory seen so far through the R-INLA package. The hierarchical Latent Gaussian model to-be-fitted sets against the response price (inevitably normalized) with the other predictors scraped (standardized and scaled the numerical ones). As a result on top of the hierarchy i.e. the higher level the model places the likelihood of data for which a Normal distribution is specified. At the medium level the GMRF containing the latent components and distributed as a Multivariate Normal (centered in zero and with "markov" precision matrix). In the end penalized complexity priors are specified as prior distributions. The SPDE approach trinagularize the spatial domain and makes possible to pass from a discrete surface to a continuous representation of the own process. This requires a series of steps ranging from mesh building, passing the mesh inside the Matérn obtaining the spde object and then reprojecting through the stack function. In the end the model is fitted integrating the spatial random field and posterior distributions for parameters and hyper parameters are evaluated.







<!-- # ```{r covariasel, eval=F} -->
<!-- # resp = "price" -->
<!-- # covar = final_data %>%  names() -->
<!-- # # Specify the formula -->
<!-- # formula_lin <- as.formula(paste0(resp, " ~ ", # Response first -->
<!-- #                           paste(covar, collapse = " + ") # Collapse the vector of covariates -->
<!-- # )) -->
<!-- #  -->
<!-- # IM0.1  <- inla(formula_lin,  -->
<!-- #                family = "nbinomial", # Specify the family. Can be a wide range (see r-inla.org). -->
<!-- #                data = TestHosts) # Specify the data -->
<!-- #  -->
<!-- # # Then with an ID random effect #### -->
<!-- #  -->
<!-- # f0.2 <- as.formula(paste0(resp, " ~ ",  -->
<!-- #                           paste(covar, collapse = " + "),  -->
<!-- #                           " +  f(ID, model = 'iid')")) # This is how you include  a typical random effect. -->
<!-- #  -->
<!-- # IM0.2  <- inla(f0.2,  -->
<!-- #                family = "nbinomial", -->
<!-- #                data = TestHosts)  -->
<!-- #  -->
<!-- # summary(IM0.1) -->
<!-- # summary(IM0.2) -->
<!-- #  -->
<!-- # ``` -->   


<!--                                                  [var selection](https://ourcodingclub.github.io/tutorials/inla/) -->



## Model Specification & Mesh Assessement {#modelspecandmesh}

In order to make the distribution of the response i.e. price (per month in €) approximately Normal it is applied a $log_{10}$ transformation (further transformation would have better Normalized data i.e. Box-Cox [@boxcox] and Yeo-Johnson [@yeojohnson] however they over complicate interpretability). Moreover all of the numerical covariate i.e. condominium, and sqmeeter, (respectively the condominium price and the house width) are standardized and scale for modeling purposes. No assessement neither validation set are retained since it is going to be fitted a LOOCV (refer to \@ref(criticism)) throughout the `inla()` function call. The Locations are represented in map plot \@ref(fig:ggmap) within the borders of the Municipality of Milan. At first the borders shapefile is imported from [GeoPortale Milano](https://geoportale.comune.milano.it/sit/open-data/). The corresponding CRS is in UTM (i.e. Eastings and Northings) which differs from the spatial covariates extracted (lat and long). Therefore the spatial entity needs to be moved from UTM to latlong reprojected to a new CRS. In the end the latitude and the longitude points are overlayed to the borders as in figure \@ref(fig:ggmap).

![(\#fig:ggmap)Milan Real Estate data within the Municpality borders, 4 points of interest, author's source](07-model_fitting_files/figure-latex/ggmap-1.pdf) 


The hierarchical model defined for Milan Real Estate Rental data, for which it is assumed Normality is (notation is left with the pedix reference for the corresponding observation index):

$$
{y}_{i} \sim \operatorname{Normal}\left(\eta_{i}, \sigma_{e}^{2}\right)
$$
And the linear predictor i.e. mean since the $\mathrm{g}\left(\mu_{i}\right)$ is identity, is:

$$
\eta_{i}=b_{0}+x_{i} \boldsymbol\beta+\xi_{i} 
$$
where, following the expression \@ref(eq:linearpredictor), $\xi_i$ is the spatial random effect for the function $f_1()$, for the set of coviarates $\boldsymbol{z}=\left(x_{1} = lat,\, x_{2} = long\right)$. $\xi_{i}$ is also the GMRF seen in chapter \@ref(gmrf) which is distributed as a multivariate Normal and whose covariance function is Matérn (fig. \@ref(fig:matern)) i.e. $\xi_{i} \sim N\left(\mathbf{0}, \mathbf{Q}_{\mathscr{C}}^{-1}\right)$. The precision matrix  $\mathbf{Q}_{\mathscr{C}}^{-1}$ (see left panel in figure \@ref(fig:precisionmat)) is the one that requires to be treated with SPDE and its dimensions are $n \times n$, in this case when NA are omitted is $192 \times 192$.
$\boldsymbol\beta$ are the model scraped covariates coefficients, which include condom, totlocali, altro, bagno, cucina, heating ... and the rest.

Moreover the latent field which is _a priori_ independent with respect to the observations $\boldsymbol{\mathbf{y}}$ is $\boldsymbol{\theta}=\{\boldsymbol{\xi}, \boldsymbol{\beta}\}$. In addition to this it must be added the white noise measurement error precision for the spatial effect, which is commonly assumed in Geostatistics to coincide with the nugget effect $\tau^2$ [@Cressie_2015], refer to \@ref(GP) for nugget definition:
In the end the LGM model can be reformatted as follows (with usual notation):

$$
\boldsymbol{\mathbf{y}}=\boldsymbol{z} \boldsymbol{\beta}+\boldsymbol{\xi}+\boldsymbol{\varepsilon}, \quad \boldsymbol{\varepsilon} \sim N\left(\mathbf{0},  \sigma^2_{\varepsilon} I_{d}\right)
$$

<!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction -->

The first step needed to fit the model through SPDE approach is to triangulate the domain space as intuited in \@ref(spdeapproach). The function `inla.mesh.2d` together with the `inla.nonconvex.hull` are able to define a good triangulation since no original boundaries are provided. Two meshes are produced, whose figures are in \@ref(fig:meshes). Triangles appears to be equilateral and smooth, which suggest decent triangulation result _miss lit_. Critical parameters for meshes are `max.edge=c(0.025, 0.048)` and  `max.edge=c(0.017, 0.019)` which also regulates the refinement. Further trials have show that below the lower bound of max.edge value of $0.017$ the current machine computing power does not output the mesh, therefore the maximum number of vertices obtainable coincides with the triangulation built in $\text{mesh}_2$, right panel in fig\@ref(fig:meshes). . 

![(\#fig:meshes)Left: mesh traingulation for 156 vertices, Right: mesh traingulation for 324 vertices](07-model_fitting_files/figure-latex/meshes-1.pdf) 

At this point with the aim to apply INLA and to specify the SPDE object are needed to be assigned both priors and hyper priors. The latent field $\boldsymbol\theta$ requires to have Gaussian vagues ones with fixed precision. The priors $\boldsymbol\psi_1$ for the higher level eq. \@ref(eq:higher) are $\boldsymbol\psi_1 = \left(\sigma_{\mathscr{C}}^{2}, \kappa\right)$ i.e. hyper parameter for the GMRF latent field precision and Matérn are chosen to be PC priors \@ref(priorsspec) [... qualcosa di più su pc prior choice ...]. At the medium level it is needed a further hyper prior $\boldsymbol\psi_2 = (\sigma_{\varepsilon}^{2})$ which accounts for the variance of the $\boldsymbol{y}$ data. 


<!-- $$ -->
<!-- \begin{tabular}[t]{lcc} -->
<!-- Treatment A&Treatment A\\ --> 
<!-- \hline -->
<!-- \text{for precision of Surface} \sigma_{e}^{2}  & (1, 0.5)\\ -->
<!-- \text{Mean of spatial} range \kappa&--(20, 0.8)\\ -->
<!-- \text{for precision spatial effect} \sigma_{\mathscr{C}}^{2}& (0.4, 0.2)\\ -->
<!-- \hline -->
<!-- \end{tabular} -->
<!-- $$ -->

Thus following the equation in \@ref(eq:formallgm) then it is obtained: 

$$
\pi(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \mathbf{y})\propto  \underbrace{\pi(\boldsymbol{\psi})}_{\text {priors}} \times \underbrace{\pi(\boldsymbol\theta \mid \boldsymbol\psi)}_{\text {GMRF}} \times \underbrace{\prod_{i=1}^{\mathbf{I}} \pi\left(\mathbf{y} \mid \boldsymbol\theta, \boldsymbol{\psi}\right)}_{\text {likelihood }}
$$

## Building the SPDE object{#spdemodeol}

The SPDE model object is built with the function `inla.spde2.pcmatern()` which needs as arguments the mesh triangulation and the PC priors \@ref(priorsspec), satisfying the following probability statements: `prior.range = c(r, alpha_r)` for  $\operatorname{Prob}(\rho<r)<\alpha_{r}$ where $\rho$ is the spatial range of the random field. And `prior.sigma = c(s, alpha_s)` for $\operatorname{Prob}(\sigma>s)<\alpha_{s}$ where $\sigma$ is the marginal standard deviation of the field [... trova le relazione con variogram (ci metto dentro l'empirical range e una standard deviation abbastanza grande)...] \@ref(spatassess).
As model complexity increases, for instance, a lot of random effects are found in the linear predictor and chances are that SPDE object may get into trouble. As a result the `inla.stack` function recreates the linear predictor as a combination of the elements of the old linear predictor and a the matrix of observations. Further mathematical details about the stack are in @Blangiardo-Cameletti, but are beyond the scope of the analysis. 





## Parameter estimation and Results{#fit}

In the end the model is fitted whose final formula is $\log_{10}(price) \sim Intercept + totlocali + \dots + f(coordinate, model = spde1)$. The most part of the covariates are omitted for brevity reasons. It is only considered the spatial effect for the `f()` in which needs to reside also both the coordinates and the spde object.




<!-- PROVARE A FAR FUNZIONARE INLABRU -->




With regard to model criticsm, the model evaluation is focused on DIC and CPO, which are directly obtained from the output of the R-INLA object.


inference on posterior results, credibility levels 

posterior results table...



## Spatial Prediction on grid

A gridded object is required in order to project spatial prediction on the domain space. Usually these operations are very computationally expensive since grid objects size can easily reach $10^4$ to $10^6$ dimension points. Since in this case the linear predictor marginal distributions are not the focus then a more feasible solution consists in projecting the latent field estimated at the triangulation vertices onto the grid location [-@Blangiardo-Cameletti]. At first a proper projection matrix is created without specifying the locations. 





