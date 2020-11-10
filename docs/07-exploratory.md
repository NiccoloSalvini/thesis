# Exploratory Analysis {#exploratory}

<!--  You can label chapter and section titles using `{#label}` after them, e.g., we can reference Chapter \@ref(intro). If you do not manually label them, there will be automatic labels anyway, e.g., Chapter \@ref(methods).-->



Data comes packed into the REST API end point `*/complete` in .json format. Data can be filtered out On the basis of the options set in the API endpoint argument body. Some of the options might regard the `city` in which it is aevaluated the real estate market, `npages` as the number of pages to be scraped, `type` as the choice between rental of selling. For further documentation on how to structure the API endpoint query refer to section \@ref(APIdocs).  Since to the analysis purposes data should come from the same source (e.g. Milan rental real estate within "circonvallazione") a dedicated endpoint boolean option `.thesis` is passed in the argument body. What the API option under the hood is doing is specifying a structured and already filtered URL to be passed to the scraping endppoint. By securing the same URL to the scraping functions data is forced to come from the same URL source. The idea behind this concept can be thought as refreshing everyday the same immobiliare.it URL. API endpoint by default also specifies 10 pages to be scraped, in this case 120 is provided leading to to 3000 data points. The `*` refers to the EC2 public DNS that is `ec2-18-224-40-67.us-east-2.compute.amazonaws.com`

`http://*/complete/120/milano/affitto/.thesis=true`

As a further source data can also be accessed through the mondgoDB credentials with the cloud ATLAS database by picking up the latest .csv file generated. For run time reasons also related to the bookdown files continuous building the API endpoint is called the day before the presentation so that the latest .csv file is available. As a consequence code chunks outputs are all cached due to heavy computation.
Interactive  maps are done with Leaflet, the result of which is a leaflet map object which can be piped to other leaflet functions. This permits multiple map layers and many control options to be added interactively (LaTex output is statically generated)

A preliminary API data exploratory analysis evidences 34 covariates and 250 rows, which are once again conditioned to the query sent to the API. Immobiliare.it furnishes many information regarding property attributes and estate agency circumstances. Data displays many NA in some of the columns but georeference coordinates, due to the design of scraping functions, are in any case present. 






\begin{longtable}{ll}
\toprule
name & ref\\
\midrule
ID & ID of the apartements\\
LAT & latitude coordinate\\
LONG & longitude coordinate\\
LOCATION & the complete address: street name and number\\
CONDOM & the condominium monthly expenses\\
\addlinespace
BUILDAGE & the age in which the building was contructed\\
FLOOR & the property floor\\
INDIVSAPT & indipendent property type versus apartement type\\
LOCALI & specification of the type and number of rooms\\
TPPROP & property type residential or not\\
\addlinespace
STATUS & the actual status of the house, ristrutturato, nuovo, abitabile\\
HEATING & the heating system Cen\_Rad\_Gas (centralizzato a radiatori, alim a gas), Cen\_Rad\_Met,\\
AC & air conditioning hot and cold, Autonomo, freddo/caldo, Centralizzato, freddo/caldo\\
PUB\_DATE & the date of publication of the advertisement\\
CATASTINFO & land registry information\\
\addlinespace
APTCHAR & apartement main characteristics\\
PHOTOSNUM & number of photos displayed in the advertisement\\
AGE & real estate agency name\\
LOWRDPRICE.originalPrice & If the price is lowered it flags the starting price\\
LOWRDPRICE.currentPrice & If the price is lowered it flags the current price\\
\addlinespace
LOWRDPRICE.passedDays & If the price is lowered indicates the days passed since the price has changed\\
LOWRDPRICE.date & If the price is lowered indicates the date the price has changed\\
ENCLASS & the energy class according to the land registers\\
CONTR & the type of contract\\
DISP & if it is still avaiable or already rented\\
\addlinespace
TOTPIANI & the total number of the building floors\\
PAUTO & number of parking box or garages avaibable in the property\\
REVIEW & estate agency review, long chr string\\
HASMULTI & it if has multimedia option, such as 3D house vitualization home experience or videos\\
PRICE & the monthly price <- response\\
\addlinespace
SQFEET & square meters footage\\
NROOM & the number of rooms in the house, and their types\\
TITLE & title of published advertisement\\
\bottomrule
\end{longtable}


## Data preparation 



Data needs to undergo to many previous cleaning preprocess steps, this is a forced stage since API data comes in human readable format, which is not prepared to be modeled. Cleaning steps mainly regards:

- encoding from UTF-8 to Latin due to Italian characters incorrectly parsed.
- *FLOORS* covariate needs to be separated by its *ASCENSORE* and *ACCDISABILI* components, adding 2 more bivariate covariates.
- *LOCALI* needs to be separated too. 5 category levels drain out: *TOTLOCALI*, *CAMERELETTO*, *ALTRO*, *BAGNO*, *CUCINA*. *NROOM* is a duplicate for *TOTLOCALI*, so it is discarded.
- *APTCHAR* is a list column so that each observation has different categories inside. The preprocess step includes unnesting the list by creating as many bivariate columns as elements in the list. Then new columns flag the existence of the characteristics in the apartment. A slice for the fist APTCHAR observation displays:

- - fibra ottica- - - videocitofono- - - impianto di allarme- - - porta blindata- - - reception- - - balcone- - - portiere intera giornata- - - impianto tv centralizzato- - - parzialmente arredato- - - esposizione doppia- -

### Maps and Geo-Visualisations

Geographic coordinates can be represented on a map in order to reveal first symptoms of spatial autocorrelation. Observations are spread almost equally throughout the surface even though the response var *PRICE* indicates unsurprisingly that higher prices are nearer to the city center.
The map in figure \@ref(fig:leaflet_visuals) is a leaflet object, which can needs to be overlapped with layers indicating different maps projections. This is interactive in the .html version, and static is proposed in the .pdf output version. The map object takes a input the latitute and longitude coordinates coming from THE API, and they do not need any CRS (Coordinate Reference System) projection since leaflet can accept the data type.

\begin{figure}
\includegraphics[width=1\linewidth]{images/leaflet_prezzi} \caption{Leaflet Map}(\#fig:LeafletVisuals)
\end{figure}

(other more tmap and ggplot)

## Counts and First Orientations

Arranged Counts for categorical columns can give a sense of the distribution of categories across the dataset suggesting also which predictor to include in the model. The visualization in figure \@ref(fig:fctCounts) offers the rearranged factor *TOTLOCALI*. 
Bilocali are the most common option for rent, then trilocali comes after. The intuition behind suggests that Milan rental market is oriented to "lighter" accommodations in terms of space and squarefootage. This should comes natural since Milan is both a vivid study and working area, so short stayings are warmly welcomed.

![(\#fig:fctCounts)Most common housedolds categories](07-exploratory_files/figure-latex/fctCounts-1.pdf) 

Two of the most requested features for comfort and livability in rents are the heating/cooling systems installed. Moreover rental market demand, regardless of the rent duration, strives for a ready-to-accomodate offer to meet clients needs. In this sense accomodation coming with the newest and most techonological systems are naturally preferred with respect the contrary. 
x-axis in figure \@ref(fig:PricePerAc) represents log_10 price for both of the two plots. Logarithmic scale is needed to smooth distributions and the resulting price interpretation have to considered into relative percent changes. Furthermore factors are reordered with respect to decreasing price.  
y-axis are the different level for the categorical variables recoded from the original data due to simplify lables and to hold plot dimension. Moreover counts per level are expressed between brackets close to their respective factor.
The top plot displays the most prevalent heating systems categories, among which the most prevalent is "Cen_Rad_Met" by far. This fact is extremely important since metano is a green energy source and if the adoption is wide spread and pipelines are well organized than it brings enormous benefit to the city. As a consequence one major concern regards that for many years policies have been oriented to reduce vehicles emission (euro1 euro2...) instead of focusing on house emissions. This was also a consequence of the lack of house data especially in rural areas. According to data there are still a 15% portion of houses powered by oil fired. 
Then in bottom plot Jittering is then applied to point out the number of outliers outside the IQR (Inter Quantile Range) .25 and their impact on the distribution. A first conclusion is that outliers are mainly located in autonomous systems, which leads of course to believe that the most expensive houses are heated by autonomoius heating systems. Indedd in any case this fact that does not affect monthly price. The overlapping IQR signifies that the covariates levels do not impact the response variable.


![(\#fig:PricePerAc)Log Monthly Price per Heating/Cooling system?](07-exploratory_files/figure-latex/PricePerAc-1.pdf) 


this visualization intersects allows to discover bimodality in the response variable.  Log scales was needed since they are all veru skewd and log scale then is needed also in the model.

(qui ci puoi mettere a confronto per variabile bianria, così vedi cosa includere nel modello esempio sotto dove commentato, )

![](07-exploratory_files/figure-latex/unnamed-chunk-1-1.pdf)<!-- --> 

What it might be really relevant to research is how monthly prices change with respect to house square footage for each house configuration. The idea is to asses how much adding a further square meter affetcs the monthly price for each n-roomed flat.
One implication is how the property should be developed in order to request a greater amount of money per month. As an example in a situation in which the household has to lot its property into different sub units he can be helped to decide the most proficient choice in economic terms by setting ex ante the square footage extensions for each of the sub-properties.
A further implication can regard economic convenience to enlarge new property acquisitions under the expectation to broadened the square footage (construction firms). Some of the potential enlargements are economically justified, some of the other are not.
The plot  \@ref(fig:GlmPriceSq) has two continuous variables for x (price) and y (sqfeet) axis, the latter is log 10 scaled due to smoothness reasons. Coloration discretizes points for the each $j$ household rooms totlocali. A sort of overlapping  piece-wise linear regression (log-linear due to transformation) is fitted on each totlocali group, whose response variable is price and whose only predictor is the square footage surface (i.e.  $\log_{10}(\mathbf{price_j}) \sim +\beta_{0,j}+\beta_{1,j}\mathbf{sqfeet_j}$). Five different regression models are proposed in the top left. The interesting part regards the models slopes $\hat\beta_{1,j}$. The highest corresponds to "Monolocale" for which the enlargement of a 10 square meters in surface enriches the apartment of a 0.1819524% monthly price addition. Almost the same is witnessed in "Bilocale" for which a 10 square meters extension gains a 0.1194379% value. One more major thing to notice is the "ensamble" regression line obtained as the interpolation of the 5 plotted ones. The line suggests a clear slope descending pattern (logarithmic trend) from Pentalocale and beyond whose assumption is strengthened by looking at the decreasing trend in the $\hat\beta_1$ predictor slopes coefficients. Furthermore investing into an extension for "Quadrilocale" and "Trilocale" is _coeteris paribus_ an interchangeable economic choice.

![](07-exploratory_files/figure-latex/GlmPriceSq-1.pdf)<!-- --> 

In table (...) resides the answer to the question "which are the most profitable properties per month in terms of the price per square meter footage ratio". The covariate floor together with the totpiani are not part of the model, indeed they can explain the importance and the height of the building justifying extraordinary prices.  The first 4 observations are unsurprisingly "Bilocale", the spatial column location, not a regressor, can lend a hand to acknowledge that the street addresses point to very central and popular zones. The zones are, first City Life, second Brera and third Moscova, proving that in modeling real estate rents the spatial component is fundamental , even more in Milan. 


\begin{tabular}{llrrllr}
\toprule
location & totlocali & price & sqfeet & floor & totpiani & abs\_price\\
\midrule
viale cassiodoro 28 & Bilocale & 1750 & 30 & 9 piano & 10 piani & 58.33333\\
via della spiga 23 & Bilocale & 2750 & 55 & 2 piano & 4 piani & 50.00000\\
corso giuseppe garibaldi 95 & Bilocale & 2700 & 56 & 2 piano & 5 piani & 48.21429\\
piazza san babila C.A. & Bilocale & 1833 & 42 & 4 piano & 4 piani & 43.64286\\
ottimo stato piano terra, C.A. & Trilocale & 3000 & 80 & Piano terra & 3 piani & 37.50000\\
\addlinespace
via federico confalonieri 5 & Monolocale & 750 & 20 & 1 piano & 3 piani & 37.50000\\
\bottomrule
\end{tabular}

Then as a further point it might be important to investigate a linear model whose response is price and whose covariates are the newly created abs_price and some other presumably important ones  i.e. floor. The model fitted is `log2(price) ~ log2(abs_price) + floor`.
The plot in figure \@ref(fig:TieFighterPlot) tries to give the intuition on unusual effects across different floors. The interpretation starts by considering the house surface effect (i.e. House Surface (doubling)) for each doubling of the square meter footage. Then what it can be seen is that both apartments and ultimo piano are unsually expensive with respect to their square meter footage. On the other hand the piano rialzato and piano terra are unusually inexpensive for their surface.  
In other words the plot has the analytical purpose to demonstrate how monthly price is affected by floor conditioned to their respective square meter footage. The term log2(abs_price) has been converted to more familiar House Surface (doubling) to help with the interpretation.

![(\#fig:TieFighterPlot)Coefficient Tie fighter plot for the linear model: log2(price) ~ log2(abs_price) + condom + other_colors](07-exploratory_files/figure-latex/TieFighterPlot-1.pdf) 


(se vuoi dire qualcosa sul condominio)

## Missing Assessement and Imputation

As already pointed out some data might be lost since immobiliare provides the information that in turn are pre filled by estate agencies or privates through standard document formats. Some of the missing can be reverse engineered by other information in the web pages e.g. given the street address it is possible to trace back the lat and long coordinates. Some other information can be encountered in .json files hidden inside each of the single webpages.
The approach followed in this part is to prune redundant data and rare covariates trying to limit the dimensionality of the dataset.

### Missing assessement 

The first problem to assess is why information are missing. As already pointed out in the introduction part and in section \@ref(ContentArchitecture) many of the presumably important covariates (i.e. price lat, long, title ,id ...) undergo to a sequence of forced step inside scraping functions with the aim to avoid to be missed.  If in the end of the sequence the covariates are still missing, the correspondent observation is not considered and it is left out of the scraped dataset. The choice originates from empirical missing patterns suggesting that when important information are missing then the rest of the covariates are more likely to be missing to, as a consequence the observation should be discarded.
The missing profile is crucial since it can also raise suspicion on the scraping failures. By Taking advantage of the missing pattern in observations the maintainer can directly identify the problem and derivatives and immediately debug the error. In order to identify if the nature of the pattern a revision of missing and randomness is introduced by @Little.
Missing can be devided into 3 categories:

- *MCAR* (missing completely at random) likelihood of missing is equal for all the infromation, in other words missing data are one idependetn for the other.
- *MAR* (missing at random) likelihood of missing is not equal.
- *NMAR* (not missing at random) data that is missing due to a specific cause, scarping can be the cause.

MNAR is often the case of daily monitoring clinical studies [@Kuhn], where patient might drop out the experiment because of death and so all the relating data starting from the death time +1 are lost.
To identify the pattern a _heat map_  plot \@ref(fig:Heatmap) clarifies the idea:

![(\#fig:Heatmap)Missingness Heatmap plot](07-exploratory_files/figure-latex/Heatmap-1.pdf) 

Looking at the top of the heat map plot, right under the "Predictor" label, the first tree split divides predictors into two sub-groups. The left branch considers from *TOTPIANI* to *CATASTINFO* and there are no evident patterns. Then missingness can be traced back to MAR. Imputation needs to be applied up to *CONDOM* included, the others are discarded due to rarity: i.e. *BUILDAGE*: 14% missing, *CATASTINFO*: 21% and *AC*: 24%. Moreover *CUCINA* and *ALTRO* are generated as "childred" of the original *LOCALI* variable, so it should not surprise that their missing behavior is similar ,whose prevalence is respectively 13% and 14%, for that reason are discarded. 
In the far right hand side *ENCLASS* and *DISP* data are completely missing and a pattern seems to be found. The most obvious reason is a scraping fail in capturing data. Further inspection of the API scraping functions focused on the two covariates is strongly advised. From *LOWRDPRICE.* covariates gorup class it seems to be witnessing a missing underlining pattern NMAR which is clearer by looking at the co_occurrence plot in figure \@ref(fig:cooccurrence). Co-occurrence analysis might suggest frequency of missing predictor in combination and *LOWRDPRICE.* class covariates are displaying this type of behavior. *PAUTO* is missing in the place where *LOWRDPRICE.* class covariates are missing, but this is not happening for the opposite, leading to the conclusion that *PAUTO* should be treated as a rare covariate MAR, therefore *PAUTO* is dropped.
After some further investigation on *LOWRDPRICE.*, the group class flags when the *PRICE* covariate is effectively decreased and this is unusual. That is solved by grouping the covariate's information and to encode it as a two levels categorical covariate if lowered or not. Further methods to feature engineer the *LOWRDPRICE.* class covariates can be with techniques typical of profile data, further references are on @Kuhn.

![(\#fig:cooccurrence)Missingness co-occurrence plot](07-exploratory_files/figure-latex/cooccurrence-1.pdf) 



### Covariates Imputation


A relatively simple approach to front missingness is to build a regression model to explain the covariates that have some missing and plug-back-in the respective estimates (e.g. posterior means) from their predictive distributions @Little. This approach is fast and easy to implement in most of the cases, but it ignores the uncertainty behind the imputed values [@Bayesian_INLA_Rubio]. However it has the benefit to be a more than a reasonable choice with respect to the number of computation required, especially with INLA and in a spatial setting. That makes it the first choice method to follow since imputation regards also a small portion of data and predictors. At first it is considered the predictor _condominium_  for which some observation are missing. Indices are:


```
##  [1]  19  74  77  90  99 113 116 120 179 249
```



<!-- and a benchmark model is fitted whose formula is `price ~ 1 + condom + bagno + sqfeet`. Inla handles missing data by ignoring them so the model trains coefficients on a restricted sample of observations. -->

<!-- ```{r} -->
<!-- ## benchmark model -->
<!-- benchmark = inla(price ~ 1+ condom + totlocali + sqfeet, data = data_miss) -->
<!-- benchmark$summary.fixed %>%  -->
<!--   rownames_to_column(var = "terms") %>%  -->
<!--   as_tibble() %>%  -->
<!--   select(terms:sd) %>%  -->
<!--   column_to_rownames(var = "terms")  %>% -->
<!--   head(6) %>%  -->
<!--   knitr::kable(booktabs = T) -->

<!-- ``` -->


A model is fitted based on missing data for which the response var is condominium and predictors are other important explanatory ones, i.e.`condom ~ 1 + sqfeet + totlocali + floor + heating + ascensore`. In addition to the formula in the inla function a further specification has to be provided with the command `compute = TRUE` in the argument control.predictor. The command `compute` estimates the posterior means of the predictive distribution in the response variable for the missing points. The estimated posetior mean quantities are then imputeda are in table \@red(tab:CondomImputation)


\begin{tabular}{lrr}
\toprule
  & mean & sd\\
\midrule
fitted.Predictor.019 & 198.11095 & 19.67085\\
fitted.Predictor.074 & 162.96544 & 13.29456\\
fitted.Predictor.077 & 99.38197 & 32.34108\\
fitted.Predictor.090 & 331.73519 & 33.05035\\
fitted.Predictor.099 & 170.54068 & 12.30267\\
\addlinespace
fitted.Predictor.113 & 196.61593 & 15.86545\\
fitted.Predictor.116 & 108.40482 & 20.79689\\
fitted.Predictor.120 & 162.86977 & 25.61622\\
fitted.Predictor.179 & 165.03632 & 20.53485\\
fitted.Predictor.249 & 117.24234 & 30.80290\\
\bottomrule
\end{tabular}





<!-- Afterwards the benchmark model is refitted in imputed data and coefficients are compared with the missing. Results displays... -->

<!-- ```{r refitting} -->

<!-- data_imputed = data.frame(data_miss) -->
<!-- data_imputed$condom[condom_na] = cov_imputation$summary.fitted.values[condom_na, "mean"] -->
<!-- which(is.na(data_imputed$condom)) -->

<!-- refitted = inla(price ~ 1 + condom + totlocali+ sqfeet, data = data_imputed) -->
<!-- refitted %>%  summary() -->
<!--   rownames_to_column(var = "terms") %>%  -->
<!--   as_tibble() %>%  -->
<!--   select(terms:sd) %>%  -->
<!--   column_to_rownames(var = "terms")  %>% -->
<!--   head(6) %>%  -->
<!--   knitr::kable(booktabs = T) -->
<!-- ``` -->


A further method for imputation has been designed by _Gómez-Rubio, Cameletti, and Blangiardo 2019) miss lit_ by adding a sub-model for the imputations to the final model through the inla function. This is directly handled inside the predictor formula adding a parameter in the latent field. However the approach makes the model more complex with a further layer of uncertainty to handle. 
At first the additive regression model with all the covariates is called including the covariates with missing values. The response variable *PRICE* displays no missing values and the model fitted is: 

 
## Model Specification



## Mesh building 

*PARAFRASARE*
The SPDE approach approximates the continuous Gaussian field $w_{i}$ as a discrete Gaussian Markov random field by means of a finite basis function defined on a triangulated mesh of the region of study. The spatial surface can be interpolated performing this approximation with the inla.mesh.2d() function of the R-INLA package. This function creates a Constrained Refined Delaunay Triangulation (CRDT) over the study region, that will be simply referred to as the mesh. Mesh should be intended as a trade off between the accuracy of the GMRF surface representation and the computational cost, in other words the more are the vertices, the finer is the GF approximation, leading to a computational funnel. 

![Traingularization intuition, @Krainski-Rubio source](images/triangle.jpg)

Arguments can tune triangularization through inla.mesh.2d() :

* `loc`:location coordinates that are used as initial mesh vertices
* `boundary`:object describing the boundary of the domain,
* `offset`:  argument is a numeric value (or a length two vector) and it is used
to set the automatic extension distance. If positive, it is the extension distance
in the same scale units. If negative, it is interpreted as a factor relative to the
approximate data diameter; i.e., a value of -0.10 (the default) will add a 10%
of the data diameter as outer extension.
* `cutoff`: points at a closer distance than the supplied value are replaced by a single vertex. Hence, it avoids small triangles 
* `max.edge`: A good mesh needs to have triangles as regular as possible in size and shape.
* `min.angle`argument (which can be scalar or length two vector) can be used to specify the minimum internal angles of the triangles in the inner domain and the outer extension

A convex hull is a polygon of triangles out of the domain area, in other words the extension made to avoid the boundary effect. All meshes in Figure 2.12 have been made to have a convex hull boundary. If borders are available are generally preferred, so non convex hull meshes are avoided.



### Shinyapp for mesh assessment

INLA includes a Shiny (Chang et al., 2018) application that can be used to tune the mesh params interactively




The mesh builder has a number of options to define the mesh on the left side. These include options to be passed to functions inla.nonconvex.hull() and inla.mesh.2d() and the resulting mesh displayed on the right part.

### BUilding SPDE model on mesh




## Spatial Kriging (Prediction)

QUI INCERTEZZE









