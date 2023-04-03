# LIBRARIES ####
if(!require(pacman)){
  install.packages('pacman')
  suppressPackageStartupMessages(library(pacman,quietly = TRUE))
}

p_load(knitr, data.table, flextable, rmarkdown, bookdown, officer, magrittr, colorspace, tidyverse, openxlsx)

# Colors for barplots
NC_DIFF_COLORS_FILL    = c("#374BE5FF", "#FB4A6AFF")
NC_DIFF_COLORS_OUTLINE = c("#273AC0FF", "#D81C4AFF")

#prettyNum with default ',' as big mark
pn = function(number, big.mark = ",") {
  return(prettyNum(number, big.mark = big.mark))
}

# Charts theme
theme_set(theme_bw())

