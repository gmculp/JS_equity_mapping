

#########################################################
###determine land cover percentage by USCB geographies###
#########################################################


###disable scientific notation###
options(scipen = 999)
library(sf)
library(terra)    
library(data.table)
library(geos)
library(httr)
library(jsonlite)
data.table::setDTthreads(1)


httr::set_config(
	httr::use_proxy(url="healthproxy.health.dohmh.nycnet", port=8080, username=Sys.getenv("sql_user"),password=Sys.getenv("sql_password"))
)

###USCB API key###
mycensuskey <-"2ca0b2830ae4835905efab6c35f8cd2b3f570a8a"

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
		faces.sf[,cty.chk := paste0(STATEFP10,COUNTYFP10)]
		faces.sf <- faces.sf[BLKGRPCE10 != 0]
	} else {
		faces.sf[,USCB_tract := paste0(STATEFP20,COUNTYFP20,TRACTCE20)]
		faces.sf[,cty.chk := paste0(STATEFP20,COUNTYFP20)]
		faces.sf <- faces.sf[BLKGRPCE20 != 0]
	}
	
	faces.sf <- faces.sf[cty.chk %in% paste0(FIPS.dt$state,FIPS.dt$county)]

	faces.sf <- st_as_sf(faces.sf[,.(geometry = geos_unary_union(geos_make_collection(as_geos_geometry(geometry)))), by=list(USCB_tract)])
	
	faces.sf <- st_cast(faces.sf,"MULTIPOLYGON")
	
	faces.sf <- st_remove_holes2(faces.sf)

	return(faces.sf)

}


calc_perc_from_raster <- function(test.r1, in.sf, in_clus = 2){

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
	
	n_r <- nrow(in.dt)
	in.dt[,pc := rep(1:in_clus,each=(ceiling(n_r/in_clus)))[1:n_r]]
	in.dt[,id := .I]

	###run in parallell###
	dt.pts <- data.table::rbindlist(parallel::mclapply(1:in_clus, function(j) {

		test.dt <- data.table::rbindlist(lapply(in.dt[pc==j]$id, function(k) { 
			
			temp.r <- test.r1[(in.dt[id==k]$r.min:in.dt[id==k]$r.max), (in.dt[id==k]$c.min:in.dt[id==k]$c.max), drop=FALSE]
			
			terra::NAflag(temp.r) <- 127
			terra::NAflag(temp.r) <- 0
			
			temp.p <- st_as_sf(terra::as.points(temp.r, na.rm=TRUE))
			
			if(nrow(temp.p) > 0){
				temp.p <- st_transform(temp.p, st_crs(in.sf))
				
				if(nrow(in.sf[lengths(st_intersects(in.sf, temp.p)) > 0,]) > 0){
				
					###spatial join cell centroid to USCB geographies###
					sf.sj <- st_intersects(temp.p, in.sf)

					int.zone <- lapply(1:length(sf.sj),function(i){
						ifelse(length(sf.sj[[i]])==0,NA,sf.sj[[i]][[1]])
					})

					temp.p$GEOID <- in.sf$GEOID[unlist(int.zone)]
					
					temp.p <- as.data.table(st_drop_geometry(temp.p))
					temp.p <- temp.p[!is.na(GEOID)]
					
					if(nrow(temp.p) > 0){
						return(temp.p)
					}
				}
			} 
		}),use.names=TRUE,fill=TRUE)
		
	}, mc.preschedule=FALSE, affinity.list = 1:in_clus),use.names=TRUE,fill=TRUE)
	
	sz <- as.numeric(st_area(st_transform(st_as_sf(terra::as.polygons(test.r1[(1:1), (1:1), drop=FALSE], aggregate=FALSE, na.rm=TRUE)), st_crs(in.sf))))
	in.sf$total.area <- as.numeric(st_area(in.sf))

	dt.pts[,sub.area := (ifelse(Layer_1 > 100,0,Layer_1)/100) * sz]
	
	dt.out <- dt.pts[,.(sub.area=sum(sub.area)), by=c('GEOID')]
	
	dt.out <- merge(dt.out, as.data.table(st_drop_geometry(in.sf))[,c('GEOID',"total.area"),with=FALSE], by='GEOID')
	
	dt.out[,var_value := round((sub.area/total.area)*100,1)]
	
	dt.out[,c('sub.area','total.area') := NULL]
	
	
	if(nrow(in.sf) > nrow(dt.out)){
		zz <- unique(in.sf$GEOID[!in.sf$GEOID %in% dt.out$GEOID])
		dt.out2 <- data.table(GEOID=zz,var_value=rep(0,length(zz)))
		dt.out <- rbindlist(list(dt.out,dt.out2),use.names=TRUE,fill=TRUE)
	}
	
	invisible(gc())
	rm(in.dt,test.r1,dt.pts)
	return(dt.out)

}

###update once WMS services are whitelisted###
generate_MRLC_table <- function(in.sf, spec, raster.path, in_clus = 2){
	
	MRLC.dt <- rbindlist(lapply(spec$MRLC, function(j) {
		
		r <- terra::rast(file.path(raster.path, j$file))
		temp.dt <- rbindlist(lapply(j$members, function(k) {
	
			t.dt <- calc_perc_from_raster(r, in.sf,in_clus)
			t.dt[,var_name := k$variable_name]
			
			my_brks <- quantile(t.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
			t.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
			t.dt[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,2,"%"," - ",1))]
			t.dt[,group_name := k$group]
			
			
	
		}), use.names=TRUE, fill=TRUE)
	}), use.names=TRUE, fill=TRUE)
	
	return(MRLC.dt)
}



generate_EJSCREEN_table <- function(FIPS.dt,spec) {

	pop.dt <- get_USCB(FIPS.dt, "https://api.census.gov/data/2023/acs/acs5", c('B01001_001E'))

	EPA.dt <- rbindlist(lapply(spec$EPA, function(j) {
		URL <- j$URL
		temp.dt <- rbindlist(lapply(j$members, function(k) {
			t.dt <- rbindlist(lapply(paste0(FIPS.dt$state,FIPS.dt$county),function(f){
				q <- paste0("ID LIKE '",f,"%'")
				q2 <- paste0('ID,',k$variable)
				full.url <- paste0(URL,"/query?where=",q,"&returnGeometry=false&outFields=",q2,"&f=json")
				resp <- content(GET(URLencode(full.url)), as="parsed")
				
				return(data.table::rbindlist(lapply(resp$features,function(m){
					k <- lapply(m$attributes, function(z) { z[ length(z) == 0 ] <- NA; z; })
					return(setDT(as.data.frame(k)))
				}),use.names=TRUE,fill=TRUE))
				
			}),use.names=TRUE,fill=TRUE)
				
			t.dt <- melt(t.dt, id = c("ID"), measure.vars = c(k$variable))
			setnames(t.dt,c("ID","variable","value"),c("GEOID","var_name","var_value"))
			t.dt <- t.dt[!is.na(var_value)]
			t.dt <- t.dt[GEOID %in% pop.dt[B01001_001E > 0]$GEOID]
			
			
			my_brks <- quantile(t.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
			t.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
			t.dt[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,2,"%"," - ",1))]
			t.dt[,group_name := k$group]
			
		}),use.names=TRUE,fill=TRUE)		
	}),use.names=TRUE,fill=TRUE)
	
	return(EPA.dt)

}

calc_perc_area <- function(sf1,sf2,in_clus=4) {
	
	sf1$area <- as.numeric(st_area(sf1))
	sf1 <- suppressWarnings(st_cast(sf1,"POLYGON"))
	sf1 <- st_make_valid(sf1)
	sf1$u.id <- 1:nrow(sf1)
	temp.sf <- sf1[lengths(st_intersects(sf1, sf2)) > 0,]
	if (nrow(temp.sf)>0){
		sf.sj <- st_intersects(temp.sf,sf2)
		
		nn <- max(1,min(floor(nrow(temp.sf)/100),in_clus))
		pp <- 1:nrow(temp.sf)
		cc <- as.integer(ceiling(seq(min(pp),max(pp),length.out =(nn+1))))
		
		temp.dt <- rbindlist(parallel::mclapply(1:nn, function(zz) {
			rbindlist(lapply(pp[as.integer(cut(pp,cc,include.lowest=TRUE))==zz], function(j){
				g <- st_collection_extract(st_intersection(x = temp.sf[j,], y = sf2[sf.sj[[j]],]),"POLYGON")
				g$int.area <- as.numeric(st_area(g))
				return(as.data.table(st_drop_geometry(g))[,.(int.area=sum(int.area)),by=c('GEOID','area')])
			}),use.names=TRUE, fill=TRUE)
		}),use.names=TRUE, fill=TRUE)
		
		temp.dt <- temp.dt[,.(int.area=sum(int.area)),by=c('GEOID','area')]
		temp.dt[,var_value := round((int.area/area)*100,4)]
		temp.dt[,c("area","int.area") := NULL]
		
		my_brks <- quantile(temp.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
		
		if (length(my_brks) > length(unique(my_brks))) {
			my_brks <- seq(min(temp.dt$var_value),max(temp.dt$var_value),length.out = 6)
		}

		temp.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
		temp.dt[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,0,"%"," - ",1))]
		return(temp.dt)
	}
}

generate_ESRI_REST_table <- function(in.sf, spec, in_clus=4) {


	###generate geometry query parameter string containing spatial extent###
	m <- st_bbox(st_as_sfc(st_bbox(in.sf)))
	q <- paste0('{',paste0('"',names(m),'":',round(as.numeric(m),4),collapse=','),',"spatialReference":{"wkid":',st_crs(in.sf,parameters=TRUE)$epsg,'}}')


	ESRI.dt <- rbindlist(lapply(spec$ESRI, function(j) {
		
		URL <- j$URL
		temp.dt <- rbindlist(lapply(j$members, function(k) {
			
			full.url <- paste0(URL,'/query?where=',k$formula,'&geometry=',q,'&geometryType=esriGeometryEnvelope&spatialRel=esriSpatialRelIntersects&outFields=*&returnExceededLimitFeatures=true&f=pgeojson')

			c.sf <- st_read(URLencode(full.url))
	
			if (nrow(c.sf) > 0) {
				c.sf <- st_transform(c.sf, st_crs(in.sf))
				c.sf <- st_as_sf(as.data.table(c.sf)[,.(geometry = geos_unary_union(geos_make_collection(as_geos_geometry(geometry))))])
				c.sf <- st_cast(c.sf,"POLYGON")
				c.sf <- st_make_valid(c.sf)
				c.sf <- c.sf[!st_is_empty(c.sf),,drop=FALSE]

				t.dt <- calc_perc_area(in.sf,c.sf,in_clus)
				rm(c.sf)
				
				t.dt[,var_name := k$variable_name]
				t.dt[,group_name := k$group]
				return(t.dt)
			}
		}),use.names=TRUE, fill=TRUE)
	}),use.names=TRUE, fill=TRUE)	

	return(ESRI.dt)
}



get_USCB <- function(FIPS.dt, my.URL, my.vars, my.region="tract"){

	#my.URL="https://api.census.gov/data/2023/acs/acs5", my.vars=c("B06011_001E"), my.region="county"
	
	temp.dt <- rbindlist(lapply(1:nrow(FIPS.dt), function(x) {
		#x <- 1
		if(my.region=="county"){
			my.URL <- paste0(my.URL,'?get=',paste(unique(my.vars),collapse=","),'&for=county:',FIPS.dt[x]$county,'&in=state:',FIPS.dt[x]$state,'&key=',mycensuskey)
		} else {
			my.URL <- paste0(my.URL,'?get=',paste(unique(my.vars),collapse=","),'&for=tract:*','&in=state:',FIPS.dt[x]$state,'+county:',FIPS.dt[x]$county,'&key=',mycensuskey)
		}

		req <- httr::GET(URLencode(my.URL))
		m <- fromJSON(httr::content(req,"text"))
		t.dt <- as.data.table(m[2:nrow(m),,drop=FALSE])
		setnames(t.dt,names(t.dt),m[1,])
		t.dt[, (my.vars) := lapply(.SD, as.numeric), .SDcols = my.vars]	
		
		return(t.dt) 
	}))
	
	if(my.region != "county") temp.dt[,GEOID := paste0(state,county,tract)]
	
	return(temp.dt)
}


calc_USCB_variable_county <- function(FIPS.dt, my.URL, my.var, my.threshold, my.legend_base, my.var_name, my.group_name) {
	cty.data <- get_USCB(FIPS.dt, my.URL, c(my.var), my.region = "county")		
	ct.dt <- get_USCB(FIPS.dt, my.URL, c(my.var))
	ct.dt <- merge(ct.dt,cty.data,by=c('state','county'))
	rm(cty.data)

	v1 <- paste0(my.var,".x")
	v2 <- paste0(my.var,".y")

	ct.dt[,var_value := ifelse(get(v1) > 0,round((get(v1)/get(v2))*100),NA)]

	ct.dt[,var_weight := ifelse(!is.na(var_value) & var_value < my.threshold, 5, ifelse(!is.na(var_value), 1, NA))]
	
	ct.dt[,var_legend := ifelse(!is.na(var_value) & var_value < my.threshold, paste("under",my.legend_base), ifelse(!is.na(var_value), paste("at least",my.legend_base), NA))]
	
	ct.dt[,var_name := my.var_name]
	ct.dt[,group_name := my.group_name]
	ct.dt[,c(v1,v2,"state","county","tract") := NULL]
	return(ct.dt)
}

calc_USCB_variable_quintile <- function(FIPS.dt, my.URL, my.vars, my.var_name, my.formula, my.group_name, rnd.digits=0){

	ct.dt <- get_USCB(FIPS.dt, my.URL, unique(c(my.vars,'B01001_001E')))
	ct.dt <- ct.dt[B01001_001E > 0]
	
	if(!'B01001_001E' %in% my.vars) ct.dt[,B01001_001E := NULL]
	
	###convert dummy variables (which are assigned an arbitrary negative value) to NA###
	for (j in my.vars) set(ct.dt, j = j, value = ifelse(ct.dt[[j]] < 0, NA, ct.dt[[j]]))
	
	ct.dt[,var_value := eval(parse(text = my.formula))]
	
	my_brks <- quantile(ct.dt$var_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
	
	ct.dt[,var_weight := as.character(cut(var_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
	ct.dt[,var_legend := cut(var_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,rnd.digits,"%"," - ",1))]
	ct.dt[,var_name := my.var_name]
	ct.dt[,group_name := my.group_name]
	ct.dt[,c("state","county","tract",my.vars) := NULL]
	
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
	
	#agg.dt <- rbindlist(list(copy(in.dt),agg.dt), use.names=TRUE, fill=TRUE)
	
	#agg.dt[,group_name := my.group_name]
	
	setorder(agg.dt,GEOID)
	return(agg.dt)
}

generate_CDC_table <- function(FIPS.dt,spec){

	###filter for populated areas###
	pop.dt <- get_USCB(FIPS.dt, "https://api.census.gov/data/2023/acs/acs5", c('B01001_001E'))
	 

	###hit CDC API###
	CDC.dt <- rbindlist(lapply(spec$CDC, function(j) {
		URL <- j$URL
		colz <- c('measureid','locationname','data_value')
		temp.dt <- rbindlist(lapply(j$members, function(k) {
			t.dt <- rbindlist(lapply(paste0(FIPS.dt$state,FIPS.dt$county),function(f){
				
				my.URL <- paste0(URL,"?$select=",paste(unique(colz),collapse=","),"&$where=countyfips='",f,"'&measureid='",k$variable,"'")

				req <- httr::GET(URLencode(my.URL))
				return(rbindlist(httr::content(req),use.names=TRUE,fill=TRUE))

			}),use.names=TRUE,fill=TRUE)
			
			t.dt <- t.dt[locationname %in% pop.dt[B01001_001E > 0]$GEOID]
			
			if(nrow(t.dt) > 0) {
				t.dt[,group_name := k$group]
				t.dt[,var_name := k$variable_name]
				t.dt[,data_value := as.numeric(data_value)]
			
				my_brks <- quantile(t.dt$data_value, probs = seq(0, 1, length.out = 6), na.rm=TRUE)
			
				t.dt[,var_weight := as.character(cut(data_value, my_brks, include.lowest=T, right = T, labels = FALSE))]
				t.dt[,var_legend := cut(data_value, my_brks, include.lowest=T, right = T, labels=class.data(my_brks,1,"%"," - ",1))]
				
				t.dt[,measureid := NULL]
			}

		}),use.names=TRUE,fill=TRUE)
			
	}),use.names=TRUE,fill=TRUE)
		
	setnames(CDC.dt,c('locationname','data_value'),c('GEOID','var_value'))
	
	return(CDC.dt)
}
	
generate_USCB_table <- function(FIPS.dt,spec){
	
	###hit USCB API###
	USCB.dt <- rbindlist(lapply(spec$USCB, function(j) {
		URL <- j$URL
		temp.dt <- rbindlist(lapply(j$members, function(k) {
			if('formula' %in% names(k)){
				calc_USCB_variable_quintile(FIPS.dt, URL, my.vars=unlist(k$variables), my.var_name=k$variable_name, my.formula=k$formula,my.group_name=k$group)
			} else if('county_threshold' %in% names(k)){
				calc_USCB_variable_county(FIPS.dt, URL, my.var=k$variable, my.threshold=k$county_threshold, my.legend_base=k$legend_base, my.var_name=k$variable_name, my.group_name=k$group) 
			}
		}),use.names=TRUE,fill=TRUE)
	}),use.names=TRUE,fill=TRUE)
	
	return(USCB.dt)
}


generate_map_variables <- function(specs, FIPS.dt, USCB_TIGER.path, raster.path, geo.year, output.path, in_clus = 2) {

	if(!dir.exists(output.path)){
		stop("\nOutput file path does not exist. File will not be saved.\n")
	} 

	
	###generate shapefile for variable calculations that incolve spatial joins###
	faces.sf <- process_face_files(FIPS.dt, USCB_TIGER.path, geo.year)
	faces.sf$GEOID <- faces.sf$USCB_tract

	ct.sf <- st_as_sf(as.data.table(faces.sf)[,.(geometry = geos_unary_union(geos_make_collection(as_geos_geometry(geometry)))), by=list(GEOID)])

	ct.sf <- st_cast(ct.sf,"MULTIPOLYGON")
	ct.sf <- st_remove_holes2(ct.sf)
	
	###limit to populated areas###
	pop.dt <- get_USCB(FIPS.dt, "https://api.census.gov/data/2023/acs/acs5", c('B01001_001E'))
	
	ct.sf <- merge(ct.sf, pop.dt[,c('GEOID','B01001_001E'),with=FALSE], by='GEOID', all.x=TRUE)

	in.sf <- ct.sf[ct.sf$GEOID %in% pop.dt[B01001_001E > 0]$GEOID,]
	
	###transform in projected coordinate system###
	in.sf <- sf::st_transform(in.sf, 3857)
	
	my.list <- list()
	if("CDC" %in% names(specs$data_sources)) my.list <- c(list(generate_CDC_table(FIPS.dt,specs$data_sources)), my.list)
	if("USCB" %in% names(specs$data_sources)) my.list <- c(list(generate_USCB_table(FIPS.dt,specs$data_sources)), my.list)
	if("ESRI" %in% names(specs$data_sources)) my.list <- c(list(generate_ESRI_REST_table(in.sf, specs$data_sources, in_clus)), my.list)
	if("EPA" %in% names(specs$data_sources)) my.list <- c(list(generate_EJSCREEN_table(FIPS.dt,specs$data_sources)), my.list)
	if("MRLC" %in% names(specs$data_sources)) my.list <- c(list(generate_MRLC_table(in.sf, specs$data_sources, raster.path, in_clus)), my.list)
	
	out.dt0 <- rbindlist(my.list,use.names=TRUE,fill=TRUE)
	
	#
	##
	###flip weight if specified by specs order object###
	member_recursion <- function(k) {
		lapply(k,function(j){
			if("members" %in% names(j)) {
				lapply(j$members,function(m){
					if("order" %in% names(m)) {
						if(m$order == 'desc'){
							return(m$variable_name)
						}
					}	
				})
			} else{
				member_recursion(j)
			}
		})
	}
	
	flip_vars <- unlist(member_recursion(specs$data_sources), use.names = FALSE)
	
	out.dt0[,var_weight := ifelse(var_name %in% flip_vars,as.character(abs(as.integer(var_weight)-6)),var_weight)]
	###
	##
	#
	
	out.dt1 <- rbindlist(lapply(unique(out.dt0$group_name), function(j) {
		generate_agg_table(out.dt0[group_name==j],j)
	}),use.names=TRUE,fill=TRUE)
	
	out.dt0[, group_name := NULL]
	
	out.dt2 <- generate_agg_table(out.dt1[grepl("^all_",var_name)],"all")
	
	out.dt <- rbindlist(list(out.dt0,out.dt1,out.dt2),use.names=TRUE,fill=TRUE)
	
	out.dt[,var_legend := as.character(var_legend)]
	out.dt[,var_name := as.character(var_name)]
	out.dt <- out.dt[GEOID %in% in.sf$GEOID]
	rm(out.dt0,out.dt1,out.dt2)


	###add symbology information###
	col.pal <- unlist(specs$color_palette)
	na_col <- specs$NA_color
	
	colz.dt <- data.table(var_weight=as.character(1:length(col.pal)),col=col.pal)
	
	#scales::show_col(col.pal,ncol=5)
	
	out.dt <- merge(out.dt,colz.dt,by="var_weight",all.x=TRUE)
	
	out.dt[,col := ifelse(is.na(col),na_col,col)]
	
	setorder(out.dt,GEOID,var_name)
	
	
	#############################
	###generate legend objects###
	#############################
	
	###get info from specs object###
	i.dt1 <- data.table(var_name=specs$group_info$variable_name,var_label=specs$group_info$variable_label,legend_title=specs$group_info$title)
	
	i.dt2 <- rbindlist(lapply(specs$group_info$groups, function(j) {
		data.table(var_name=j$variable_name,var_label=j$variable_label,legend_title=j$title,parent=specs$group_info$variable_name)
	}),use.names=TRUE,fill=TRUE)
	
	s.dt3 <- rbindlist(lapply(names(specs$data_sources), function(j) {
		rbindlist(lapply(specs$data_sources[[j]], function(k) {
			rbindlist(lapply(k$members, function(m) {
				data.table(source=j,survey=k$survey,vintage=k$vintage,var_name=m$variable_name,group_name=m$group,var_label=m$variable_label,legend_title=m$title,parent=paste0("all_",m$group))
			}),use.names=TRUE,fill=TRUE)	
		}),use.names=TRUE,fill=TRUE)
	}),use.names=TRUE,fill=TRUE)
	
	s.dt3[,data_source := paste(vintage,ifelse(source=='ESRI','',source),survey)]
	s.dt3[,data_source :=trimws(gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", data_source, perl=TRUE))]
	
	s.dt2 <- s.dt3[,.(tot=.N),by=c("group_name","data_source")]
	setorder(s.dt2,-tot,data_source)
	s.dt2 <- s.dt2[, .(data_source = paste(data_source,collapse=", ")), by = list(group_name)]
	s.dt2[,var_name := paste0("all_",group_name)]
	s.dt2[,group_name := NULL]
	s.dt2 <- merge(i.dt2,s.dt2,by="var_name")
	rm(i.dt2)
	
	s.dt1 <- s.dt3[,.(tot=.N),by=c("data_source")]
	setorder(s.dt1,-tot,data_source)
	s.dt1 <- s.dt1[, .(data_source = paste(data_source,collapse=", "))]
	s.dt1[,var_name := "all_all"]
	s.dt1 <- merge(i.dt1,s.dt1,by="var_name")
	rm(i.dt1)
	
	s.dt <- rbindlist(list(s.dt1,s.dt2,s.dt3),use.names=TRUE,fill=TRUE)
	rm(s.dt1,s.dt2,s.dt3)
	setorder(s.dt,parent,var_label)
	s.dt[,c("source","survey","vintage","group_name") := NULL]
	
	###limit to variables that actually resulted in data for selected geographic region###
	s.dt <- s.dt[var_name %in% unique(out.dt$var_name)]
	
	###generate JS file for leaflet layers control###
	parent_recursion <- function(k) {
		lapply(k,function(j){
			tt <- s.dt[parent==j]
			if(nrow(tt)==0) {
				return(list(label = s.dt[var_name==j]$var_label, name= j))
			} else{
				return(list(label = s.dt[var_name==j]$var_label, name= j, children=parent_recursion(sort(tt$var_name))))
			}
		})
	}
	
	json.obj <- parent_recursion(s.dt[is.na(parent)]$var_name)
	json.obj <- jsonlite::toJSON(json.obj, pretty=TRUE, auto_unbox=TRUE)
	json.obj <- gsub('"label":','label:',json.obj)
	json.obj <- gsub('"name":','name:',json.obj)
	json.obj <- gsub('"children":','children:',json.obj)
	json.obj <- substr(json.obj,2,nchar(json.obj)-2)
	json.obj <- paste0("var baseTree = ",json.obj,";")
	
	js_file <- file.path(output.path,"tree-config.js")
	fileConn <- file(js_file)
	writeLines(json.obj, fileConn)
	close(fileConn)
	
	
	###get legend labels###
	legend.dt <- unique(out.dt[!is.na(var_weight),c("var_name","var_weight","var_legend","col")])
	setorder(legend.dt, var_name, var_weight)
	
	###generate legend JS file###
	json.lists <- lapply(sort(unique(legend.dt$var_name)), function(j){
			t.dt <- legend.dt[var_name==j,]
			setorder(t.dt, var_weight)
			t.dt <- t.dt[,c('var_legend','col'),with=FALSE]
			setnames(t.dt,names(t.dt),c('label','color'))
			return(list(var_name=j, title=s.dt[var_name==j]$legend_title, source=s.dt[var_name==j]$data_source, contents=t.dt))
		})
		
		

	json.list <- list(legends=json.lists)

	json.obj <- jsonlite::toJSON(json.list, pretty=TRUE, auto_unbox=TRUE)
	json.obj <- paste0("const legend_specs = ",json.obj,";")
	
	js_file <- file.path(output.path,"legend-config.js")
	fileConn <- file(js_file)
	writeLines(json.obj, fileConn)
	close(fileConn)
	
	rm(json.obj,json.list,json.lists)
	
	###transpose map data table###
	out.dt <- dcast(out.dt, GEOID ~ var_name, value.var = "col")
	out.dt <- melt(out.dt, id=c("GEOID"), variable.name = "var_name", variable.factor = FALSE)
	out.dt[,value := ifelse(is.na(value),na_col,value)]
	out.dt <- dcast(out.dt, GEOID ~ var_name, value.var = "value")
	out.dt <- out.dt[,c('GEOID',sort(names(out.dt)[!names(out.dt) %in% c('GEOID')])),with=FALSE]
	setorder(out.dt,GEOID)
	
	
	###export data for map as txt file###
	fwrite(out.dt, file = file.path(output.path,"map_variables.txt"), row.names=FALSE, append = FALSE, quote = TRUE, nThread=1)
	
}
