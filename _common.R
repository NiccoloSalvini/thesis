
  # dpi = 300,
  # cache.lazy = FALSE,
  # tidy = "styler",
  # out.width = "90%",
  # fig.align = "center",
  # fig.width = 5,
  # fig.height = 7
  #


### gen.options ###

knitr::opts_chunk$set(
  tidy.opts=list(width.cutoff=80),
  tidy=TRUE,
  warning = FALSE,
  collapse = TRUE,
  strip.white = TRUE,
  message = FALSE,
  cache = FALSE,
  echo = FALSE,
  fig.align = "center",
  comment = "#>"
)



theme_nicco2 = function (base_size = 11, base_family = "") {
  theme_bw() %+replace%
    theme(
      text = element_text(family = "sans", size = 12),
      plot.title = ggplot2::element_text(size = 18, colour = "#454545",hjust = 0.5, margin = ggplot2::margin(b = 10)),
      panel.background  = element_blank(),
      panel.grid.major = ggplot2::element_line(linetype = "dotted",colour = "#454545",size = 0.3),
      panel.grid.minor = ggplot2::element_blank(),
      axis.ticks = element_line(colour = "grey70", size = 0.2),
      axis.line = ggplot2::element_line(color = "#454545", size = 0.3),
      plot.background = element_rect(fill="white", colour=NA),
      panel.border = element_rect(linetype = "blank", fill = NA),
      legend.background = element_rect(fill="transparent", colour=NA),
      legend.key = element_rect(fill="transparent", colour=NA),
      strip.background = ggplot2::element_rect(fill = "transparent",colour = NA),
      axis.title = ggplot2::element_text(size = 13, colour = "#454545",hjust = 0.95),
      axis.text = ggplot2::element_text(size = 10, colour = "#212121"),
      strip.text = ggplot2::element_text(size = 12, colour = "#454545",
                                         margin = ggplot2::margin(10, 10,
                                                                  10, 10,
                                                                  "pt"))
    )
}


theme_nicco = function (base_size = 11, base_family = "") {
  theme_bw() %+replace%
    theme(
      text = element_text(family = "sans", size = 12),
      plot.title = element_text(face = "bold", size = 14, margin=margin(0,0,30,0)),
      panel.background  = element_blank(),
      axis.ticks = element_line(colour = "grey70", size = 0.2),
      plot.background = element_rect(fill="white", colour=NA),
      panel.border = element_rect(linetype = "blank", fill = NA),
      legend.background = element_rect(fill="transparent", colour=NA),
      legend.key = element_rect(fill="transparent", colour=NA)
    )
}

library(ggplot2,warn.conflicts = F,quietly = T)
library(latex2exp, warn.conflicts = F, quietly = T)
latex2exp_supported(plot=TRUE)
options(crayon.enabled = FALSE)
suppressPackageStartupMessages(library(tidyverse))
