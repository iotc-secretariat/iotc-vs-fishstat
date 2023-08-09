library(data.table)
library(ritis)
library(worrms)

EXAMPLE = data.table(SPECIES_CODE = "YFT", SPECIES_SCIENTIFIC = "Thunnus albacares", TSN = 172423, APHIAID = 127027)

EXAMPLE[, ORDER_ITIS := data.table(hierarchy_full(TSN))[rankname == "Order", taxonname], by = .(SPECIES_SCIENTIFIC)]

EXAMPLE[, ORDER_WORMS := data.table(wm_classification(APHIAID))[rank == "Order", scientificname], by = .(SPECIES_SCIENTIFIC)]

EXAMPLE[, FAMILY_ITIS := data.table(hierarchy_full(TSN))[rankname == "Family", taxonname], by = .(SPECIES_SCIENTIFIC)]

EXAMPLE[, FAMILY_WORMS := data.table(wm_classification(APHIAID))[rank == "Family", scientificname], by = .(SPECIES_SCIENTIFIC)]
