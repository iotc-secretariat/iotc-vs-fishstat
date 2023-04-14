# FROM FISHSTATJ EXPORT DATA ####

# Export from FishstatJ data 1950-2021 (accessed on 14 April 2023)
# https://www.fao.org/fishery/statistics/software/fishstatj/en
# Selection "ISSCAAP group (Name)" = "Tunas, bonitos, billfishes"
# Data -> Columns: Select/add: "Country (Name)", "Country (ISO3 code)", "ASFIS species (3-alpha code)", "FAO major fishing area (Code)", "FAO major fishing area (Name)", "Unit"
# Format -> Number formatting -> Data export: Don't export symbols
FAO_RAW = fread("../inputs/data/FishStatJ_Export_Tunas_20230414.csv", fill = TRUE, encoding = "Latin-1")

# Remove Totals and metadata
# FAO_RAW = FAO_RAW[-grep("Totals|FAO", FAO_RAW$`Country (Name)`)]

# Remove "S" columns
# ColsSelected     = names(FAO_RAW)[names(FAO_RAW) != "S"]
# FAO_TABLE        = FAO_RAW[, ..ColsSelected]

# Remove brackets around years
names(FAO_RAW) = gsub(paste0("\\[|\\]"), "", names(FAO_RAW))

# Remove unit column
FAO_TABLE = FAO_RAW[, -c("Unit")]

# Rename the columns
setnames(FAO_TABLE, old = c("Country (Name)", "Country (ISO3 code)", "ASFIS species (3-alpha code)", "FAO major fishing area (Name)", "FAO major fishing area (Code)"), new = c("COUNTRY", "COUNTRY_CODE", "SPECIES_CODE", "FISHING_GROUND", "FISHING_GROUND_CODE"))

FAO_TUNAS_BONITOS_BILLFISH = melt.data.table(FAO_TABLE, id.vars = c("COUNTRY", "COUNTRY_CODE", "SPECIES_CODE", "FISHING_GROUND_CODE", "FISHING_GROUND"), value.name = "CATCH", variable.name = "YEAR")[CATCH>0]

# Export data
write.csv(FAO_TUNAS_BONITOS_BILLFISH, "../outputs/data/FSJ_TUNAS_BONITOS_BILLFISH_20230414.csv", row.names = FALSE)
