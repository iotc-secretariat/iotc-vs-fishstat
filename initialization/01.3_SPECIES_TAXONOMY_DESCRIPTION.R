# Classification
#TUNA_CLASSIFICATION = classification(ASFIS_TUNAS[IS_AGGREGATE == FALSE, TSN], db = "itis")
#toto = class2tree(TUNA_CLASSIFICATION)
#plot(toto)

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

