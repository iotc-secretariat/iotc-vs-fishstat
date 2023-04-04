# DATA READING ####

## FROM FISHSTATJ EXPORT DATA ####

# Export from FishstatJ data 1950-2020 (accessed on 27 October 2021)
# https://www.fao.org/fishery/statistics/software/fishstatj/en
# "Country (Name)", "Country (ISO3 code)", "ASFIS species (Name)", "ASFIS species (3-alpha code)", "FAO major fishing area (Name)" "FAO major fishing area (Code)"
# FAO_RAW = fread("../inputs/data/FishStatJ_Export_IOTCSpecies.csv", fill = TRUE, encoding = "Latin-1")

# Remove Totals and metadata
# FAO_RAW = FAO_RAW[-grep("Totals|FAO", FAO_RAW$`Country (Name)`)]

# Remove "S" columns
# ColsSelected     = names(FAO_RAW)[names(FAO_RAW) != "S"]
# FAO_TABLE        = FAO_RAW[, ..ColsSelected]
# names(FAO_TABLE) = gsub(paste0("\\[|\\]"), "", names(FAO_TABLE))

# Rename the columns
#setnames(FAO_TABLE, old = c("Country (Name)", "Country (ISO3 code)", "ASFIS species (Name)", "ASFIS species (3-alpha code)", "FAO major fishing area (Name)", "FAO major fishing area (Code)"), new = c("COUNTRY", "COUNTRY_CODE", "SPECIES", "SPECIES_CODE", "FISHING_GROUND", "FISHING_GROUND_CODE"))

## FROM FISHSTAT RAW DATA ####

# Source: https://www.fao.org/fishery/static/Data/Capture_2022.1.1.zip
if(!file.exists("../inputs/data/Capture_Quantity.csv")){
  temp = tempfile(tmpdir = "../inputs/data/")
  download.file("https://www.fao.org/fishery/static/Data/Capture_2022.1.1.zip", temp)
  unzip(temp, exdir = "../inputs/data/")
  unlink(temp)
}

# Read the catch data
CAPTURE_RAW = fread("../inputs/data/Capture_Quantity.csv")

# Read the code lists
CL_COUNTRIES= fread("../inputs/data/CL_FI_COUNTRY_GROUPS.csv", encoding = "UTF-8")[, .(UN_CODE = UN_Code, COUNTRY_CODE = ISO3_Code, COUNTRY = Name_En)]

CL_SPECIES = fread("../inputs/data/CL_FI_SPECIES_GROUPS.csv", encoding = "UTF-8")[, .(SPECIES_CODE = `3A_Code`, SPECIES = Name_En, SPECIES_SCIENTIFIC = Scientific_Name, ISSCAAP_NAME = ISSCAAP_Group_En)]

CL_AREAS = fread("../inputs/data/CL_FI_WATERAREA_GROUPS.csv")[, .(FISHING_GROUND_CODE = Code, FISHING_GROUND = Name_En)]

CL_UNITS = fread("../inputs/data/FSJ_UNIT.csv")[, .(MEASUREMENT_CODE = Code, MEASUREMENT_NAME = Name_En)]

# Build the full data set with code lists
CAPTURE = CAPTURE_RAW[CL_COUNTRIES, on = c("COUNTRY.UN_CODE" = "UN_CODE"), nomatch = 0][CL_SPECIES, on = c("SPECIES.ALPHA_3_CODE" = "SPECIES_CODE"), nomatch = 0][CL_AREAS, on = c("AREA.CODE" = "FISHING_GROUND_CODE"), nomatch = 0][CL_UNITS, on = c("MEASURE" = "MEASUREMENT_CODE"), nomatch = 0][, COUNTRY.UN_CODE := NULL]

# Filter on tuna and tuna-like species
# All measurements available as Q_tlw - Tonnes - Live weight
NC_FAO = CAPTURE[ISSCAAP_NAME == "Tunas, bonitos, billfishes"]
NC_FAO[, ISSCAAP := 36]

setnames(NC_FAO, old = c("SPECIES.ALPHA_3_CODE", "AREA.CODE", "VALUE"), new = c("SPECIES_CODE", "FISHING_GROUND_CODE", "CATCH"))

# Filter on Indian Ocean
NC_FAO_IO = NC_FAO[FISHING_GROUND %in% c("Indian Ocean, Western", "Indian Ocean, Eastern")]



