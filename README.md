# JS_equity_mapping
This repository contains functions for generating vulnerability data using R and visualizing it on a Leaflet interactive web map using JavaScript.  It is a work in progress (in other words, there are likely some bugs) and will be updated reglarly. 

At this point in time, the following R functions are available:

* ```download_USCB_TIGER_files.R```: Function to download necessary files from USCB TIGER website. *Note that if you are using this code from within an organization's firewall, the USCB TIGER website (https://www2.census.gov/geo/tiger) may need to be whitelisted.*
  
* ```generate_map_variables.R```: Function to generate data at the USCB tract level from data sources available via API. This function also generates JS files utilized by Leaflet's legend and layer controls.

* ```generate_USCB_spatial_file.R```: Function to generate tract spatial files in compact topojson format with option to merge to tabular data.

Required packages that must be installed to run this code:

* ```data.table```: for handling large data.frames more efficiently

* ```geos```: for processing large scale geometry collections

* ```sf```: for reading in shapefiles and performing spatial processes

* ```terra```: for reading in and processing raster data

* ```jsonlite```: for processing JSON from the USCB geocoding API

* ```igraph```: for collapsing directional multipart polylines in edges files into single part polylines
          
Here is an R code sample for generating spatial data and supporting files for a Leaflet map of the five boroughs of New York City with custom settings:
```
gh_path <- 'https://raw.githubusercontent.com/gmculp/JS_equity_mapping/refs/heads/main'
source(file.path(gh_path,"R/download_USCB_TIGER_files.R"))
source(file.path(gh_path,"R/generate_map_variables.R"))
source(file.path(gh_path,"R/generate_USCB_spatial_file.R"))

###specify place to store USCB TIGER files###
USCB_TIGER.path <- "C:/map_resources/census_files"

###specify data table containing state and county FIPS codes###
FIPS.dt <- data.table(state=rep("36",5),county=c("061","005","047","081","085"))

###specify vintage of tract geographies (e.g., 2010, 2020)###
geo.year <- "2020"

###automatically download all necessary files from USCB TIGER website###
###you will only have to do this once for each decennial census year###
###for 2020###
download_USCB_TIGER_files(FIPS.dt,USCB_TIGER.path,geo.year)

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
specs <- fromJSON(file.path(gh_path,'R/API_variables.json'), simplifyVector = FALSE)

###you can change the default specs to suit your region either mannually in a text editor...###
###...or programmatically in R###
###remove old energy cost variable###
n1 <- which(sapply(specs$data_sources$CDC, FUN=function(X) X$survey == "BRFSS"))
n2 <- which(sapply(specs$data_sources$CDC[[n1]]$members, FUN=function(X) X$variable_name == "SHUTUTILITY"))
specs$data_sources$CDC[[n1]]$members[[n2]] <- NULL
	
###add new energy cost variable###
n1 <- which(sapply(specs$data_sources$USCB, FUN=function(X) X$survey == "ACS5"))
n2 <- length(specs$data_sources$USCB[[n1]]$members)+1
	
specs$data_sources$USCB[[n1]]$members[[n2]] <- 
list(variable_name="energy_cost", 
	variable_label="Energy Cost",
	title="Percentage of income spent on energy costs",
	group="house_energy",
	variables=lapply(c("B19025_001E", "B25032_001E", "B25032_003E", paste0("B25132_00",4:9,"E"), paste0("B25133_00",4:9,"E"), paste0("B25135_00",4:6,"E")),function(j) j),
	formula="round(((12*((49 * B25132_004E)+(99 * B25132_005E)+(149 * B25132_006E)+(199 * B25132_007E)+(249 * B25132_008E)+(300 * B25132_009E)+(24 * B25133_004E)+(49 * B25133_005E)+(74 * B25133_006E)+(99 * B25133_007E)+(149 * B25133_008E)+(200 * B25133_009E)+(249 * B25135_004E)+(749 * B25135_005E)+(1000 * B25135_006E)))/B19025_001E)*100,2)"
)

###specify place to store files for Leaflet###
output.path <- "C:/map_resources/Leaflet_files/NYC"

###generate table containing variables by tract GEOID and JS files for legend and layer controls###
generate_map_variables(specs, FIPS.dt, USCB_TIGER.path, raster.path, geo.year, output.path, in_clus = 20)

###generate topojson enriched with variable data###
generate_USCB_spatial_file(FIPS.dt, USCB_TIGER.path, geo.year, geo.type="tract", omit.unpopulated=TRUE, omit.artifacts=TRUE, omit.coast=TRUE, output.path, input.file_name=file.path(output.path,"map_variables.txt"), in_clus=20, na_color = specs$NA_color)
