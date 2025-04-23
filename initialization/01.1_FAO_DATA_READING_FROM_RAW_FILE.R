# FROM FISHSTAT RAW DATA ####

# Source: https://www.fao.org/fishery/static/Data/Capture_2023.1.1.zip
# Avaiable from here: https://www.fao.org/fishery/statistics-query/en/capture/capture_quantity
if(!file.exists("../inputs/data/Capture_Quantity.csv")){
  temp = tempfile(tmpdir = "../inputs/data/")
  download.file("https://www.fao.org/fishery/static/Data/Capture_2022.1.1.zip", temp)
  unzip(temp, exdir = "../inputs/data/")
  unlink(temp)
}

# Read the catch data
CAPTURE_RAW = fread("../inputs/data/Capture_Quantity.csv")

# Read the code lists
CL_COUNTRIES= fread("../inputs/data/CL_FI_COUNTRY_GROUPS.csv", encoding = "UTF-8")[, .(UN_CODE = UN_Code, COUNTRY_CODE = ISO3_Code, COUNTRY = Name_En)]

CL_SPECIES = fread("../inputs/data/CL_FI_SPECIES_GROUPS.csv", encoding = "UTF-8")[, .(SPECIES_CODE = `3A_Code`, SPECIES = Name_En, SPECIES_SCIENTIFIC = Scientific_Name, ISSCAAP_NAME = ISSCAAP_Group_En)]

CL_AREAS = fread("../inputs/data/CL_FI_WATERAREA_GROUPS.csv")[, .(FISHING_GROUND_CODE = Code, FISHING_GROUND = Name_En)]

CL_UNITS = fread("../inputs/data/FSJ_UNIT.csv")[, .(MEASUREMENT_CODE = Code, MEASUREMENT_NAME = Name_En)]

# Build the full data set with code lists
CAPTURE = CAPTURE_RAW[CL_COUNTRIES, on = c("COUNTRY.UN_CODE" = "UN_CODE"), nomatch = 0][CL_SPECIES, on = c("SPECIES.ALPHA_3_CODE" = "SPECIES_CODE"), nomatch = 0][CL_AREAS, on = c("AREA.CODE" = "FISHING_GROUND_CODE"), nomatch = 0][CL_UNITS, on = c("MEASURE" = "MEASUREMENT_CODE"), nomatch = 0][, COUNTRY.UN_CODE := NULL]


