
NC_FAO_TOTAL_FLEET  = NC_FAO [, .(FAO  = round(sum(CATCH, na.rm = TRUE))), keyby = .(FLEET_CODE)]
NC_IOTC_TOTAL_FLEET = NC_IOTC[, .(IOTC = round(sum(CATCH, na.rm = TRUE))), keyby = .(FLEET_CODE, FLEET)]

TOTAL_FLEET_CATCH = merge(NC_FAO_TOTAL_FLEET, NC_IOTC_TOTAL_FLEET, by = "FLEET_CODE", all = TRUE)
TOTAL_FLEET_CATCH[, DIFFERENCE := FAO - IOTC]
TOTAL_FLEET_CATCH[, DESCRIPTION := factor(fifelse(DIFFERENCE >= 0, "FAO>IOTC", "FAO<IOTC"), levels = c("FAO>IOTC", "FAO<IOTC"))]
TOTAL_FLEET_CATCH[, ABS_DIFFERENCE := abs(DIFFERENCE)]
setorderv(TOTAL_FLEET_CATCH, cols = "DIFFERENCE")

# Table of negative catch differences
TOTAL_FLEET_CATCH_NEGATIVE_FT = 
  TOTAL_FLEET_CATCH[DIFFERENCE<0, .(PERIOD = "1950-2019", FLEET_CODE, FLEET, FAO, IOTC, DIFFERENCE)] %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  flextable::color(i = ~ DIFFERENCE > 0, j = ~ DIFFERENCE, color = "blue") %>%
  flextable::color(i = ~ DIFFERENCE == 0, j = ~ DIFFERENCE, color = darken("green", amount = 0.3)) %>%
  flextable::color(i = ~ DIFFERENCE < 0, j = ~ DIFFERENCE, color = "red") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

TOTAL_FLEET_CATCH_POSITIVE_FT = 
  TOTAL_FLEET_CATCH[DIFFERENCE>0, .(PERIOD = "1950-2019", FLEET_CODE, FLEET, FAO, IOTC, DIFFERENCE)][order(-DIFFERENCE)] %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  flextable::color(i = ~ DIFFERENCE > 0, j = ~ DIFFERENCE, color = "blue") %>%
  flextable::color(i = ~ DIFFERENCE == 0, j = ~ DIFFERENCE, color = darken("green", amount = 0.3)) %>%
  flextable::color(i = ~ DIFFERENCE < 0, j = ~ DIFFERENCE, color = "red") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

# Plot of catch differences
TOTAL_FLEET_CATCH_COMP_PLOT =
  ggplot(data = TOTAL_FLEET_CATCH, aes(x = reorder(FLEET_CODE, -DIFFERENCE), y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
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
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggsave("../outputs/charts/TOTAL_FLEET_CATCH_COMP_PLOT.png", TOTAL_FLEET_CATCH_COMP_PLOT, width =  8, height = 4.5)
