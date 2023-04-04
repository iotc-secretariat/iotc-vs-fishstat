# FAO country list
FAO_COUNTRY_LIST = unique(FAO_RAW[, .(`Country (Name)`, `Country (ISO3 code)`)])[order(`Country (Name)`)]

# Split into 2 tables
N_COUNTRIES   = nrow(FAO_COUNTRY_LIST)
VECTOR_TABLE1 = 1:ceiling(N_COUNTRIES/2)
FAO_COUNTRY_LIST1 = FAO_COUNTRY_LIST[VECTOR_TABLE1]
VECTOR_TABLE2 = (ceiling(N_COUNTRIES/2)+1):N_COUNTRIES
if (length(VECTOR_TABLE2) < length(VECTOR_TABLE1))
  FAO_COUNTRY_LIST2 = rbind(FAO_COUNTRY_LIST[VECTOR_TABLE2], data.table(`Country (Name)` = NA, `Country (ISO3 code)` = NA)) else
    FAO_COUNTRY_LIST2 = FAO_COUNTRY_LIST[VECTOR_TABLE2]

FAO_COUNTRY_LIST_2_COLUMNS = cbind(FAO_COUNTRY_LIST1, FAO_COUNTRY_LIST2)

names(FAO_COUNTRY_LIST_2_COLUMNS)[3] = "Country (Name) (suite)"
names(FAO_COUNTRY_LIST_2_COLUMNS)[4] = "Country (ISO3 code) (suite)"

# Prepare table for inclusion in docx
FAO_COUNTRY_LIST_FT =
  FAO_COUNTRY_LIST_2_COLUMNS %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  #hline(border = fp_border(width = .8, style = "dashed")) %>%
  vline(j = c(2), border = fp_border(width = 2)) %>% 
  border_inner(border = fp_border(style = "dashed")) %>%
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

# FAO species list
FAO_SPECIES_LIST = unique(FAO_RAW[, .(`ASFIS species (Name)`, `ASFIS species (3-alpha code)`)])

# Prepare table for inclusion in docx
FAO_SPECIES_LIST_FT =
  FAO_SPECIES_LIST %>%
  flextable() %>%
  fontsize(size = 8, part = "all") %>%
  #hline(border = fp_border(width = .8, style = "dashed")) %>%
  #vline(j = c(2), border = fp_border(width = 2)) %>%
  border_inner(border = fp_border(style = "dashed")) %>% 
  border_outer(border = fp_border(width = 2)) %>%
  autofit()

