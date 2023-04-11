print("Merging FAO catch for tuna and tuna-like species with ASFIS extended code list...")

# Filter on tuna and tuna-like species
# All measurements available as Q_tlw - Tonnes - Live weight
FAO_TUNAS_BONITOS_BILLFISH = CAPTURE[ISSCAAP_NAME == "Tunas, bonitos, billfishes"]

# Keep only key information
FAO_TUNAS_BONITOS_BILLFISH = FAO_TUNAS_BONITOS_BILLFISH[, -c("MEASURE", "MEASUREMENT_NAME", "ISSCAAP_NAME", "SPECIES", "SPECIES_SCIENTIFIC")]

# Update names
setnames(FAO_TUNAS_BONITOS_BILLFISH, old = c("SPECIES.ALPHA_3_CODE", "AREA.CODE", "PERIOD", "VALUE"), new = c("SPECIES_CODE", "FISHING_GROUND_CODE", "YEAR", "CATCH"))

# Correct wrong species codes in FAO data
FAO_TUNAS_BONITOS_BILLFISH[SPECIES_CODE == "SAI", SPECIES_CODE := "SFA"]
FAO_TUNAS_BONITOS_BILLFISH[SPECIES_CODE == "FNY", SPECIES_CODE := "BUM"]
FAO_TUNAS_BONITOS_BILLFISH[SPECIES_CODE == "BXQ", SPECIES_CODE := "BIL"]  # BXQ not available in ITIS

# Merge with ASFIS extended
FAO_TUNAS_BONITOS_BILLFISH = merge(FAO_TUNAS_BONITOS_BILLFISH, ASFIS_TUNAS, by.x = "SPECIES_CODE", by.y = "SPECIES_CODE", all.x = TRUE)

# Add oceans
FAO_TUNAS_BONITOS_BILLFISH[grep("Atlantic", FISHING_GROUND), `:=` (OCEAN = "Atlantic ocean", OCEAN_CODE = "AO")]

FAO_TUNAS_BONITOS_BILLFISH[grep("Indian", FISHING_GROUND), `:=` (OCEAN = "Indian ocean", OCEAN_CODE = "IO")]

FAO_TUNAS_BONITOS_BILLFISH[FISHING_GROUND %in% c("Pacific, Northeast", "Pacific, Eastern Central", "Pacific, Southeast"), `:=` (OCEAN = "Eastern Pacific Ocean", OCEAN_CODE = "EPO")]

FAO_TUNAS_BONITOS_BILLFISH[FISHING_GROUND %in% c("Pacific, Northwest", "Pacific, Western Central", "Pacific, Southwest"), `:=` (OCEAN = "Western-Central Pacific Ocean", OCEAN_CODE = "WCPO")]

FAO_TUNAS_BONITOS_BILLFISH[FISHING_GROUND == "Mediterranean and Black Sea", `:=` (OCEAN = "Mediterranean and Black Sea", OCEAN_CODE = "MED-BS")]

print("FAO catch for tuna and tuna-like species merged with ASFIS extended code list!")
