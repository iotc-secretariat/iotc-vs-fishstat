print("Extracting taxonomic information for tuna and tuna-like species...")

# ASFIS ####
ASFIS_TUNAS_RAW = fread("../inputs/data/ASFIS_sp_2022.txt", encoding = "UTF-8")[, .(ISSCAAP, SPECIES_CODE = `3A_CODE`, SPECIES = English_name, SPECIES_SCIENTIFIC = Scientific_name)][ISSCAAP == 36]

## CORRECTIONS
# SAI: Istiophorus albicans -> Istiophorus platypterus
# FNY: Makaira mazara -> Makaira nigricans
# BXQ: Makaira spp. -> Should be converted to Xiphioidei (Istiophoridae AND Xiphiidae) or Istiophoridae BIL (Istiophoridae only) = As SWO is easy to identify = I suppose BXQ should be converted to BIL
# FRZ: Auxis thazard, A. rochei -> Scientific name should read Auxis spp.

ASFIS_TUNAS = ASFIS_TUNAS_RAW[!SPECIES_CODE %in% c("SAI", "FNY", "BXQ")]
ASFIS_TUNAS[SPECIES_CODE == "FRZ", SPECIES_SCIENTIFIC := "Auxis spp"]

# Add information on species aggregate
ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Sarda spp", "Scomberomorus spp", "Auxis spp", "Euthynnus spp", "Thunnus spp", "Thunnini", "Istiophoridae", "Scombroidei", "Tetrapturus spp"), IS_SPECIES_AGGREGATE := TRUE]

ASFIS_TUNAS[is.na(IS_SPECIES_AGGREGATE), IS_SPECIES_AGGREGATE := FALSE]

# Get TSN for non-aggregate species
# Note there might be several TSN in the case of sub-species (BEP, FRI, BLT, BFT, LOT, YFT)
# The smallest TSN corresponds to the main species
ASFIS_TUNAS[IS_SPECIES_AGGREGATE == FALSE, TSN := min(as.numeric(search_scientific(SPECIES_SCIENTIFIC)$tsn)), by = .(SPECIES_SCIENTIFIC)]

# Add TSN for species aggregates
# No TSN available for BXQ
ASFIS_TUNAS[SPECIES_CODE == "BZX", TSN := 172407]
ASFIS_TUNAS[SPECIES_CODE == "KGX", TSN := 172434]
ASFIS_TUNAS[SPECIES_CODE == "EHZ", TSN := 172399]
ASFIS_TUNAS[SPECIES_CODE == "TUS", TSN := 172418]
ASFIS_TUNAS[SPECIES_CODE == "TUN", TSN := 638252]
ASFIS_TUNAS[SPECIES_CODE == "FRZ", TSN := 172454]
ASFIS_TUNAS[SPECIES_CODE == "BIL", TSN := 172486]
ASFIS_TUNAS[SPECIES_CODE == "TUX", TSN := 172353]
ASFIS_TUNAS[SPECIES_CODE == "WHH", TSN := 172498]

# Add information on taxonomy
ASFIS_TUNAS[, SUBORDER := data.table(hierarchy_full(TSN))[rankname == "Suborder", taxonname], by = .(SPECIES_SCIENTIFIC)]

# 4 distinct families for TUX
ASFIS_TUNAS[SPECIES_CODE != "TUX", FAMILY := data.table(hierarchy_full(TSN))[rankname == "Family", taxonname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[, SUBFAMILY := data.table(hierarchy_full(TSN))[rankname == "Subfamily", taxonname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[, TRIBE := data.table(hierarchy_full(TSN))[rankname == "Tribe", taxonname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[IS_SPECIES_AGGREGATE == FALSE, GENUS := data.table(hierarchy_full(TSN))[rankname == "Genus", taxonname], by = .(SPECIES_SCIENTIFIC)]

# Add categories
ASFIS_TUNAS[TRIBE == "Scomberomorini", `:=` (SPECIES_CATEGORY_CODE = "SEERFISH", SPECIES_CATEGORY = "Seerfish species")]

ASFIS_TUNAS[TRIBE == "Sardini", `:=` (SPECIES_CATEGORY_CODE = "BONITOS", SPECIES_CATEGORY = "Bonito species")]

ASFIS_TUNAS[FAMILY %in% c("Istiophoridae", "Xiphiidae"), `:=` (SPECIES_CATEGORY_CODE = "BILLFISH", SPECIES_CATEGORY = "Billfish species")]

ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Thunnus albacares", "Thunnus obesus", "Katsuwonus pelamis"), `:=` (SPECIES_CATEGORY_CODE = "TROPICAL", SPECIES_CATEGORY = "Tropical tuna species")]

ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Thunnus alalunga", "Thunnus orientalis", "Thunnus thynnus", "Thunnus maccoyii", "Allothunnus fallai"), `:=` (SPECIES_CATEGORY_CODE = "TEMPERATE", SPECIES_CATEGORY = "Temperate tuna species")]

ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Auxis thazard", "Auxis rochei", "Auxis spp", "Euthynnus alletteratus", "Euthynnus lineatus", "Euthynnus affinis", "Euthynnus spp", "Thunnus tonggol", "Thunnus atlanticus"), `:=` (SPECIES_CATEGORY_CODE = "NERITIC", SPECIES_CATEGORY = "Neritic tuna species")]

ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Thunnus spp", "Thunnini"), `:=` (SPECIES_CATEGORY_CODE = "TUNAS_NEI", SPECIES_CATEGORY = "Tuna species NEI")]

ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Scombroidei", "Gasterochisma melampus"), `:=` (SPECIES_CATEGORY_CODE = "SCOMBROIDEI_NEI", SPECIES_CATEGORY = "Scombroidei species NEI")]


print("Taxonomic information on tuna and tuna-like species extracted!")
