

#########################################################
###determine land cover percentage by USCB geographies###
#########################################################


###disable scientific notation###
options(scipen = 999)
library(sf)
library(terra)    
library(data.table)
library(censusapi)
library(geos)
library(httr)
library(jsonlite)
data.table::setDTthreads(1)



###function to remove unoccupied holes in polygons###
st_remove_holes2 <- function(x, max_area = 0) {

  # Checks
  stopifnot(all(st_is(x, "POLYGON") | st_is(x, "MULTIPOLYGON")))

  # Metadata
  geometry_is_polygon = all(st_is(x, "POLYGON"))
  type_is_sfg = any(class(x) == "sfg")
  type_is_sf = any(class(x) == "sf")

  # Split to 'sfc' + data
  geom = st_geometry(x)
  if(type_is_sf) dat = st_set_geometry(x, NULL)
  
  ptz <- suppressWarnings(st_point_on_surface(st_cast(x, "POLYGON")))
  
  # Remove holes
  for(i in 1:length(geom)) {
    if(st_is(geom[i], "POLYGON")) {
      if(length(geom[i][[1]]) > 1){
          holes = lapply(geom[i][[1]], function(x) {st_polygon(list(x))})[-1]
          tt <- st_intersects(st_sfc(holes, crs = st_crs(x)),ptz)
		  zing <- c(1,lengths(tt))
          geom[i] = st_polygon(geom[i][[1]][which(zing == 1)])
      }
    }
	
    if(st_is(geom[i], "MULTIPOLYGON")) {
      tmp = st_cast(geom[i], "POLYGON")
      for(j in 1:length(tmp)) {
        if(length(tmp[j][[1]]) > 1){
            holes = lapply(tmp[j][[1]], function(x) {st_polygon(list(x))})[-1]
			tt <- st_intersects(st_sfc(holes, crs = st_crs(x)),ptz)
			zing <- c(1,lengths(tt))
			tmp[j] = st_polygon(tmp[j][[1]][which(zing > 0)])
        }
      }
      geom[i] = st_combine(tmp)
    }
  }

  # To POLYGON
  if(geometry_is_polygon) suppressWarnings(geom = st_cast(geom, "POLYGON"))

  # To 'sfg'
  if(type_is_sfg) geom = geom[[1]]

  # To 'sf'
  if(type_is_sf) geom = st_sf(dat, geometry = geom)

  # Return result
  return(geom)

}

###for later: hit WMS servers instead of downloading raster files###
#wms_url <- 'https://www.mrlc.gov/geoserver/mrlc_display/NLCD_2021_Impervious_L48/wms?'
#ginfo <- sf::gdal_utils('info', paste0('WMS:',wms_url), quiet=T)


###user-defined function for legend labels###
class.data <- function(class.vec, rnd=NULL, unit.lab="", sep.str=" - ", sym = 1, comma = FALSE){

	labelz <- c()
	
	if(!(is.null(rnd))) class.vec <- round(class.vec, rnd)
	
	if (comma) class.vec <- formatC(class.vec, format="d", big.mark=",")

	for(idx in 2:length(class.vec)){
		if(sym == 1){
			gt_symbol <- ifelse(idx > 2, ">", "")
			labelz <- c(labelz, paste0(gt_symbol,class.vec[idx-1], unit.lab, sep.str, class.vec[idx],unit.lab))
		 } else {
			gt_symbol <- ifelse(idx < length(class.vec), ">", "")
			labelz <- c(labelz, paste0(class.vec[idx-1], unit.lab, sep.str, gt_symbol,class.vec[idx],unit.lab))
		 }
	}
	
	return(labelz)
}

########################
###process face files###
########################
process_face_files <- function(FIPS.dt, USCB_TIGER.path, geo.year="2020") {

	if(as.character(geo.year)=="2010") {
		f_year <- "2019"
	} else {
		f_year <- "2022"
		geo.year <- '2020'
	}

	face.files <- paste0("tl_",f_year,"_",FIPS.dt$state,FIPS.dt$county,"_faces")

	###check if files are where they should be###
	ff <- list.files(file.path(USCB_TIGER.path,"FACES"))

	if(length(face.files[!face.files %in% ff]) > 0){
		stop("\nThe following files are missing:\n",paste(face.files[!face.files %in% ff],collapse="\n"))
	}

	faces.sf <- rbindlist(lapply(face.files,function(j){
		###read in shapefile###
		temp.sf <- sf::st_read(file.path(USCB_TIGER.path,"FACES",j), j, stringsAsFactors = F, quiet=T)
		return(as.data.table(temp.sf))
	}), use.names=TRUE, fill=TRUE)

	faces.sf <- faces.sf[LWFLAG != 'P']

	if(as.character(geo.year)=="2010") {
		faces.sf[,USCB_tract := paste0(STATEFP10,COUNTYFP10,TRACTCE10)]
		faces.sf[,ZCTA := ZCTA5CE10]
		faces.sf[,PUMA := PUMACE10]
		faces.sf[,cty.chk := paste0(STATEFP10,COUNTYFP10)]
		faces.sf <- faces.sf[BLKGRPCE10 != 0]
	} else {
		faces.sf[,USCB_tract := paste0(STATEFP20,COUNTYFP20,TRACTCE20)]
		faces.sf[,ZCTA := ZCTA5CE20]
		faces.sf[,PUMA := PUMACE20]
		faces.sf[,cty.chk := paste0(STATEFP20,COUNTYFP20)]
		faces.sf <- faces.sf[BLKGRPCE20 != 0]
	}
	
	faces.sf <- faces.sf[cty.chk %in% paste0(FIPS.dt$state,FIPS.dt$county)]

	faces.sf <- st_as_sf(faces.sf[,.(geometry = geos_unary_union(geos_make_collection(as_geos_geometry(geometry)))), by=list(USCB_tract,ZCTA,PUMA)])
	
	faces.sf <- st_cast(faces.sf,"MULTIPOLYGON")
	
	faces.sf <- st_remove_holes2(faces.sf)

	return(faces.sf)

}


calc_perc_from_raster <- function(test.r1, in.sf, my.var_name){

	test.r1 <- crop(test.r1, ext(project(vect(st_as_sfc(st_bbox(in.sf))), crs(test.r1))))

	n.r <- nrow(test.r1)
	n.c <- ncol(test.r1)
	n_n <- 10
	v_r <- c(seq(from=1,by=ceiling(n.r/n_n),length.out=n_n),n.r)
	v_c <- c(seq(from=1,by=ceiling(n.c/n_n),length.out=n_n),n.c)

	in.dt <- as.data.table(expand.grid(1:(length(v_c)-1),1:(length(v_r)-1)))
	in.dt[, c.min := v_c[Var1]]
	in.dt[, c.max := v_c[Var1+1]]
	in.dt[, r.min := v_r[Var2]]
	in.dt[, r.max := v_r[Var2+1]]
	in.dt[,c("Var1","Var2") := NULL]
	in_clus <- 20
	n_r <- nrow(in.dt)
	in.dt[,pc := rep(1:in_clus,each=(ceiling(n_r/in_clus)))[1:n_r]]
	in.dt[,id := .I]


	###run in parallell###
	dt.pts <- data.table::rbindlist(parallel::mclapply(1:in_clus, function(j) {

		return(data.table::rbindlist(lapply(in.dt[pc==j]$id, function(k){
			#k=1; 
			temp.r <- test.r1[(in.dt[id==k]$r.min:in.dt[id==k]$r.max), (in.dt[id==k]$c.min:in.dt[id==k]$c.max), drop=FALSE]
			
			temp.p <- suppressWarnings(st_centroid(st_as_sf(terra::as.polygons(temp.r, aggregate=FALSE, na.rm=FALSE))))
			
			temp.p <- st_transform(temp.p, st_crs(in.sf))
			
			###spatial join cell centroid to USCB geographies###
			sf.sj <- st_intersects(temp.p, in.sf)

			int.zone <- lapply(1:length(sf.sj),function(i){
				ifelse(length(sf.sj[[i]])==0,NA,sf.sj[[i]][[1]])
			})

			temp.p$GEOID <- in.sf$GEOID[unlist(int.zone)]

			return(as.data.table(st_drop_geometry(temp.p)))
			
		}),use.names=TRUE,fill=TRUE))
		
	}, mc.preschedule=FALSE, affinity.list = 1:in_clus),use.names=TRUE,fill=TRUE)

	sz <- as.numeric(cellSize(test.r1, unit = "m")[1])

	dt.pts[,sub.area := (ifelse(Layer_1 > 100,0,Layer_1)/100) * sz]
	dt.pts[,total.area := sz]

	dt.out <- dt.pts[,.(sub.area=sum(sub.area),total.area=sum(total.area)), by=c('GEOID')]
	
	rm(in.dt,test.r1,dt.pts)
	
	dt.out <- dt.out[!is.na(GEOID)]

	dt.out[,var_value := round((sub.area/total.area)*100)]
	
	dt.out[,c('sub.area','total.area') := NULL]
	
	zz <- unique(in.sf$GEOID[!in.sf$GEOID %in% dt.out$GEOID])
	dt.out2 <- data.table(GEOID=zz,var_value=rep(0,length(zz)))
	
	dt.out <- rbindlist(list(dt.out,dt.out2),use.names=TRUE,fill=TRUE)
	
	dt.out[,var_name := my.var_name]

	invisible(gc())

	return(dt.out)

}


generate_NLCD_table <- function(FIPS.dt, raster.path, in.sf){

	###update once WMS services are whitelisted###

	#https://s3-us-west-2.amazonaws.com/mrlc/nlcd_2021_impervious_l48_20230630.zip
	r1 <- terra::rast(file.path(raster.path, "nlcd_2021_impervious_l48_20230630.img"))

	dt.1 <- calc_perc_from_raster(r1, in.sf, "perc_impervious")
	rm(r1)
	
	my_brks <- quantile(dt.1$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
	dt.1[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]

	dt.1[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,2,"%"," - ",1))]
	

	#https://s3-us-west-2.amazonaws.com/mrlc/nlcd_tcc_CONUS_2021_v2021-4.zip
	r2 <- terra::rast(file.path(raster.path, "nlcd_tcc_conus_2021_v2021-4.tif"))

	dt.2 <- calc_perc_from_raster(r2, in.sf, "perc_tree_canopy")
	rm(r2)
	
	my_brks <- quantile(dt.2$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
	dt.2[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]

	dt.2[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,2,"%"," - ",1))]
	
	###flip weight as higher tree canopy indicates less heat vulnerabilty###
	dt.2[,var_weight := abs(as.numeric(var_weight)-6)]
	
	dt.out <- rbindlist(list(dt.1, dt.2), use.names=TRUE, fill=TRUE)

	return(dt.out)
}

generate_EJSCREEN_table <- function(FIPS.dt) {

	base.url <- 'https://services.arcgis.com/cJ9YHowT8TU7DUyn/arcgis/rest/services/EJScreen_StatePctiles_with_AS_CNMI_GU_VI_Tracts/FeatureServer/0'

	#P_D2_PTRAF: Traffic proximity; Count of vehicles (AADT, avg. annual daily traffic) at major roads within 500 meters, divided by distance in meters (not km)
	
	#P_D2_PM25: Particulate Matter 2.5; Annual average PM2.5 levels in air
	
	q2 <- "ID,P_D2_PTRAF,P_D2_PM25"

	epa.dt <- rbindlist(lapply(paste0(FIPS.dt$state,FIPS.dt$county),function(f){

		q <- paste0("ID LIKE '",f,"%'")
		full.url <- paste0(base.url,"/query?where=",q,"&returnGeometry=false&outFields=",q2,"&f=json")

		resp <- content(GET(URLencode(full.url)), as="parsed")

		t.dt <- data.table::rbindlist(lapply(resp$features,function(j){
			k <- lapply(j$attributes, function(z) { z[ length(z) == 0 ] <- NA; z; })
			return(setDT(as.data.frame(k)))
		}),use.names=TRUE,fill=TRUE)
		
		return(t.dt)

	}),use.names=TRUE,fill=TRUE)

	epa.dt <- melt(epa.dt, id = c("ID"), variable.name = "var_name", value.name = "var_value", variable.factor = FALSE)

	setnames(epa.dt,c("ID"),c("GEOID"))

	epa.dt <- epa.dt[!is.na(var_value)]

	###inhalable particles <= 2.5 microns###
	sub.dt1 <- epa.dt[var_name=="P_D2_PM25"]
	my_brks <- quantile(sub.dt1$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	sub.dt1[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	sub.dt1[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,2,"%"," - ",1))]


	###traffic intensity### 
	sub.dt2 <- epa.dt[var_name=="P_D2_PTRAF"]
	my_brks <- quantile(sub.dt2$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	sub.dt2[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	sub.dt2[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(trimws(sprintf("%sM", format(round(my_brks/1000000, 1), dec="."))),NULL,""," - ",1))]

	epa.dt <- rbindlist(list(sub.dt1,sub.dt2), use.names=TRUE, fill=TRUE)
	rm(sub.dt1,sub.dt2)
	
	#epa.dt <- epa.dt[GEOID %in% GEOID.vec]
	
	return(epa.dt)

}

generate_ESRI_REST_table <- function(FIPS.dt, in.sf) {

	#in.sf <- ct.sf
	in.sf$area <- as.numeric(st_area(in.sf))
	in.sf <- st_cast(in.sf,"POLYGON")
	in.sf <- st_make_valid(in.sf)
	in.sf$u.id <- 1:nrow(in.sf)

	#this_crs <- 3857
	this_crs <- 4326

	m <- st_as_sfc(st_bbox(in.sf))
	m <- st_transform(m, this_crs)
	m <- st_bbox(m)

	###generate query parameter string containing spatial extent###
	q <- paste0('{',paste0('"',names(m),'":',round(as.numeric(m),4),collapse=','),',"spatialReference":{"wkid":',this_crs,'}}')

	###Public Safety Power Shutoffs REST service###
	base.url <- "https://services2.arcgis.com/mJaJSax0KPHoCNB6/ArcGIS/rest/services/PROD_PSPS_GDB_WGS84_WebMercator_PSPS_PLANNINGAREA_2021/FeatureServer/0"

	full.url <- paste0(base.url,'/query?where=1=1&geometry=',q,'&geometryType=esriGeometryEnvelope&spatialRel=esriSpatialRelIntersects&outFields=*&returnExceededLimitFeatures=true&f=pgeojson')

	psps.sf <- st_read(URLencode(full.url))
	psps.sf <- st_transform(psps.sf, st_crs(in.sf))

	psps.sf <- st_as_sf(as.data.table(psps.sf)[,.(geometry = geos_unary_union(geos_make_collection(as_geos_geometry(geometry))))])

	psps.sf <- st_cast(psps.sf,"POLYGON")
	psps.sf <- st_make_valid(psps.sf)
	psps.sf$u.id <- 1:nrow(psps.sf)

	sf.sj <- st_intersects(in.sf,psps.sf)

	sj.dt <- rbindlist(lapply(1:length(sf.sj),function(i){
		return(data.table(id.1=rep(i,length(sf.sj[[i]])),id.2=unlist(sf.sj[[i]])))
	}),use.names=TRUE, fill=TRUE)


	###use parallel processing to speed up intersection###
	n.r <- nrow(sj.dt)	
	in_clus <- min(20,n.r)
	sj.dt[,pc := rep(1:in_clus,each=(ceiling(n.r/in_clus)))[1:n.r]]
	sj.dt[,r.id := .I]

	###run in parallell###
	int.dt1 <- data.table::rbindlist(parallel::mclapply(1:in_clus, function(zz) {
		return(data.table::rbindlist(lapply(sj.dt[pc==zz]$r.id, function(yy){
		
			t.dt <- st_collection_extract(st_intersection(in.sf[in.sf$u.id %in% sj.dt[yy]$id.1,],psps.sf[psps.sf$u.id %in% sj.dt[yy]$id.2,]),"POLYGON")
			
			t.dt$int.area <- as.numeric(st_area(t.dt))
			
			return(as.data.table(st_drop_geometry(t.dt)))
			
		}),use.names=TRUE,fill=TRUE))
	}, mc.preschedule=FALSE, affinity.list = 1:in_clus),use.names=TRUE,fill=TRUE)

	invisible(gc())

	int.dt1 <- int.dt1[,.(int.area=sum(int.area)), by=.(GEOID,area)]
	int.dt1[,var_value := round((int.area/area)*100,4)]
	int.dt1[,c("area","int.area") := NULL]
	
	my_brks <- quantile(int.dt1$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)

	int.dt1[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	int.dt1[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,0,"%"," - ",1))]

	int.dt1[,var_name := "psps"]

	#
	##
	###
	##
	#

	###HOLC Red Line neighborhoods###
	base.url <- "https://services.arcgis.com/ak2bo87wLfUpMrt1/ArcGIS/rest/services/MappingInequalityRedliningAreas_231211/FeatureServer/0"

	q2 <- "grade='D'"

	full.url <- paste0(base.url,'/query?where=',q2,'&geometry=',q,'&geometryType=esriGeometryEnvelope&spatialRel=esriSpatialRelIntersects&outFields=*&returnExceededLimitFeatures=true&f=pgeojson')

	RL.sf <- st_read(URLencode(full.url))
	RL.sf <- st_transform(RL.sf, st_crs(in.sf))

	int.dt2 <- st_collection_extract(st_intersection(in.sf[lengths(st_intersects(in.sf,RL.sf)) > 0,],RL.sf),"POLYGON")

	int.dt2$int.area <- as.numeric(st_area(int.dt2))

	int.dt2 <- as.data.table(st_drop_geometry(int.dt2))

	int.dt2 <- int.dt2[,.(int.area=sum(int.area)), by=.(GEOID,area)]
	int.dt2[,var_value := round((int.area/area)*100,0)]

	int.dt2 <- int.dt2[var_value>0]

	my_brks <- quantile(int.dt2$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)

	int.dt2[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	int.dt2[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,0,"%"," - ",1))]

	int.dt2[,var_name := "redline"]

	int.dt2[,c("area","int.area") := NULL]

	###
	###
	###
	
	esri.dt <- rbindlist(list(int.dt1,int.dt2), use.names=TRUE, fill=TRUE)
	rm(int.dt1,int.dt2)
	
	return(esri.dt)
}




generate_environmental_table <- function(FIPS.dt, USCB_TIGER.path, raster.path, geo.year){

	faces.sf <- process_face_files(FIPS.dt, USCB_TIGER.path, geo.year)
	faces.sf$GEOID <- faces.sf$USCB_tract

	ct.sf <- st_as_sf(as.data.table(faces.sf)[,.(geometry = geos_unary_union(geos_make_collection(as_geos_geometry(geometry)))), by=list(GEOID)])

	ct.sf <- st_cast(ct.sf,"MULTIPOLYGON")
	ct.sf <- st_remove_holes2(ct.sf)
	
	t.dt1 <- generate_NLCD_table(FIPS.dt, raster.path, ct.sf)
	t.dt2 <- generate_EJSCREEN_table(FIPS.dt)
	t.dt2 <- t.dt2[GEOID %in% unique(ct.sf$GEOID)]
	t.dt3 <- generate_ESRI_REST_table(FIPS.dt, ct.sf)
	
	env.dt <- rbindlist(list(t.dt1,t.dt2,t.dt3), use.names=TRUE, fill=TRUE)
	
	agg.dt <- copy(env.dt)
	agg.dt[,var_weight := as.numeric(var_weight)]
	agg.dt <- agg.dt[,.(var_value=sum(var_weight)),by=GEOID]
	my_brks <- quantile(agg.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
	agg.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	
	agg.dt <- merge(agg.dt,data.table(var_weight=as.character(1:5),var_legend=c("very low vulnerability","low vulnerability","moderate vulnerability","high vulnerability","very high vulnerability")),by="var_weight",all.x=TRUE)
	
	agg.dt[,var_name := "all_environmental"]
	
	agg.dt <- rbindlist(list(copy(env.dt),agg.dt), use.names=TRUE, fill=TRUE)
	
	agg.dt[,group_name := "environmental"]
	
	setorder(agg.dt,GEOID)
	
	return(agg.dt)
	
}


#
##
###
##
#



calc_ACS_variable_quintile <- function(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula, rnd.digits=0){

	ct.dt <- rbindlist(lapply(1:nrow(FIPS.dt), function(x) as.data.table(getCensus(name = my.survey, vintage = my.vintage, key = mycensuskey, vars = my.vars, region = "tract:*", regionin = paste0("state:",FIPS.dt[x]$state,"+county:",FIPS.dt[x]$county)))))
	
	ct.dt[,GEOID := paste0(state,county,tract)]
	
	for (j in my.vars) set(ct.dt, j = j, value = ifelse(ct.dt[[j]] < 0, NA, ct.dt[[j]]))
	
	ct.dt[,var_value := eval(my.formula)]
	
	my_brks <- quantile(ct.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
	ct.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	ct.dt[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,rnd.digits,"%"," - ",1))]
	ct.dt[,var_name := my.var_name]
	ct.dt[,c("state","county","tract",my.vars) := NULL]
	
	#setnames(ct.dt, c('var_value','var_quintile','var_legend'), paste(my.var_name,c("perc","quintile","legend"),sep='_'))
	
	return(ct.dt)
	
}

generate_agg_table <- function(in.dt,my.group_name){
	agg.dt <- copy(in.dt)
	agg.dt[,var_weight := as.numeric(var_weight)]
	setnafill(agg.dt, fill=0, cols=c("var_weight"))
	agg.dt <- agg.dt[,.(var_value=sum(var_weight)),by=GEOID]
	
	agg.dt0 <- agg.dt[var_value==0]
	agg.dt0[,var_weight := NA]
	agg.dt1 <- agg.dt[var_value>0]
	my_brks <- quantile(agg.dt1$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
	agg.dt1[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	
	agg.dt <- rbindlist(list(agg.dt0,agg.dt1), use.names=TRUE, fill=TRUE)
	
	agg.dt <- merge(agg.dt,data.table(var_weight=as.character(1:5),var_legend=c("very low vulnerability","low vulnerability","moderate vulnerability","high vulnerability","very high vulnerability")),by="var_weight",all.x=TRUE)
	
	agg.dt[,var_name := paste0("all_",my.group_name)]
	
	agg.dt <- rbindlist(list(copy(in.dt),agg.dt), use.names=TRUE, fill=TRUE)
	
	agg.dt[,group_name := my.group_name]
	
	setorder(agg.dt,GEOID)
	return(agg.dt)
}

generate_ACS_table <- function(FIPS.dt){

	
	#
	##
	###
	###########################
	###Health and Disability###
	###########################
	###
	##
	#	
	
	###CDC Behavioral Risk Factor Surveillance System data###
	API.URL <- 'https://data.cdc.gov/resource/cwsq-ngmh.json'

	catz <- c("SHUTUTILITY","CHD","COPD","DIABETES","CANCER","CASTHMA","DISABILITY")

	colz <- c('measureid','year','locationname','data_value_unit','data_value_type','data_value','short_question_text')

	data.dt <- rbindlist(lapply(paste0(FIPS.dt$state,FIPS.dt$county),function(f){
		rbindlist(lapply(catz,function(m){
			my.URL <- paste0(API.URL,"?$select=",paste(unique(colz),collapse=","),"&$where=countyfips='",f,"'&measureid='",m,"'")

			req <- httr::GET(URLencode(my.URL))
			return(rbindlist(httr::content(req),use.names=TRUE,fill=TRUE))

		}),use.names=TRUE,fill=TRUE)
	}),use.names=TRUE,fill=TRUE)


	meta.dt <- unique(data.dt[,c('year','measureid','data_value_unit','data_value_type','short_question_text'),with=FALSE])

	data.dt[,data_value := as.numeric(data_value)]

	data.dt[,c('year','data_value_unit','data_value_type','short_question_text') := NULL]

	setnames(data.dt,c('locationname','measureid','data_value'),c('GEOID','var_name','var_value'))

	health_dis.dt <- rbindlist(lapply(unique(data.dt$var_name),function(j){

		#j <- unique(data.dt$var_name)[1]
		sub.dt <- data.dt[var_name==j]
		
		my_brks <- quantile(sub.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
		
		sub.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
		
		sub.dt[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,1,"%"," - ",1))]


	}),use.names=TRUE, fill=TRUE)
	
	rm(data.dt)
	
	
	###############################
	###determine populated areas###
	###############################
	
	mycensuskey <-"2ca0b2830ae4835905efab6c35f8cd2b3f570a8a"
	my.survey <- "acs/acs5"
	my.vintage <- "2022"
	
	pop.dt <- rbindlist(lapply(1:nrow(FIPS.dt), function(x) as.data.table(getCensus(name = my.survey, vintage = my.vintage, key = mycensuskey, vars = c('B01001_001E','B11001_001E','B09019_026E','B26001_001E','B26101_190E','B26103_007E'),region = "tract:*", regionin = paste0("state:",FIPS.dt[x]$state,"+county:",FIPS.dt[x]$county)))))
	
	pop.dt[,GEOID := paste0(state,county,tract)]
	
	#
	##
	###
	######################
	###Sociodemographic###
	######################
	###
	##
	#
	
	######################################
	###Household with >=65 years of age###
	######################################
	
	#B11007_001E: Estimate!!Total:
	#B11007_002E: Estimate!!Total:!!Households with one or more people 65 years and over:
	
	my.vars <- c('B11007_001E','B11007_002E')
	my.var_name <- 'senior_hh'
	my.formula <- parse(text = "round((B11007_002E/B11007_001E)*100)")
	
	senior_hh.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	#####################################
	###Household with <=6 years of age###
	#####################################
	
	#B25012_001E: Estimate!!Total:
	#B25012_005E: Estimate!!Total:!!Owner-occupied housing units:!!With related children of the householder under 18:!!With own children of the householder under 18:!!Under 6 years only
	#B25012_013E: Estimate!!Total:!!Renter-occupied housing units:!!With related children of the householder under 18:!!With own children of the householder under 18:!!Under 6 years only
	
	my.vars <- c('B25012_001E','B25012_005E','B25012_013E')
	my.var_name <- 'child_hh'
	my.formula <- parse(text = "round(((B25012_005E + B25012_013E)/B25012_001E)*100)")
	
	child_hh.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	#####################
	###People of Color###
	#####################
	
	#B01001_001E = Estimate!!Total: Sex by Age
	#B01001H_001E = Estimate!!Total: Sex by Age (White Alone, Not Hispanic or Latino)
	
	my.vars <- c('B01001_001E','B01001H_001E')
	my.var_name <- 'poc'
	my.formula <- parse(text = "round((1 - (B01001H_001E/B01001_001E))*100)")
	
	poc.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	##########################
	###Linguistic Isolation###
	##########################
	
	#B06007_001E: Estimate!!Total:
	#B06007_005E: Estimate!!Total:!!Speak Spanish:!!Speak English less than "very well"
	#B06007_008E: Estimate!!Total:!!Speak other languages:!!Speak English less than "very well"
	
	my.vars <- c('B06007_001E','B06007_005E','B06007_008E')
	my.var_name <- 'lang'
	my.formula <- parse(text = "round(((B06007_005E + B06007_008E)/B06007_001E)*100)")
	
	lang.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	
	############################
	###Educational Attainment###
	############################
	
	#B06009_001E = Estimate!!Total:
	#B06009_002E = Estimate!!Total:!!Less than high school graduate
	
	my.vars <- c('B06009_001E','B06009_002E')
	my.var_name <- 'low_edu'
	my.formula <- parse(text = "round((B06009_002E/B06009_001E)*100)")
	
	low_edu.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	

	#######################
	###unemployment rate###
	#######################
	
	#B23025_003E: Estimate!!Total:!!In labor force:!!Civilian labor force:
	#B23025_005E: Estimate!!Total:!!In labor force:!!Civilian labor force:!!Unemployed
	
	my.vars <- c('B23025_003E','B23025_005E')
	my.var_name <- 'unemp'
	my.formula <- parse(text = "round((B23025_005E/B23025_003E)*100)")
	
	unemp.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	#############################################################
	###binary: tract median income <= 60% county median income###
	#############################################################
	
	#B06011_001E: Estimate!!Median income in the past 12 months --!!Total:
	
	cty.data <- rbindlist(lapply(1:nrow(FIPS.dt), function(x) as.data.table(getCensus(name = my.survey,
			vintage = my.vintage,
			key = mycensuskey,
			vars = c('B06011_001E'),
			region = paste0("county:",FIPS.dt[x]$county),
			regionin = paste0("state:",FIPS.dt[x]$state)))))
			
		
	med_inc_60.dt <- rbindlist(lapply(1:nrow(FIPS.dt), function(x) as.data.table(getCensus(name = my.survey,
			vintage = my.vintage,
			key = mycensuskey,
			vars = c('B06011_001E'),
			region = "tract:*",
			regionin = paste0("state:",FIPS.dt[x]$state,"+county:",FIPS.dt[x]$county)))))
	
	
	med_inc_60.dt <- merge(med_inc_60.dt,cty.data,by=c('state','county'))
	rm(cty.data)
	
	
	med_inc_60.dt[,var_value := ifelse(B06011_001E.x > 0,round((B06011_001E.x/B06011_001E.y)*100),NA)]
	
	###
	med_inc_60.dt[,var_weight := ifelse(!is.na(var_value) & var_value < 60, 5, ifelse(!is.na(var_value), 1, NA))]
	
	med_inc_60.dt[,var_legend := ifelse(!is.na(var_value) & var_value < 60, "under 60% county-level median income", ifelse(!is.na(var_value), "at least 60% county-level median income", NA))]
	
	med_inc_60.dt[,var_name := 'med_inc_60']
	
	med_inc_60.dt[,GEOID := paste0(state,county,tract)]
	med_inc_60.dt[,c("state","county","tract","B06011_001E.x","B06011_001E.y") := NULL]
	
	
	soc_dem.dt <- rbindlist(list(senior_hh.dt,child_hh.dt,poc.dt,lang.dt,low_edu.dt,unemp.dt,med_inc_60.dt), use.names=TRUE, fill=TRUE)
	
	rm(senior_hh.dt,child_hh.dt,poc.dt,lang.dt,low_edu.dt,unemp.dt,med_inc_60.dt)
	
	
	#
	##
	###
	########################
	###Housing and Energy###
	########################
	###
	##
	#
	
	############################
	###Home built before 1960###
	############################
	
	#B25034_001E: Estimate!!Total:
	#B25034_009E: Estimate!!Total:!!Built 1950 to 1959
	#B25034_010E: Estimate!!Total:!!Built 1940 to 1949
	#B25034_011E: Estimate!!Total:!!Built 1939 or earlier

	my.vars <- c('B25034_001E','B25034_009E','B25034_010E','B25034_011E')
	my.var_name <- 'home_pre_1960'
	my.formula <- parse(text = "round(((B25034_009E + B25034_010E + B25034_011E)/B25034_001E)*100)")
	
	home_pre_1960.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	
	#############################################################################
	###Housing Costs Over 50 Percent of Household Income in the Past 12 Months###
	#############################################################################
	
	#B25140_001E: Estimate!!Total
	#B25140_004E: Estimate!!Total:!!Owned Units with a Mortgage!!Over 50 Percent
	#B25140_008E: Estimate!!Total:!!Owned Units without a Mortgage!!Over 50 Percent
	#B25140_012E: Estimate!!Total:!!Rented!!Over 50 Percent
	
	my.vars <- c('B25140_001E','B25140_004E','B25140_008E','B25140_012E')
	my.var_name <- 'cost_burden_50'
	my.formula <- parse(text = "round(((B25140_004E + B25140_008E + B25140_012E)/B25140_001E)*100)")
	
	cost_burden_50.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	
	################################################
	###percentage of income spent on energy costs###
	################################################
	
	#B25132 = Monthly Electricity Costs
	#B25133 = Monthly Gas Costs
	#B25135 = Annual Other Fuel Costs
	#B19025_001E = Aggregate Household Income in the Past 12 Months

	my.vars <- c("B19025_001E", "B25032_001E", "B25032_003E", paste0("B25132_00",4:9,"E"), paste0("B25133_00",4:9,"E"), paste0("B25135_00",4:6,"E"))

	###min### 
	#my.formula <- parse(text = "round(((12*((1 * B25132_004E)+(50 * B25132_005E)+(100 * B25132_006E)+(150 * B25132_007E)+(200 * B25132_008E)+(250 * B25132_009E)+(1 * B25133_004E)+(25 * B25133_005E)+(50 * B25133_006E)+(75 * B25133_007E)+(100 * B25133_008E)+(150 * B25133_009E)+(1 * B25135_004E)+(250 * B25135_005E)+(750 * B25135_006E)))/B19025_001E)*100,2)")
	
	#my.var_name <- 'energy_cost'
	#energy_cost.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula, rnd.digits=2)
	
	
	###max### 
	my.formula <- parse(text = "round(((12*((49 * B25132_004E)+(99 * B25132_005E)+(149 * B25132_006E)+(199 * B25132_007E)+(249 * B25132_008E)+(300 * B25132_009E)+(24 * B25133_004E)+(49 * B25133_005E)+(74 * B25133_006E)+(99 * B25133_007E)+(149 * B25133_008E)+(200 * B25133_009E)+(249 * B25135_004E)+(749 * B25135_005E)+(1000 * B25135_006E)))/B19025_001E)*100,2)")
	
	my.var_name <- 'energy_cost'
	energy_cost.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula,rnd.digits=2)
	
	
	######################################################
	###percentage of households in multi unit dwellings###
	######################################################
	
	#B25032_001E: Estimate!!Total
	#B25032_003E: Estimate!!Total:!!Owner-occupied housing units:!!1, detached
	#B25032_004E: Estimate!!Total:!!Owner-occupied housing units:!!1, attached
	#B25032_014E: Estimate!!Total:!!Renter-occupied housing units:!!1, detached
	#B25032_015E: Estimate!!Total:!!Renter-occupied housing units:!!1, attached
	
	my.vars <- c('B25032_001E','B25032_003E','B25032_004E','B25032_014E','B25032_015E')
	my.var_name <- 'multi_unit'
	my.formula <- parse(text = "round((1.00 - ((B25032_003E + B25032_004E + B25032_014E + B25032_015E)/B25032_001E))*100)")
	
	multi_unit.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	
	############
	###renter###
	############
	
	#B25032_001E: Estimate!!Total
	#B25032_013E: Estimate!!Total:!!Renter-occupied housing units
	
	my.vars <- c('B25032_001E','B25032_013E')
	my.var_name <- 'renter'
	my.formula <- parse(text = "round((B25032_013E/B25032_001E)*100)")
	
	renter.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	
	####################################################################
	###single head of household living with own children or relatives###
	####################################################################
	
	#B11012_001E: Estimate!!Total:
	#B11012_010E: Estimate!!Total:!!Female householder, no spouse or partner present:!!With children of the householder under 18 years
	#B11012_011E: Estimate!!Total:!!Female householder, no spouse or partner present:!!With relatives, no children of the householder under 18 years
	#B11012_015E: Estimate!!Total:!!Male householder, no spouse or partner present:!!With children of the householder under 18 years
	#B11012_016E: Estimate!!Total:!!Male householder, no spouse or partner present:!!With relatives, no children of the householder under 18 years
	
	my.vars <- c('B11012_001E','B11012_010E','B11012_011E','B11012_015E','B11012_016E')
	my.var_name <- 'single_hohh_dep'
	my.formula <- parse(text = "round(((B11012_010E + B11012_011E + B11012_015E + B11012_016E)/B11012_001E)*100)")
	
	single_hohh_dep.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	
	####################################
	###Crowding: persons per room > 1###
	####################################
	
	#B25014_001E: Estimate!!Total: Tenure by Occupants per Room
	#B25014_003E: Estimate!!Total:!!Owner occupied:!!0.50 or less occupants per room
	#B25014_004E: Estimate!!Total:!!Owner occupied:!!0.51 to 1.00 occupants per room
	#B25014_009E: Estimate!!Total:!!Renter occupied:!!0.50 or less occupants per room
	#B25014_010E: Estimate!!Total:!!Renter occupied:!!0.51 to 1.00 occupants per room
	
	my.vars <- c('B25014_001E','B25014_003E','B25014_004E','B25014_009E','B25014_010E')
	my.var_name <- 'crowd'
	my.formula <- parse(text = "round((1 - ((B25014_003E + B25014_004E + B25014_009E + B25014_010E)/B25014_001E))*100)")
	
	crowd.dt <- calc_ACS_variable_quintile(FIPS.dt, mycensuskey, my.survey, my.vintage, my.vars, my.var_name, my.formula)
	
	#
	##
	###
	##
	#
	
	house_energy.dt <- rbindlist(list(home_pre_1960.dt,cost_burden_50.dt,energy_cost.dt,multi_unit.dt,renter.dt,single_hohh_dep.dt,crowd.dt), use.names=TRUE, fill=TRUE)
	
	rm(home_pre_1960.dt,cost_burden_50.dt,energy_cost.dt,multi_unit.dt,renter.dt,single_hohh_dep.dt,crowd.dt)
	
	###checks###
	#check.dt <- house_energy.dt[is.na(var_weight),.(tot=.N), by=GEOID]
	#house_energy.dt[GEOID %in% check.dt[tot < max(tot)]$GEOID]
	
	###replace energy cost with 'Utility services shut-off threat in the past 12 months among adults'###
	house_energy.dt <- rbindlist(list(house_energy.dt[var_name!="energy_cost"],health_dis.dt[var_name=="SHUTUTILITY"]), use.names=TRUE, fill=TRUE)

	health_dis.dt <- health_dis.dt[var_name!="SHUTUTILITY"]
	
	
	###
	###
	###	
	
	zz.1 <- generate_agg_table(soc_dem.dt,"soc_dem")
	zz.2 <- generate_agg_table(house_energy.dt,"house_energy")
	zz.3 <- generate_agg_table(health_dis.dt,"health_dis")
	
	
	out.dt <- rbindlist(list(zz.1,zz.2,zz.3), use.names=TRUE, fill=TRUE)
	
	return(out.dt[!GEOID %in% pop.dt[B01001_001E==0]$GEOID])

}

generate_map_variables <- function(FIPS.dt, USCB_TIGER.path, raster.path, geo.year, export_path){

	dt.1 <- generate_ACS_table(FIPS.dt)
	dt.2 <- generate_environmental_table(FIPS.dt, USCB_TIGER.path, raster.path, geo.year)
	all.dt <- rbindlist(list(dt.1,dt.2[GEOID %in% dt.1$GEOID]),use.names=TRUE,fill=TRUE)
	dt.3 <- generate_agg_table(all.dt[grepl("^all_",var_name)],"all")
	
	
	###transpose and add symbology information###
	out.dt <- unique(rbindlist(list(all.dt,dt.3[var_name=='all_all']),use.names=TRUE,fill=TRUE))
	out.dt[,var_legend := as.character(var_legend)]
	out.dt[,var_name := as.character(var_name)]
	
	
	col.pal <- c("#000052","#3A008C","#7800AB","#BF009F","#FF0080")
	colz.dt <- data.table(var_weight=as.character(1:5),col=col.pal)
	
	#scales::show_col(col.pal,ncol=5)
	
	out.dt <- merge(out.dt,colz.dt,by="var_weight",all.x=TRUE)
	
	out.dt[,col := ifelse(is.na(col),'#33333300',col)]
	
	legend.dt <- unique(out.dt[!is.na(var_weight),c("group_name","var_name","var_weight","var_legend","col")])
	
	setorder(legend.dt, group_name, var_name, var_weight)
	
	out.dt <- dcast(out.dt, GEOID ~ var_name, value.var = "col")
	out.dt <- melt(out.dt, id=c("GEOID"), variable.factor = FALSE)
	out.dt[,value := ifelse(is.na(value),'#33333300',value)]
	out.dt <- dcast(out.dt, GEOID ~ variable, value.var = "value")
	setorder(out.dt,GEOID)
	
	###############################
	###generate legend JSON file###
	###############################
	
	###generate legend JS file###
	
	specs.dt <- data.table(title=c('Households with older adults (age >= 65 years)','Households with young children (age <= 5 years)','People of color','People who speak English less than "very well"','Adults with less than a high school diploma','Unemployed civilian labor force','Tract median income <= 60% county median income','All sociodemographic variables','Home built before 1960','Housing costs > 50% of household income','Households in multi unit dwellings','Renter-occupied housing units','Single head of household living with dependents','Occupants per room > 1 person','Threat of utility services cutoff','All housing and energy variables','Coronary heart disease among adults','Chronic obstructive pulmonary disease among adults','Diagnosed diabetes among adults','Cancer (non-skin) or melanoma among adults','Current asthma among adults','All health and disability variables','Impervious surfaces','Tree canopy','PM 2.5','Traffic proximity','Public safety power shutoff areas','All environmental variables','Redlined areas','All variables','Any disability among adults'),var_name=c("senior_hh","child_hh","poc","lang","low_edu","unemp","med_inc_60","all_soc_dem","home_pre_1960","cost_burden_50","multi_unit","renter","single_hohh_dep","crowd","SHUTUTILITY","all_house_energy","CHD","COPD","DIABETES","CANCER","CASTHMA","all_health_dis","perc_impervious","perc_tree_canopy","P_D2_PM25","P_D2_PTRAF","psps","all_environmental","redline","all_all","DISABILITY"))
	

	json.lists <- lapply(sort(unique(legend.dt$var_name)), function(j){
			t.dt <- legend.dt[var_name==j,]
			setorder(t.dt, var_weight)
			t.dt <- t.dt[,c('var_legend','col'),with=FALSE]
			setnames(t.dt,names(t.dt),c('label','color'))
			return(list(var_name=j, title=specs.dt[var_name==j]$title, contents=t.dt))
		})
		
		

	json.list <- list(legends=json.lists)
	json.obj <- jsonlite::toJSON(json.list, pretty=TRUE, auto_unbox=TRUE)
	json.obj <- paste0("const legend_specs = ",json.obj,";")
	js_file <- file.path(export_path,"legend-config2.js")
	fileConn <- file(js_file)
	writeLines(json.obj, fileConn)
	close(fileConn)
	
	
	###output file###
	fwrite(out.dt, file = file.path(export_path,"map_variables.txt"), row.names=FALSE, append = FALSE, quote = TRUE, nThread=1)
	
}
