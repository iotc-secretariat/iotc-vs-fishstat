
# READ ####

#library(iotc.base.common.data)
#NC_RAW  = NC_raw(years = 1950:2019, factorize_results = FALSE)[IS_IOTC_SPECIES == TRUE]
NC_RAW = fread("../inputs/data/IOTC_NC_RAW.csv")

# CONSOLIDATE ####
NC_RAW[SPECIES_CODE %in% c("AG03", "BXQ", "AG14"), `:=` (SPECIES_CODE = "BIL", SPECIES = "Marlins,sailfishes,etc. nei")]
NC_RAW[SPECIES_CODE %in% c("TUS", "AG06", "AG10", "AG35", "AG45"), `:=` (SPECIES_CODE = "TUN", SPECIES = "Tunas nei", SPECIES_CATEGORY_CODE = "TROPICAL")]

# Combine BLT and FRI into FRZ
NC_RAW[SPECIES_CODE %in% c("BLT", "FRI"), `:=` (SPECIES_CODE = "FRZ", SPECIES = "Frigate and bullet tunas", IS_SPECIES_AGGREGATE = TRUE)]

# Combine COM and GUT into KGX
NC_RAW[SPECIES_CODE %in% c("COM", "GUT"), `:=` (SPECIES_CODE = "KGX", SPECIES = "Seerfishes nei", IS_SPECIES_AGGREGATE = TRUE)]

# Correct error in code for Timor Leste
NC_RAW[FLEET_CODE == "TMP", FLEET_CODE := "TLS"]

# Unify the category code for Tunas nei
NC_RAW[SPECIES_CODE == "TUN", SPECIES_CATEGORY_CODE := "TROPICAL"]

# Regroup the NEI fleets under NEI
NC_RAW[FLEET_CODE %in% unique(grep("NEI", NC_RAW$FLEET_CODE, value = TRUE)), `:=` (FLEET_CODE = "NEI", FLEET = "Fleets nei")]

NC_IOTC = NC_RAW[, .(CATCH = sum(CATCH)), keyby = .(FLEET_CODE, FLEET, SPECIES, SPECIES_CODE, IS_SPECIES_AGGREGATE, SPECIES_CATEGORY_CODE, FISHING_GROUND_CODE, FISHING_GROUND, YEAR)]