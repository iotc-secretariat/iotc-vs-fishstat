
# Do not consider NEI fleets
NC_FAO_YEAR_FLEET   = NC_FAO [FLEET_CODE != "NEI", .(FAO  = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR = as.integer(YEAR), FLEET_CODE)]
NC_IOTC_YEAR_FLEET  = NC_IOTC[FLEET_CODE != "NEI", .(IOTC = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR, FLEET_CODE, FLEET)]

YEAR_FLEET_CATCH = merge.data.table(NC_FAO_YEAR_FLEET, NC_IOTC_YEAR_FLEET, by = c("YEAR", "FLEET_CODE"), all = TRUE)
YEAR_FLEET_CATCH[, DIFFERENCE := FAO - IOTC]
YEAR_FLEET_CATCH[, DESCRIPTION := factor(fifelse(DIFFERENCE >= 0, "FAO>IOTC", "FAO<IOTC"), levels = c("FAO>IOTC", "FAO<IOTC"))]
setorderv(YEAR_FLEET_CATCH, cols = "DIFFERENCE")

# FOCUS ON FLEETS WITH MAJOR DIFFERENCES ####

#DIFFERENCE_UPPER_QUARTILE     = quantile(TOTAL_FLEET_CATCH$ABS_DIFFERENCE, 0.8, na.rm = T)
FLEETS_WITH_LARGE_DIFFERENCES = TOTAL_FLEET_CATCH[FLEET_CODE != "NEI" & ABS_DIFFERENCE >= 10000, FLEET_CODE]

YEAR_FLEET_CATCH_COMP_PLOT =
  ggplot(data = YEAR_FLEET_CATCH[FLEET_CODE %in% FLEETS_WITH_LARGE_DIFFERENCES], aes(x = YEAR, y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
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
  facet_wrap(~FLEET_CODE) + #, scales = "free_y"
  theme(strip.text = element_text(size = 10), strip.background = element_rect(fill = "white"))

ggsave("../outputs/charts/YEAR_FLEET_CATCH_COMP_PLOT.png", YEAR_FLEET_CATCH_COMP_PLOT, width = 10, height = 6)

