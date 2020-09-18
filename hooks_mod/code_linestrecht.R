library(knitr)
opts_chunk$set(eval = F)
def.source.hook  <- knitr::knit_hooks$get("source")
knit_hooks$set(source = function(x, options) {
  x <- def.source.hook(x, options)
  x <- ifelse(!is.null(options$linestretch) & knitr::is_latex_output(),
              paste0("\\linespread{", options$linestretch,"}\n", x, "\n\n\\linespread{", lstr,"}"),
              x)
})
