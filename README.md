# JS_equity_mapping
This repository contains functions for generating vulnerability data using R and visualizing it on a Leaflet interactive web map using JavaScript.  It is a work in progress (in other words, there are likely some bugs) and will be updated reglarly. 

At this point in time, the following R functions are available:

* ```download_USCB_TIGER_files.R```: Function to download necessary files from USCB TIGER website. *Note that if you are using this code from within an organization's firewall, the USCB TIGER website (https://www2.census.gov/geo/tiger) may need to be whitelisted.*
  
* ```generate_map_variables.R```: Function to generate data at the USCB tract level from data sources available via API.

* ```download_USCB_TIGER_files.R```: Function to generate spatial files in compact topojson format and merge to tabular data.
