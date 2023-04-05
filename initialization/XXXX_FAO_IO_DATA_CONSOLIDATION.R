# DATA CONSOLIDATION ####

# Filter on Indian Ocean
NC_FAO_IO = NC_FAO[FISHING_GROUND %in% c("Indian Ocean, Western", "Indian Ocean, Eastern")]

# Create fleet code from country code
NC_FAO[, FLEET_CODE := COUNTRY_CODE]
NC_FAO[FLEET_CODE ==  "ESP", FLEET_CODE := "EUESP"]
NC_FAO[FLEET_CODE ==  "FRA", FLEET_CODE := "EUFRA"]
NC_FAO[FLEET_CODE ==  "GBR", FLEET_CODE := "EUGBR"]
NC_FAO[FLEET_CODE ==  "PRT", FLEET_CODE := "EUPRT"]
NC_FAO[FLEET_CODE ==  "ITA", FLEET_CODE := "EUITA"]
NC_FAO[FLEET_CODE ==  "MYT", FLEET_CODE := "EUMYT"]
NC_FAO[FLEET_CODE ==  "REU", FLEET_CODE := "EUREU"]
NC_FAO[FLEET_CODE ==  "BGR", FLEET_CODE := "EUBGR"]
NC_FAO[FLEET_CODE ==  "DEU", FLEET_CODE := "EUDEU"]
NC_FAO[FLEET_CODE ==  "IOT", FLEET_CODE := "GBRT"]
NC_FAO[FLEET_CODE ==  "EAZ", FLEET_CODE := "TZA"]  # Zanzibar assigned to TZA
NC_FAO[FLEET_CODE %in% c("GEO", "LTU", "ROU", "RUS", "UKR"), FLEET_CODE := "SUN"]

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

