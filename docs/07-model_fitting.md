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


