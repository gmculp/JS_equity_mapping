# JS_equity_mapping
This repository contains functions for generating vulnerability data using R and visualizing it on a Leaflet interactive web map using JavaScript.  It is a work in progress (in other words, there are likely some bugs) and will be updated reglarly. 

At this point in time, the following R functions are available:

* ```download_USCB_TIGER_files.R```: Function to download necessary files from USCB TIGER website. *Note that if you are using this code from within an organization's firewall, the USCB TIGER website (https://www2.census.gov/geo/tiger) may need to be whitelisted.*
  
* ```generate_map_variables.R```: Function to generate data at the USCB tract level from data sources available via API.

* ```generate_USCB_spatial_file.R```: Function to generate tract spatial files in compact topojson format with option to merge to tabular data.


          
Here is an R code sample for generating spatial data and supporting files for a Leaflet map of the Bay Area:
```
source("R/download_USCB_TIGER_files.R")
source("R/generate_map_variables.R")

###specify place to store USCB TIGER files###
USCB_TIGER.path <- "C:/map_resources/census_files"

###specify data table containing state and county FIPS codes###
FIPS.dt <- data.table(state=rep("36",5),county=c("061","005","047","081","085"))

###automatically download all necessary files from USCB TIGER website###
###you will only have to do this once for each decennial census year###
###for 2020###
download_USCB_TIGER_files(FIPS.dt,USCB_TIGER.path,"2020")

###download NLCD Land Use raster files###
###future upgrade: pull tiles directly from geoserver to omit this step###
raster.path <- "C:/map_resources/rasters"
tmpdir <- tempdir()
f_paths <- c('https://s3-us-west-2.amazonaws.com/mrlc/nlcd_2021_impervious_l48_20230630.zip', https://s3-us-west-2.amazonaws.com/mrlc/nlcd_tcc_CONUS_2021_v2021-4.zip)

for(f_path in f_paths) {
	file <- basename(f_path)
	download.file(f_path, file.path(tmpdir,file))	
	unzip(file.path(tmpdir,file), exdir = raster.path)
}

###load JSON file containing data and map specs###
specs <- fromJSON("R/API_variables.json", simplifyVector = FALSE)

###you can change the default specs to suit your region###

