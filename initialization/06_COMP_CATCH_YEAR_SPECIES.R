
# Do not consider NEI fleets
NC_FAO_YEAR_SPECIES   = NC_FAO [FLEET_CODE != "NEI", .(FAO  = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR = as.integer(YEAR), SPECIES_CODE)]
NC_IOTC_YEAR_SPECIES  = NC_IOTC[FLEET_CODE != "NEI", .(IOTC = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR, SPECIES_CODE, SPECIES, SPECIES_CATEGORY_CODE, IS_SPECIES_AGGREGATE)]

YEAR_SPECIES_CATCH = merge(NC_FAO_YEAR_SPECIES, NC_IOTC_YEAR_SPECIES, by = c("YEAR", "SPECIES_CODE"), all = TRUE)
YEAR_SPECIES_CATCH[, DIFFERENCE  := FAO - IOTC]
YEAR_SPECIES_CATCH[, DESCRIPTION := factor(fifelse(DIFFERENCE >= 0, "FAO>IOTC", "FAO<IOTC"), levels = c("FAO>IOTC", "FAO<IOTC"))]
setorderv(YEAR_SPECIES_CATCH, cols = "DIFFERENCE")

# IOTC SPECIES ####

YEAR_SPECIES_CATCH_COMP_PLOT =
  ggplot(data = YEAR_SPECIES_CATCH[SPECIES_CODE %in% TOTAL_SPECIES_CATCH[IS_SPECIES_AGGREGATE == FALSE, SPECIES_CODE]], aes(x = YEAR, y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
  geom_col() +
  scale_color_manual(values = NC_DIFF_COLORS_FILL) +
  scale_fill_manual (values = NC_DIFF_COLORS_OUTLINE) +
  theme_bw() +
  xlab("") +
  ylab("Difference between FAO and IOTC catch (x1,000 t)") +
  theme(axis.text.x = element_text(size = 10),
        axis.title.y = element_text(size = 9.5),
        plot.margin = margin(.2, .3, .1, 0, "cm"),
        legend.position = "bottom", legend.title = element_blank()) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ",")) +
  facet_wrap(~SPECIES_CODE) + #, scales = "free_y"
  theme(strip.text = element_text(size = 10), strip.background = element_rect(fill = "white"))

ggsave("../outputs/charts/YEAR_SPECIES_CATCH_COMP_PLOT.png", YEAR_SPECIES_CATCH_COMP_PLOT, width = 10, height = 6)

# SPECIES AGGREGATES ####

YEAR_SPECIES_AGGREGATES_CATCH_COMP_PLOT =
  ggplot(data = YEAR_SPECIES_CATCH[SPECIES_CODE %in% TOTAL_SPECIES_CATCH[IS_SPECIES_AGGREGATE == TRUE, SPECIES_CODE]], aes(x = YEAR, y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
  geom_col() +
  scale_color_manual(values = NC_DIFF_COLORS_FILL) +
  scale_fill_manual (values = NC_DIFF_COLORS_OUTLINE) +
  theme_bw() +
  xlab("") +
  ylab("Difference between FAO and IOTC catch (x1,000 t)") +
  theme(axis.text.x = element_text(size = 10),
        axis.title.y = element_text(size = 9.5),
        plot.margin = margin(.2, .3, .1, 0, "cm"),
        legend.position = "bottom", legend.title = element_blank()) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ",")) +
  facet_wrap(~SPECIES_CODE) + #, scales = "free_y"
  theme(strip.text = element_text(size = 10), strip.background = element_rect(fill = "white"))

ggsave("../outputs/charts/YEAR_SPECIES_AGGREGATES_CATCH_COMP_PLOT.png", YEAR_SPECIES_AGGREGATES_CATCH_COMP_PLOT, width =  10, height = 6)

