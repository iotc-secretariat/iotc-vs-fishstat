# color_table(unique_colors(8))

# COLORS FOR OCEANS ####
COL_OCEAN = data.table(OCEAN = c("Atlantic Ocean", "Indian Ocean", "Eastern Pacific Ocean", "Mediterranean and Black Sea", "Western-Central Pacific Ocean"), FILL = pal_jco("default", alpha = 0.6)(5), OUTLINE = darken(pal_jco("default", alpha = 0.6)(5), 0.2))

# COLORS FOR SPECIES CATEGORIES ####
COL_SPECIES_CATEGORIES = species_category_colors_for(FAO_TUNAS_BONITOS_BILLFISH)

COL_SPECIES_CATEGORIES_ADD = data.table(SPECIES_CATEGORY_CODE = c("BONITOS", "SCOMBROIDEI_NEI"), 
                                        FILL = c("#FED439FF", "#8A9197FF"), 
                                        OUTLINE = c("#AE8F02FF", "#5F6368FF") 
)

COL_SPECIES_CATEGORIES = rbindlist(list(COL_SPECIES_CATEGORIES, COL_SPECIES_CATEGORIES_ADD))

# COLORS FOR SPECIES ####

## TROPICALS ####
SPECIES_COL    = data.table(SPECIES = c("BET", "SKJ", "YFT"), FILL = ggsci::pal_simpsons("springfield", alpha = 0.6)(3), OUTLINE = darken(pal_simpsons("springfield", alpha = 0.6)(3), 0.2))

## NERITICS ####
color_table



