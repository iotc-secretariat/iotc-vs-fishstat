
# READ ####

# FishstatJ data 1950-2020 (accessed on 27 October 2021)
# https://www.fao.org/fishery/statistics/software/fishstatj/en
# "Country (Name)", "Country (ISO3 code)", "ASFIS species (Name)", "ASFIS species (3-alpha code)", "FAO major fishing area (Name)" "FAO major fishing area (Code)"
FAO_RAW = fread("../inputs/data/FishStatJ_Export_IOTCSpecies.csv", fill = TRUE)

# Remove Totals and metadata
FAO_RAW = FAO_RAW[-grep("Totals|FAO", FAO_RAW$`Country (Name)`)]

# Remove "S" columns
ColsSelected     = names(FAO_RAW)[names(FAO_RAW) != "S"]
FAO_TABLE        = FAO_RAW[, ..ColsSelected]
names(FAO_TABLE) = gsub(paste0("\\[|\\]"), "", names(FAO_TABLE))

# Rename the columns
setnames(FAO_TABLE, old = c("Country (Name)", "Country (ISO3 code)", "ASFIS species (Name)", "ASFIS species (3-alpha code)", "FAO major fishing area (Name)", "FAO major fishing area (Code)"), new = c("COUNTRY", "COUNTRY_CODE", "SPECIES", "SPECIES_CODE", "FISHING_GROUND", "FISHING_GROUND_CODE"))

# FAO country list
FAO_COUNTRY_LIST = unique(FAO_RAW[, .(`Country (Name)`, `Country (ISO3 code)`)])[order(`Country (Name)`)]
# Split into 2 tables
N_COUNTRIES   = nrow(FAO_COUNTRY_LIST)
VECTOR_TABLE1 = 1:ceiling(N_COUNTRIES/2)
FAO_COUNTRY_LIST1 = FAO_COUNTRY_LIST[VECTOR_TABLE1]
VECTOR_TABLE2 = (ceiling(N_COUNTRIES/2)+1):N_COUNTRIES
if (length(VECTOR_TABLE2) < length(VECTOR_TABLE1))
  FAO_COUNTRY_LIST2 = rbind(FAO_COUNTRY_LIST[VECTOR_TABLE2], data.table(`Country (Name)` = NA, `Country (ISO3 code)` = NA)) else
    FAO_COUNTRY_LIST2 = FAO_COUNTRY_LIST[VECTOR_TABLE2]

FAO_COUNTRY_LIST_2_COLUMNS = cbind(FAO_COUNTRY_LIST1, FAO_COUNTRY_LIST2)

names(FAO_COUNTRY_LIST_2_COLUMNS)[3] = "Country (Name) (suite)"
names(FAO_COUNTRY_LIST_2_COLUMNS)[4] = "Country (ISO3 code) (suite)"

# Prepare table for inclusion in docx
FAO_COUNTRY_LIST_FT =
  FAO_COUNTRY_LIST_2_COLUMNS %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  vline(j = c(2), border = fp_border(width = 2)) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

# FAO species list
FAO_SPECIES_LIST = unique(FAO_RAW[, .(`ASFIS species (Name)`, `ASFIS species (3-alpha code)`)])

# Prepare table for inclusion in docx
FAO_SPECIES_LIST_FT =
  FAO_SPECIES_LIST %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  vline(j = c(2), border = fp_border(width = 2)) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

# CONSOLIDATE ####

# Reformat the areas
FAO_TABLE[FISHING_GROUND == "Indian Ocean, Eastern", FISHING_GROUND := "Eastern Indian Ocean"]
FAO_TABLE[FISHING_GROUND == "Indian Ocean, Western", FISHING_GROUND := "Western Indian Ocean"]

# Create fleet code from country code
FAO_TABLE[, FLEET_CODE := COUNTRY_CODE]
FAO_TABLE[FLEET_CODE ==  "ESP", FLEET_CODE := "EUESP"]
FAO_TABLE[FLEET_CODE ==  "FRA", FLEET_CODE := "EUFRA"]
FAO_TABLE[FLEET_CODE ==  "GBR", FLEET_CODE := "EUGBR"]
FAO_TABLE[FLEET_CODE ==  "PRT", FLEET_CODE := "EUPRT"]
FAO_TABLE[FLEET_CODE ==  "ITA", FLEET_CODE := "EUITA"]
FAO_TABLE[FLEET_CODE ==  "MYT", FLEET_CODE := "EUMYT"]
FAO_TABLE[FLEET_CODE ==  "REU", FLEET_CODE := "EUREU"]
FAO_TABLE[FLEET_CODE ==  "BGR", FLEET_CODE := "EUBGR"]
FAO_TABLE[FLEET_CODE ==  "DEU", FLEET_CODE := "EUDEU"]
FAO_TABLE[FLEET_CODE ==  "IOT", FLEET_CODE := "GBRT"]
FAO_TABLE[FLEET_CODE ==  "EAZ", FLEET_CODE := "TZA"]  # Zanzibar assigned to TZA
FAO_TABLE[FLEET_CODE %in% c("GEO", "LTU", "ROU", "RUS", "UKR"), FLEET_CODE := "SUN"]

FAO_TABLE[COUNTRY == "Other nei", FLEET_CODE := "NEI"]
FAO_TABLE[COUNTRY == "Sudan (former)", FLEET_CODE := "SDN"]

# Combine BLT and FRI into FRZ
FAO_TABLE[SPECIES_CODE %in% c("FRI", "BLT"), `:=` (SPECIES_CODE = "FRZ", SPECIES = "Frigate and bullet tunas")]

# Combine COM and GUT into KGX
FAO_TABLE[SPECIES_CODE %in% c("COM", "GUT"), `:=` (SPECIES_CODE = "KGX", SPECIES = "Seerfishes nei")]

# Melt the data
NC_FAO = melt.data.table(FAO_TABLE[, -c("COUNTRY", "COUNTRY_CODE")], id.vars = c("FLEET_CODE", "SPECIES", "SPECIES_CODE", "FISHING_GROUND_CODE", "FISHING_GROUND"), variable.name = "YEAR", value.name = "CATCH", na.rm = TRUE, variable.factor = FALSE)[CATCH>0]

# Mapping table for the report
MAPPING_COUNTRY_FLEET = unique(FAO_TABLE[COUNTRY_CODE != FLEET_CODE, .(`Country (Name)` = COUNTRY, `Country (ISO3 code)` = COUNTRY_CODE, `IOTC Fleet code` = FLEET_CODE)])[order(`Country (ISO3 code)`)]

MAPPING_COUNTRY_FLEET_FT = 
  MAPPING_COUNTRY_FLEET %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  vline(j = c(2), border = fp_border(width = 2)) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

