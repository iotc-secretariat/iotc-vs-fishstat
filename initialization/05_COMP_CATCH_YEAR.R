
# Do not consider NEI fleets
NC_FAO_TOTAL_YEAR   = NC_FAO [FLEET_CODE != "NEI", .(FAO  = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR = as.integer(YEAR))]
NC_IOTC_TOTAL_YEAR  = NC_IOTC[FLEET_CODE != "NEI", .(IOTC = round(sum(CATCH, na.rm = TRUE))), keyby = .(YEAR)]

TOTAL_YEAR_CATCH = merge(NC_FAO_TOTAL_YEAR, NC_IOTC_TOTAL_YEAR, by = "YEAR", all = TRUE)
TOTAL_YEAR_CATCH[, DIFFERENCE := FAO - IOTC]
TOTAL_YEAR_CATCH[, DESCRIPTION := factor(fifelse(DIFFERENCE >= 0, "FAO>IOTC", "FAO<IOTC"), levels = c("FAO>IOTC", "FAO<IOTC"))]

# Table of catch differences
TOTAL_YEAR_CATCH_FT = 
  TOTAL_YEAR_CATCH[, .(YEAR = as.character(YEAR), FAO, IOTC, DIFFERENCE)] %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  flextable::color(i = ~ DIFFERENCE > 0, j = ~ DIFFERENCE, color = "blue") %>%
  flextable::color(i = ~ DIFFERENCE == 0, j = ~ DIFFERENCE, color = darken("green", amount = 0.3)) %>%
  flextable::color(i = ~ DIFFERENCE < 0, j = ~ DIFFERENCE, color = "red") %>%
  hline(border = fp_border(width = .8, style = "dashed")) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

# Plot of catch differences
TOTAL_YEAR_CATCH_COMP_PLOT =
  ggplot(data = TOTAL_YEAR_CATCH, aes(x = YEAR, y = DIFFERENCE / 1000, fill = DESCRIPTION)) +
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

ggsave("../outputs/charts/TOTAL_YEAR_CATCH_COMP_PLOT.png", TOTAL_YEAR_CATCH_COMP_PLOT, width =  8, height = 4.5)
