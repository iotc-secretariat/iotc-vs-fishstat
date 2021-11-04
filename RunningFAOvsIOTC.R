# Source the R codes
setwd("initialization")
source("00_CORE.R")
setwd("..")

# DOCX
render("FAOvsIOTC.Rmd", 
       output_format = "word_document2", 
       output_dir    = "outputs/"
)


