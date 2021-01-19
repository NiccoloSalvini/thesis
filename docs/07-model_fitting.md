# Model Selection & Fitting{#modelspec}

- metti @Ling che ha messo i prioris come defaults nella inla call


[ref.](https://inbo.github.io/tutorials/tutorials/r_inla/spatial.pdf)

```r
library(readr)
data = read_csv("data/data2021.csv")
mesh2 <- inla.mesh.2d(confini, max.edge = c(0.2, 0.2),cutoff = 3)
ggplot(data) + gg(mesh2) + geom_sf() +
ggtitle(paste("Vertices: ", mesh2$n)) + coord_sf(datum = st_crs(5880))
```


fit with the suggestion of INLA in [ref](https://www.r-inla.org/faq#h.sxjo232d6ho5)

```r
library(spdep)
library(spDataLarge)
border <- readShapePoly(system.file("data/confini/A090101_ComuneMilano.shp", package="spdep")[1])
```


```r
require(sp)  # package to work with spatial data
require(rgdal)
library(leaflet)
library(sf)


milan_borders = readOGR("data/confini/A090101_ComuneMilano.dbf")
proj4string(milan_borders)
milan_borders_pj <- spTransform(milan_borders, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
pal = colorBin("viridis", bins = c(100,200,300,400))

leaflet(dati) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircles(lng = ~long, lat = ~lat, color = ~pal(price))%>%
  addLegend("bottomright",
    pal = pal, values = ~price,
    title = "Price"
  ) %>%
  addScaleBar(position = c("bottomleft"))
```





[mega ref](https://inlabru-org.github.io/inlabru/)

[mega mega ref](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13168)


```r
library(inlabru)
formula = price ~ condom + totlocali + sqfeet 
```




```r
ggplot(data)+
  geom_point(aes(lat, long), size = 2) +
  coord_fixed(ratio = 1) +
  scale_color_gradient(low = "blue", high = "orange") +
  geom_sf(data = confini) +
  theme_bw()
```






**covariate choice **
## Model Selection

- wang pagina 49
In regression analysis, we often want to find a reduced model with the best subset of
the variables from the full model. The model selection in frequentist analysis is com-
monly based on Akaike information criterion (AIC), a MLE-based criterion. Back to
the air pollution data example, a stepwise model selection procedure using AIC can
be implemented by the function stepAIC in R library MASS


```r
library(MASS)
usair.step <- stepAIC(usair.lm1, trace = FALSE)
usair.step$anova
```


## Mesh Construction 200 blangiardo



how to fit a spatial model
https://www.r-inla.org/faq#h.sxjo232d6ho5


