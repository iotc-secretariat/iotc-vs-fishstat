# Colors for barplots
NC_DIFF_COLORS_FILL    = c("#374BE5FF", "#FB4A6AFF")
NC_DIFF_COLORS_OUTLINE = c("#273AC0FF", "#D81C4AFF")

# Do not consider NEI fleets
NC_FAO_TOTAL_SPECIES   = NC_FAO [FLEET_CODE != "NEI", .(FAO  = round(sum(CATCH, na.rm = TRUE))), keyby = .(SPECIES_CODE)]
NC_IOTC_TOTAL_SPECIES  = NC_IOTC[FLEET_CODE != "NEI", .(IOTC = round(sum(CATCH, na.rm = TRUE))), keyby = .(SPECIES_CODE, SPECIES, SPECIES_CATEGORY_CODE, IS_SPECIES_AGGREGATE)]

TOTAL_SPECIES_CATCH = merge(NC_FAO_TOTAL_SPECIES, NC_IOTC_TOTAL_SPECIES, by = "SPECIES_CODE", all = TRUE)
TOTAL_SPECIES_CATCH[, DIFFERENCE  := FAO - IOTC]
TOTAL_SPECIES_CATCH[, DESCRIPTION := factor(fifelse(DIFFERENCE >= 0, "FAO>IOTC", "FAO<IOTC"), levels = c("FAO>IOTC", "FAO<IOTC"))]
setorderv(TOTAL_SPECIES_CATCH, cols = "DIFFERENCE")

# Table of catch differences
TOTAL_SPECIES_CATCH_FT = 
  TOTAL_SPECIES_CATCH[, .(PERIOD = "1950-2019", CATEGORY = SPECIES_CATEGORY_CODE, SPECIES_CODE, SPECIES, FAO, IOTC, DIFFERENCE)][order(CATEGORY, SPECIES_CODE)] %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  flextable::color(i = ~ DIFFERENCE > 0, j = ~ DIFFERENCE, color = "blue") %>%
  flextable::color(i = ~ DIFFERENCE == 0, j = ~ DIFFERENCE, color = darken("green", amount = 0.3)) %>%
  flextable::color(i = ~ DIFFERENCE < 0, j = ~ DIFFERENCE, color = "red") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  #hline(i = c(6, 10, 11, 13, 15), border = fp_border(width = 2)) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

# Plot of catch differences
TOTAL_SPECIES_CATCH_COMP_PLOT =
  ggplot(data = TOTAL_SPECIES_CATCH, aes(x = reorder(SPECIES_CODE, -DIFFERENCE), y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
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
  scale_y_continuous(labels = function(x) format(x, big.mark = ","))

ggsave("../outputs/charts/TOTAL_SPECIES_CATCH_COMP_PLOT.png", TOTAL_SPECIES_CATCH_COMP_PLOT, width =  8, height = 4.5)
