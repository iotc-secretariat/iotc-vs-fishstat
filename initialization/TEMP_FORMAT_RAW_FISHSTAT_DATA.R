# Set working directory
# Source: https://www.fao.org/fishery/static/Data/Capture_2022.1.1.zip
temp = tempfile(tmpdir = "inputs/data/")
download.file("https://www.fao.org/fishery/static/Data/Capture_2022.1.1.zip", temp)
unzip(temp, exdir = "inputs/data/")
unlink(temp)

# Read the catch data
CAPTURE = fread("./inputs/data/Capture_Quantity.csv")

# Read the code lists
CL_COUNTRIES= fread("./inputs/data/CL_FI_COUNTRY_GROUPS.csv", encoding = "UTF-8")
CL_SPECIES = fread("./inputs/data/CL_FI_SPECIES_GROUPS.csv", encoding = "UTF-8")[ISSCAAP_Group_En == "Tunas, bonitos, billfishes", .(`3A_Code`, Name_En, Name_Fr, Scientific_Name)]



