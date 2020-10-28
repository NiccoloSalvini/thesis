
#######################
###### Libraries ######
#######################

pacchetti = c("tidyverse",
              "magrittr",
              "bibtex",
              "geoR",
              "ggplot2",
              "readr",
              "rgdal",
              "leaflet",
              "mapview",
              "INLA",
              "patchwork",
              "rgdal",
              "here")

## RUN COMMAND TO ADD LIBRARY
## write.bib(pacchetti, file = "Rpackages.bib", append = TRUE)

invisible(lapply(pacchetti, library, character.only = TRUE))

