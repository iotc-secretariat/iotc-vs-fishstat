# Clears the environment
rm(list = ls())

source("90_LIBS_EXTERNAL.R")
source("91_LIBS_IOTC.R")

# FAO global capture production data
source("01.1_FAO_DATA_READING.R")

# ASFIS
source("01.2_SPECIES_TAXONOMY_RETRIEVAL.R")
#source("01.3_SPECIES_TAXONOMY_DESCRIPTION.R")
source("01.4_MERGING_FAO_CATCH_DATA_WITH_ASFIS.R")

# Define color palettes
source("92_COLOR_PALETTES.R")

# Catch trends



# Comparison with IOTC
source("02_IOTC_DATA.R")
source("03_COMP_CATCH_FLEET.R")
source("04_COMP_CATCH_SPECIES.R")
source("05_COMP_CATCH_YEAR.R")
source("06_COMP_CATCH_YEAR_SPECIES.R")
source("07_COMP_CATCH_YEAR_FLEET.R")
source("08_COMP_YEAR_FLEET_AREA_SPECIES.R")