print("Extracting taxonomic information for tuna and tuna-like species...")

# ASFIS ####
ASFIS_TUNAS_RAW = fread("../inputs/data/ASFIS_sp_2022.txt", encoding = "UTF-8")[, .(ISSCAAP, SPECIES_CODE = `3A_CODE`, SPECIES_NAME = English_name, SPECIES_SCIENTIFIC = Scientific_name)][ISSCAAP == 36]

## CORRECTIONS
# SAI: Istiophorus albicans -> Istiophorus platypterus
# FNY: Makaira mazara -> Makaira nigricans
# BXQ: Makaira spp. -> Should be converted to Xiphioidei (Istiophoridae AND Xiphiidae) or Istiophoridae BIL (Istiophoridae only) = As SWO is easy to identify = I suppose BXQ should be converted to BIL
# FRZ: Auxis thazard, A. rochei -> Scientific name should read Auxis spp.

ASFIS_TUNAS = ASFIS_TUNAS_RAW[!SPECIES_CODE %in% c("SAI", "FNY", "BXQ")]
ASFIS_TUNAS[SPECIES_CODE == "FRZ", SPECIES_SCIENTIFIC := "Auxis spp"]

# Add information on species aggregate
ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Sarda spp", "Scomberomorus spp", "Auxis spp", "Euthynnus spp", "Thunnus spp", "Thunnini", "Istiophoridae", "Scombroidei", "Tetrapturus spp"), IS_AGGREGATE := TRUE]

ASFIS_TUNAS[is.na(IS_AGGREGATE), IS_AGGREGATE := FALSE]

# Get TSN for non-aggregate species
# Note there might be several TSN in the case of sub-species (BEP, FRI, BLT, BFT, LOT, YFT)
# The smallest TSN corresponds to the main species
ASFIS_TUNAS[IS_AGGREGATE == FALSE, TSN := min(as.numeric(search_scientific(SPECIES_SCIENTIFIC)$tsn)), by = .(SPECIES_SCIENTIFIC)]

# Add TSN for species aggregates
ASFIS_TUNAS[SPECIES_CODE == "BZX", TSN := 172407]
ASFIS_TUNAS[SPECIES_CODE == "KGX", TSN := 172434]
ASFIS_TUNAS[SPECIES_CODE == "EHZ", TSN := 172399]
ASFIS_TUNAS[SPECIES_CODE == "TUS", TSN := 172418]
ASFIS_TUNAS[SPECIES_CODE == "TUN", TSN := 638252]
ASFIS_TUNAS[SPECIES_CODE == "FRZ", TSN := 172454]  #change SPECIES_SCIENTIFIC to "Auxis"
ASFIS_TUNAS[SPECIES_CODE == "BIL", TSN := 172486]
ASFIS_TUNAS[SPECIES_CODE == "TUX", TSN := 172353]
ASFIS_TUNAS[SPECIES_CODE == "WHH", TSN := 172498]

# ISSUE WITH BXQ: no TSN available

# Add information on taxonomy
ASFIS_TUNAS[!is.na(TSN), SUBORDER := data.table(hierarchy_full(TSN))[rankname == "Suborder", parentname], by = .(SPECIES_SCIENTIFIC)]

# $ distinct families for TUX
ASFIS_TUNAS[!is.na(TSN) & SPECIES_CODE != "TUX", FAMILY := data.table(hierarchy_full(TSN))[rankname == "Family", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN), SUBFAMILY := data.table(hierarchy_full(TSN))[rankname == "Subfamily", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN), TRIBE := data.table(hierarchy_full(TSN))[rankname == "Tribe", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN) & IS_AGGREGATE == FALSE, GENUS := data.table(hierarchy_full(TSN))[rankname == "Genus", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN) & IS_AGGREGATE == FALSE, SPECIES := data.table(hierarchy_full(TSN))[rankname == "Species", parentname], by = .(SPECIES_SCIENTIFIC)]

print("Taxonomic information on tuna and tuna-like species extracted!")
