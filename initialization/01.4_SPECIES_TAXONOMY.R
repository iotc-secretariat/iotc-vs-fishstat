
# ASFIS ####
ASFIS_TUNAS = fread("../inputs/data/ASFIS_sp_2022.txt", encoding = "UTF-8")[, .(ISSCAAP, SPECIES_CODE = `3A_CODE`, SPECIES = English_name, SPECIES_SCIENTIFIC = Scientific_name, FAMILY = Family, ORDER = Order)][ISSCAAP == 36]

# Add information on species aggregate
ASFIS_TUNAS[SPECIES_SCIENTIFIC %in% c("Sarda spp", "Scomberomorus spp", "Auxis thazard, A. rochei", "Euthynnus spp", "Thunnus spp", "Thunnini", "Makaira spp", "Istiophoridae", "Scombroidei", "Tetrapturus spp"), IS_AGGREGATE := TRUE]

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

ASFIS_TUNAS[!is.na(TSN), FAMILY := data.table(hierarchy_full(TSN))[rankname == "Family", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN), SUBFAMILY := data.table(hierarchy_full(TSN))[rankname == "Subfamily", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN), SUBFAMILY := data.table(hierarchy_full(TSN))[rankname == "Subfamily", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN), TRIBE := data.table(hierarchy_full(TSN))[rankname == "Tribe", parentname], by = .(SPECIES_SCIENTIFIC)]

ASFIS_TUNAS[!is.na(TSN), GENUS := data.table(hierarchy_full(TSN))[rankname == "Genus", parentname], by = .(SPECIES_SCIENTIFIC)]

# Classification
TUNA_CLASSIFICATION = classification(ASFIS_TUNAS[IS_AGGREGATE == FALSE, TSN], db = "itis")

toto = class2tree(TUNA_CLASSIFICATION)
plot(toto)

# http://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning#ggplot2-integration
pipo = 
  toto$distmat %>% hclust %>% as.dendrogram

plot(pipo)

plot(pipo, type = "triangle")

nodePar <- list(lab.cex = 0.6, pch = c(NA, 19), 
                cex = 0.7, col = "blue")

plot(pipo,  xlab = "Height",
     nodePar = nodePar, horiz = TRUE)

plot(pipo,  xlab = "Height", nodePar = nodePar, 
     edgePar = list(col = 2:3, lwd = 2:1))

# Package ape
pipo = toto$distmat %>% hclust
plot(as.phylo(pipo), cex = 0.6, label.offset = 0.5)
plot(as.phylo(pipo), type = "unrooted", cex = 0.6,
     no.margin = TRUE)
plot(as.phylo(pipo), type = "fan")
plot(as.phylo(pipo), type = "radial")

colors = c("red", "blue", "green", "black")
clus4 = cutree(pipo, 4)
plot(as.phylo(pipo), type = "fan", tip.color = colors[clus4],
     label.offset = 1, cex = 0.7)
