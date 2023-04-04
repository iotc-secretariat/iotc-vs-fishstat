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
  border_inner(border = fp_border(style = "dashed")) %>%
  border_outer(border = fp_border(width = 2)) %>%
  #hline(border = fp_border(width = .8, style = "dashed")) %>%
  #vline(j = c(2), border = fp_border(width = 2)) %>%
  autofit()

