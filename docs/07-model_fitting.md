# Model Selection & Fitting{#modelspec}

In this chapter it is applied all the theory seen so far through the lenses of R-INLA package on the scraped data. The hierarchical Latent Gaussian model to-be-fitted sets against the response price with the other predictors scraped. As a consequence on top of the hierarchy i.e. the higher level the model places the likelihood of data for which a Normal distribution is specified. At the medium level the GMRF containing the latent components and distributed as a Multivariate Normal (centered in zero and with "markov" properties encoded in the precision matrix). In the end priors are specified both for measurement error precision and for the latent field (penalized in complexity) i.e. the variance of the spatial process and the Matérn hyper parameters. The SPDE approach trinagularize the spatial domain and makes possible to pass from a discrete surface to a continuous representation of the own process. This requires a series of steps ranging from mesh building, passing the mesh inside the Matérn obtaining the spde object and then reprojecting through the stack function. In the end the model is fitted integrating the spatial random field. Posterior distributions for parameters and hyper parameters are then evaluated and summarized.







In order to make the distribution of the response i.e. price (per month in €) approximately Normal it is applied a $log_{10}$ transformation (further transformation would have better Normalized data i.e. Box-Cox [@boxcox] and Yeo-Johnson [@yeojohnson] however they over complicate interpretability). Moreover all of the numerical covariatesd i.e. condominium, and sqmeter, have already been prepared in \@ref(prep) and are further standardized and scaled. No assessment neither validation set are retained since it is going to be fitted a LOOCV (refer to \@ref(criticism)) within the `inla()` function call. The Locations are represented in map plot \@ref(fig:ggmap) within the borders of the Municipality of Milan. At first the borders shapefile is imported from [GeoPortale Milano](https://geoportale.comune.milano.it/sit/open-data/). The corresponding CRS is in UTM (i.e. Eastings and Northings) which differs from the spatial covariates extracted (lat and long). Therefore the spatial entity needs to be rescaled and reprojected to a new CRS. In the end the latitude and the longitude points are overlayed to the borders as in figure \@ref(fig:ggmap).



<div class="figure">
<img src="07-model_fitting_files/figure-html/ggmap-1.png" alt="Milan Real Estate data within the Municpality borders, 4 points of interest" width="672" />
<p class="caption">(\#fig:ggmap)Milan Real Estate data within the Municpality borders, 4 points of interest</p>
</div>
## Model Specification & Mesh Assessement {#modelspecandmesh}

WIth the aim to fit inla then a hierarchical LGM need to be imposed. Its definition starts from fitting an exponential family distribution on Milan Real Estate Rental data $\mathbf{y}$ i.e. normal distribution:

$$
\mathbf{y}\sim \operatorname{Normal}\left(\boldsymbol\mu, \sigma_{e}^{2}\right)
$$

Then the linear predictor i.e. the mean, since the function $\mathrm{g}\left(\boldsymbol\mu\right)$ is identity, is:

$$
\boldsymbol\eta=b_{0}+\boldsymbol x \boldsymbol\beta+\boldsymbol\xi 
$$
where, following the notation in expression \@ref(eq:linearpredictor), $\boldsymbol\xi$ is the spatial random effect assigned to the function $f_1()$, for the set of coviarates $\boldsymbol{z}=\left(x_{1} = lat,\, x_{2} = long\right)$. $\boldsymbol\xi$ is also the GMRF defined in\@ref(def:gmrf), as a result it is distributed as a multivariate Normal centered in 0 and whose covariance function is Matérn (fig. \@ref(fig:matern)) i.e. $\xi_{i} \sim N\left(\mathbf{0}, \mathbf{Q}_{\mathscr{C}}^{-1}\right)$. The precision matrix  $\mathbf{Q}_{\mathscr{C}}^{-1}$ (see left panel in figure \@ref(fig:precisionmat)) is the one that requires to be treated with SPDE and its dimensions are $n \times n$, in this case when NAs are omitted adn after imputation it results in $192 \times 192$.
$\boldsymbol\beta$ are the model scraped covariates coefficients, which include condom, totlocali, altro, bagno, cucina, heating ... and the rest.
Then the latent field is composed by $\boldsymbol{\theta}=\{\boldsymbol{\xi}, \boldsymbol{\beta}\}$. In the end following the traits of the final expression in \@ref(GP) then the LGM can be reformatted as follows,

$$
\boldsymbol{\mathbf{y}}=\boldsymbol{z} \boldsymbol{\beta}+\boldsymbol{\xi}+\boldsymbol{\varepsilon}, \quad \boldsymbol{\varepsilon} \sim N\left(\mathbf{0},  \sigma^2_{\varepsilon} I_{d}\right)
$$
Priors are assigned as Gaussian vagues ones for the $\boldsymbol\beta$ coefficients with fixed precision, indeed for the GMRF priors are assigned to the matérn process $\boldsymbol\xi$ as Penalized in Complexity. The referring probability statements are: for the mean posterior of the spatial range in kilometres $\operatorname{Prob}(r<20)=0.8$ and for the standard deviation of the spatial effect $\operatorname{Prob}(\sigma^2<20)=0.8$, see section \@ref(spdemodeol).
Thus following the steps and notation marked in sec. \@ref(LGM). the _higher_ level eq. \@ref(eq:higher) is constituted by the **likelihood**, depending on hyper parameters $\boldsymbol\psi_1 = \left(\sigma_{\mathscr{\xi}}^{2}, \phi, \nu\right)$:

$$\pi(\boldsymbol{\mathbf{y}} \mid \boldsymbol{\theta}, \boldsymbol{\psi_1})=\prod_{i\ = 1}^{\mathbf{I}} \pi\left(y_{i} \mid \theta_{i}, \boldsymbol{\psi_1}\right)$$

At the _medium_ level eq. \@ref(eq:medium) there is the **latent field** $\pi(\boldsymbol{\theta} \mid \boldsymbol\psi_2)$, for which $\boldsymbol\psi_2 = \{\sigma_{\varepsilon}^2\}$, the only component is the measurement error precision, 


$$  \pi(\boldsymbol{\theta} \mid \boldsymbol{\psi_2})=(2 \pi)^{-n / 2}| \boldsymbol{Q_{\mathscr{C}}(\psi_2)}|^{1 / 2} \exp \left(-\frac{1}{2} \boldsymbol{\theta}^{\prime} \boldsymbol{Q_{\mathscr{C}}(\psi_2)} \boldsymbol{\theta}\right)$$

In the lower level priors are considered as their joint distribution i.e. $\boldsymbol\psi_ =\{ \boldsymbol\psi_1\, \boldsymbol\psi_2\}$. It follows the expression of the joint posterior distribution: 

$$
\pi(\boldsymbol{\theta}, \boldsymbol{\psi} \mid \mathbf{y})\propto  \underbrace{\pi(\boldsymbol{\psi})}_{\text {priors}} \times \underbrace{\pi(\boldsymbol\theta \mid \boldsymbol\psi)}_{\text {GMRF}} \times \underbrace{\prod_{i=1}^{\mathbf{192}} \pi\left(\mathbf{y} \mid \boldsymbol\theta, \boldsymbol{\psi}\right)}_{\text {likelihood }}
$$
Then one again the objectives of bayesian inference are the posterior marginal distributions for the latent field and the hyperparameters, which are contained in equation \@ref(eq:finalobj) for which Laplace approximations in \@ref(approx) are used.



<!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction --><!-- paramtere estimation and spatial prediction -->


## Building the SPDE object{#spdemodeol}

SPDE requires to triangulate the domain space $\mathscr{D}$ as intuited in \@ref(spdeapproach). The function `inla.mesh.2d` together with the `inla.nonconvex.hull` are able to define a good triangulation since no proper boundaries are provided. Four meshes are produced, whose figures are in \@ref(fig:meshes). Triangles appears seems to be thoroughly smooth and equilateral. The extra offset prevents the model to be affected by boundary effects. However the maximum ontainable number of vertices is in $\operatorname{mesh}_3$ , it appears to be the most suited to this dataset. Critical parameters for meshes are `max.edge=c(0.01, 0.02)` and  `offset=c(0.0475, 0.0625))`. Further trials have shown that below the lower bound of max.edge of $0.01$ the function is not able to output the triangulation.

<div class="figure">
<img src="07-model_fitting_files/figure-html/meshes-1.png" alt="Left: mesh traingulation for 156 vertices, Right: mesh traingulation for 324 vertices" width="672" />
<p class="caption">(\#fig:meshes)Left: mesh traingulation for 156 vertices, Right: mesh traingulation for 324 vertices</p>
</div>

$\operatorname{Prob}(r<3060)=0.01$ and for the standard deviation of the spatial effect $\operatorname{Prob}(\sigma^2<20)=0.8$

The SPDE model object is built with the function `inla.spde2.pcmatern()` which needs as arguments the mesh triangulation, i.e. $\operatorname{mesh}_3$ and the PC priors \@ref(priorsspec), satisfying the following probability statements: $\operatorname{Prob}(\sigma_{\varepsilon}^2<3060)< 0.01$ where $\sigma_{\varepsilon}^2$ is the spatial range desumed in \@ref(fig:semivariogram). And  $\operatorname{Prob}(\tau> 0.9)< 0.05$ where $\tau$ is the marginal standard deviation (on the log scale) of the field \@ref(spatassess).
As model complexity increases, for instance, a lot of random effects are found in the linear predictor and chances are that SPDE object may get into trouble. As a result the `inla.stack` function recreates the linear predictor as a combination of the elements of the old linear predictor and the matrix of observations. Further mathematical details about the stack are in @Blangiardo-Cameletti, but are beyond the scope of the analysis.





## Parameter estimation and Results{#fit}

In the end the model is fitted calling inla on the final formula i.e. $\log_{10}(price) \sim Intercept + totlocali ... \dots + f(coordinate, model = spde1)$ where all the rest of the covariates are omitted for brevity reasons. When the model has run, the conclusions for the random effects will now be discussed.


|coefficients          | mean|    sd| 0.025quant| 0.5quant| 0.975quant|
|:---------------------|----:|-----:|----------:|--------:|----------:|
|Intercept             | 6.19| 12.91|     -19.16|     6.19|      31.51|
|totlocali5+           | 1.92| 12.91|     -23.43|     1.92|      27.24|
|totlocaliPentalocale  | 1.55| 12.91|     -23.80|     1.55|      26.88|
|totlocaliQuadrilocale | 1.20| 12.91|     -24.14|     1.20|      26.53|
|totlocaliTrilocale    | 0.93| 12.91|     -24.41|     0.93|      26.26|
|totlocaliBilocale     | 0.58| 12.91|     -24.76|     0.58|      25.91|
|totlocaliMonolocale   | 0.00| 31.62|     -62.09|     0.00|      62.03|
|condom                | 0.00|  0.00|       0.00|     0.00|       0.00|

Since the models coefficients are too many the analysis will concentrate on the most interesting ones. Looking at TAB(...) arranged by descending mean, the posterior mean for the intercept in the rescaled from log is actually quite elevated, affirming that the average house price 485.99 €. Unsurprisingly the covariate condominium is positively correlated with the response price but its effect is not very tangible. This might imply that pricier apartments expect in mean the same condominium cost as the cheaper ones. (qualcosa di più)
Moreover Inla is able to output the mean and the standard deviation of measurement precision error in $\psi_2$ i.e. $1 / \sigma_{\varepsilon}^{2}$, note that the interpretation is different from variance, see TAB(). 
<!-- With a combination of `inla.tmarginal()` and  `inla.emarginal()`, refer to \@ref(rinla), it is possible to compute the mean and the sd for the error, see TAB (...) below.  -->


```
##                                              mean        sd 0.025quant
## Precision for the Gaussian observations 14.146477 1.8323868  10.835628
## Theta1 for site                         -4.244211 0.4302051  -5.053108
## Theta2 for site                          4.336038 0.4941173   3.324577
##                                          0.5quant 0.975quant      mode
## Precision for the Gaussian observations 14.049535  18.035766 13.878183
## Theta1 for site                         -4.259375  -3.363177 -4.313992
## Theta2 for site                          4.355101   5.262670  4.422629
```



|hyper-param                             |        sd|      mode|
|:---------------------------------------|---------:|---------:|
|Precision for the Gaussian observations | 1.8323868| 13.878183|
|Theta1 for site                         | 0.4302051| -4.313992|
|Theta2 for site                         | 0.4941173|  4.422629|


In respect to the function parameter the Matérn hyper parameters $\psi_1$ (penalized complexity priors) ...





 By using a summary, It can grasped the fixed random effect results

With regard to model criticsm, the model evaluation is focused on DIC and CPO, which are directly obtained from the output of the R-INLA object.

inference on posterior results, credibility levels 

posterior results table...


It might be of interest to plot the latent field which is projected from the model. 

<div class="figure">
<img src="07-model_fitting_files/figure-html/pltgmrf-1.png" alt="Gaussian Markov Random field result from the model" width="672" />
<p class="caption">(\#fig:pltgmrf)Gaussian Markov Random field result from the model</p>
</div>


<!-- a further trial  --> <!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  --><!-- a further trial  -->






## Model selection

Since covariates are many there also many possible combinations of predictors that may better express the response. However, there is the possibility to take advantage of several natively implemented ways to use built-in features. As a matter of fact in section \@ref(devbased) are presented a set of tools to compare models based on deviance criteria. One of them is DIC which actually balances the number of features applying a penalty when the number of features introduced increases eq. \@ref(eq:dic).
As a result a Forward Selection [@guyon2003introduction] algorithm is chosen. One at a time predictors are introduced into the model then results are stored into a dataframe. In the end the most satisfying combination based on DIC is sorted out.






## Spatial Model Criticism 


The model on the basis of the PIT \@ref(predbase) the model seems to be able to capture the variability and does not show any residual trend nor failures i.e. $\operatorname{fail} = $ 0 . The fact that the distribution is seemingly Uniform tells that the model is correctly specified. This is summarized by the LPML statistics which accounts for the negative log sum of each cross validate CPO obtaining 44.573. 

<div class="figure">
<img src="07-model_fitting_files/figure-html/modelcpo-1.png" alt="PIT cross validation statistics on $model_spde1$" width="672" />
<p class="caption">(\#fig:modelcpo)PIT cross validation statistics on $model_spde1$</p>
</div>

```
## [1] 189.4186
```






## Spatial Prediction on grid

A gridded object is required in order to project spatial prediction on the domain space. Usually these operations are very computationally expensive since grid objects size can easily reach $10^4$ to $10^6$ dimension points. Since in this case the linear predictor marginal distributions are not the focus then a more feasible solution consists in projecting the latent field estimated at the triangulation vertices onto the grid location [-@Blangiardo-Cameletti]. At first a proper projection matrix is created without specifying the locations. 





