print("Describing catch trends of tuna and tuna-like species...")

# TOTAL CATCH BY OCEAN ####
CATCH_ALL_YEAR_OCEAN = FAO_TUNAS_BONITOS_BILLFISH[, .(CATCH = round(sum(CATCH))), keyby = .(YEAR, OCEAN_CODE, OCEAN)]

# Annual cumulative barplot
FAO_BARPLOT_OCEAN = catch_bar(CATCH_ALL_YEAR_OCEAN, fill_by = "OCEAN", colors = COL_OCEAN, trim_labels = FALSE, num_legend_rows = 2) + theme(legend.position = "bottom")

ggsave("../outputs/charts/FAO/FAO_BARPLOT_OCEAN.png", FAO_BARPLOT_OCEAN, width = 8, height = 4.5)

# TOTAL CATCH BY SPECIES CATEGORY ####
CATCH_ALL_YEAR_SPECIES_CATEGORY = FAO_TUNAS_BONITOS_BILLFISH[, .(CATCH = round(sum(CATCH))), keyby = .(YEAR, SPECIES_CATEGORY_CODE, SPECIES_CATEGORY)]

# Factorize to add BONITOS and SCOMBROIDEI_NEI
CATCH_ALL_YEAR_SPECIES_CATEGORY[, SPECIES_CATEGORY_CODE := factor(SPECIES_CATEGORY_CODE, levels = c("BILLFISH", "NERITIC", "SEERFISH", "TEMPERATE", "TROPICAL", "TUNAS_NEI", "BONITOS", "SCOMBROIDEI_NEI"))]

CATCH_ALL_YEAR_SPECIES_CATEGORY[, SPECIES_CATEGORY := factor(SPECIES_CATEGORY, levels = c("Billfish species", "Neritic tuna species", "Seerfish species", "Temperate tuna species", "Tropical tuna species", "Tuna species NEI", "Bonito species", "Scombroidei species NEI"))]

# Annual cumulative barplot
FAO_BARPLOT_SPECIES_CATEGORIES = catch_bar(CATCH_ALL_YEAR_SPECIES_CATEGORY, fill_by = "SPECIES_CATEGORY", colors = COL_SPECIES_CATEGORIES, num_legend_rows = 2) + theme(legend.position = "bottom")

ggsave("../outputs/charts/FAO/FAO_BARPLOT_SPECIES_CATEGORIES.png", FAO_BARPLOT_SPECIES_CATEGORIES, width = 8, height = 4.5)



# TOTAL CATCH FOR NERITIC AND SEERFISH SPECIES ####

CATCH_NERITICS_SEERFISH_YEAR_SPECIES = FAO_TUNAS_BONITOS_BILLFISH[SPECIES_CATEGORY_CODE %in% c("NERITIC", "SERFISH"), .(CATCH = round(sum(CATCH))), keyby = .(YEAR, SPECIES_CATEGORY_CODE, SPECIES_CATEGORY, SPECIES_CODE, SPECIES)]






print("Catch trends of tuna and tuna-like species described!")