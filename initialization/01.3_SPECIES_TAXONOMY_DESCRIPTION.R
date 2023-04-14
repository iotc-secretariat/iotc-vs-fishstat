# http://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning#ggplot2-integration

# Classification
TUNA_CLASSIFICATION = taxize::classification(ASFIS_TUNAS[IS_SPECIES_AGGREGATE == FALSE, TSN], db = "itis")

# Computes distance matrix from list of hierarchies
# From vegan::taxa2dist: Indices of taxonomic diversity and distinctness, which are averaged taxonomic distances among species or individuals in the community (vegan)
TUNA_TREE = class2tree(TUNA_CLASSIFICATION)
TUNA_PHYLO = TUNA_TREE$phylo
TUNA_DIST = TUNA_TREE$distmat

NERITIC_CLASSIFICATION = taxize::classification(ASFIS_TUNAS[IS_SPECIES_AGGREGATE == FALSE & SPECIES_CATEGORY_CODE %in% c("NERITIC", "BONITOS", "SEERFISH"), TSN], db = "itis")

NERITIC_TREE = class2tree(NERITIC_CLASSIFICATION)
NERITIC_PHYLO = NERITIC_TREE$phylo
NERITIC_DIST = NERITIC_TREE$distmat

# Converts distance matrix to dendogram
TUNA_DEND = TUNA_DIST %>% hclust %>% as.dendrogram
NERITIC_DEND = NERITIC_DIST %>% hclust %>% as.dendrogram

# Define colours and symbols for segments and labels
nodePar <- list(lab.cex = 0.6, pch = c(NA, 19), cex = 0.7, col = "blue")

plot(TUNA_DEND,  xlab = "Height", nodePar = nodePar, edgePar = list(col = 2:3, lwd = 2:1), horiz = TRUE)

# Package ape
plot(TUNA_PHYLO, type = "unrooted", cex = 0.6, no.margin = TRUE)
plot(TUNA_PHYLO, type = "fan")
plot(TUNA_PHYLO, type = "radial")

colors = c("red", "blue", "green", "black")

N_COL = 4

iotc.core.utils.aes::unique_colors(N_COL)

NumberClasses = cutree(TUNA_PHYLO, N_COL)
NumberClasses = dendextend::cutree(NERITIC_PHYLO, N_COL)

plot(TUNA_PHYLO, tip.color = colors[NumberClasses], label.offset = 1, cex = 0.7)
plot(NERITIC_PHYLO, tip.color = colors[NumberClasses], label.offset = 1, cex = 0.7)
plot(TUNA_PHYLO, type = "fan", tip.color = colors[NumberClasses], label.offset = 1, cex = 0.7)

# Package ggdendro
ggdendrogram(TUNA_DEND, rotate = FALSE) + 
  theme(axis.text.y = element_blank())

# Package dendextend
TUNA_DEND_TEST = 
  TUNA_DEND %>% 
  set("branches_k_color", k=3) %>% set("branches_lwd", 1.2) %>%
  set("labels_colors") %>% 
  set("labels_cex", c(.9, 1.2)) %>% 
  set("leaves_pch", 19) %>% 
  set("leaves_col", c("blue", "red"))

ggd1 = as.ggdend(TUNA_DEND_TEST)
ggplot(ggd1) 






