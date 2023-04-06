# LIBRARIES ####
if(!require(pacman)){
  install.packages('pacman')
  suppressPackageStartupMessages(library(pacman,quietly = TRUE))
}

p_load("knitr", "data.table", "flextable", "rmarkdown", "bookdown", "officer", "magrittr", "colorspace", "tidyverse", "openxlsx", "ritis", "taxize", "dendextend", "ape", "ggdendro", "ggsci")

# Charts theme
theme_set(theme_bw())

