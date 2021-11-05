
# FLEET, AREA, SPECIES
NC_FAO_YEAR_FLEET_AREA_SPECIES   = NC_FAO [FLEET_CODE != "NEI", .(FAO  = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR = as.integer(YEAR), FLEET_CODE, FISHING_GROUND, SPECIES_CODE)]

NC_IOTC_YEAR_FLEET_AREA_SPECIES  = NC_IOTC[FLEET_CODE != "NEI", .(IOTC = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR, FLEET_CODE, FISHING_GROUND, SPECIES_CODE)]

YEAR_FLEET_AREA_SPECIES_CATCH = merge.data.table(NC_FAO_YEAR_FLEET_AREA_SPECIES, NC_IOTC_YEAR_FLEET_AREA_SPECIES, by = c("YEAR", "FLEET_CODE", "FISHING_GROUND", "SPECIES_CODE"), all = TRUE)
YEAR_FLEET_AREA_SPECIES_CATCH[is.na(FAO),  FAO  := 0]
YEAR_FLEET_AREA_SPECIES_CATCH[is.na(IOTC), IOTC := 0]
YEAR_FLEET_AREA_SPECIES_CATCH[, DIFFERENCE := FAO - IOTC]
YEAR_FLEET_AREA_SPECIES_CATCH[, DESCRIPTION := factor(fifelse(DIFFERENCE >= 0, "FAO>IOTC", "FAO<IOTC"), levels = c("FAO>IOTC", "FAO<IOTC"))]
setorderv(YEAR_FLEET_AREA_SPECIES_CATCH, cols = "DIFFERENCE")

YFT_TOT_DIFF_2002_2019 = YEAR_FLEET_AREA_SPECIES_CATCH[YEAR %in% 2012:2019 & SPECIES_CODE == "YFT", .(TOT_DIFF = sum(abs(DIFFERENCE))), keyby = .(FLEET_CODE)][order(TOT_DIFF, decreasing = T)]

SELECTED_FLEETS_FOR_PLOT = YFT_TOT_DIFF_2002_2019[TOT_DIFF>200]

YFT_YEAR_FLEET_COMP_PLOT_SELECTED_FLEETS =
 ggplot(data = YEAR_FLEET_AREA_SPECIES_CATCH[FLEET_CODE %in% SELECTED_FLEETS_FOR_PLOT$FLEET_CODE & YEAR>2011 & SPECIES_CODE == "YFT" & abs(DIFFERENCE)>0], aes(x = YEAR, y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
  geom_col() +
  scale_color_manual(values = NC_DIFF_COLORS_FILL) +
  scale_fill_manual (values = NC_DIFF_COLORS_OUTLINE) +
  theme_bw() +
  xlab("") +
  ylab("Difference between FAO and IOTC catch (x1,000 t)") +
  theme(axis.text.x = element_text(size = 6),
        axis.title.y = element_text(size = 9),
        plot.margin = margin(.2, .3, .1, 0, "cm"),
        legend.position = "bottom", legend.title = element_blank()) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ",")) +
  facet_grid(vars(FISHING_GROUND), vars(FLEET_CODE)) +
  theme(strip.text = element_text(size = 8), strip.background = element_rect(fill = "white"))

ggsave("../outputs/charts/YFT_YEAR_FLEET_COMP_PLOT_SELECTED_FLEETS.png", YFT_YEAR_FLEET_COMP_PLOT_SELECTED_FLEETS, width = 10, height = 4)

# For Jimbo
#write.xlsx(x = YEAR_FLEET_AREA_SPECIES_CATCH[YEAR>2011 & SPECIES_CODE == "YFT" & abs(DIFFERENCE)>0][order(FLEET_CODE, YEAR)],
#           file = "../inputs/data/FISHSTAT_VS_IOTC_YFT_2012_2019_YEAR_FLEET_AREA.xlsx")

