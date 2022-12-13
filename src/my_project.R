
library(rgbif)
library(rnaturalearth)
library(ggplot2)
library(rinat)


# IF YOU HAVE ONLY ONE SPECIES ----
myspecies <- c("Cardamine pratensis")

# download GBIF occurrence data for this species; this takes time if there are many data points!
gbif_data <- occ_data(scientificName = myspecies, hasCoordinate = TRUE, limit = 5000)
plot(gbif_data$data$decimalLatitude,gbif_data$data$decimalLongitude)

occur  <- gbif_data$data

gbif_data_switerland <- occur[occur$country == "Switzerland",]

Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )


ggplot(data = Switzerland) +
  geom_sf()   +
  geom_point(data = gbif_data_switerland, aes(x = decimalLongitude, y = decimalLatitude), size = 4, 
             shape = 23, fill = "darkgreen") + theme_classic() 

species <- gbif_data_switerland$species ## check if accepted in metadata
latitude <- gbif_data_switerland$decimalLatitude
longitude <- gbif_data_switerland$decimalLongitude
date <-gbif_data_switerland$eventDate
source <- rep("gbif",length(species))

data_gbif <- data.frame(species,latitude,longitude,date,source)

###############################################################################
###############################################################################

library(rinat)
library(raster)

Fe_ru_inat <- get_inat_obs(query = "Cardamine pratensis",place_id = "switzerland")

Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )

ggplot(data = Switzerland) +
  geom_sf()   +
  geom_point(data = Fe_ru_inat, aes(x = longitude, y = latitude), size = 4, 
             shape = 23, fill = "darkred") + theme_classic() 


species <- Fe_ru_inat$scientific_name
latitude <- Fe_ru_inat$latitude
longitude <- Fe_ru_inat$longitude
date <- Fe_ru_inat$datetime
source <- rep("inat",length(species))

data_inat <- data.frame(species,latitude,longitude,date,source)

################################################################################
################################################################################
############ bind iNaturalist and gbiff data

matrix_full <- rbind(data_inat,data_gbif)

ggplot(data = Switzerland) +
  geom_sf()   +
  geom_point(data = matrix_full, aes(x = longitude, y = latitude,fill=source), size = 4, 
             shape = 23) + theme_classic() 

################################################################################
################################################################################
### add climatic data 

library(raster)
library(sp)

r <- getData("worldclim",var="bio",res=10)
r <- r[[c(1,12)]]
names(r) <- c("Temp","precp")

points <- SpatialPoints(data.frame(matrix_full$longitude,matrix_full$latitude))     ### add your points

values <- extract(r,points)
temperature <- values[,1]/10
precipitation <- values[,2]

matrix_full$temp <- temperature

matrix_full$precip <- precipitation

################################################################################
################################################################################
library("lubridate")


################################################################################
################################################################################

date_convert <- ymd_hms(matrix_full$date)
class(date_convert)

matrix_full$day <- day(date_convert)
matrix_full$month <-month(date_convert)
matrix_full$year <-year(date_convert)

################################################################################
################################################################################
############ add levation
library(sf)

switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="switzerland" )

sf  <- switzerland$geometry
st_crs(sf) <- 4326

elevation_data <- elevatr::get_elev_raster(locations = sf, z = 6, clip = "locations")

plot(elevation_data)
points <- data.frame(matrix_full$longitude,matrix_full$latitude)
points <- sp::SpatialPoints(points,proj4string = sp::CRS(SRS_string = "EPSG:4326"))
plot(points,add=T)

elevation <- extract(elevation_data, points, method='bilinear')

matrix_full$elevation <- elevation

############### alternative 
library(geoviz)


square_km = 80
max_tiles = 40
lat = mean(matrix_full$latitude)
lon = mean(matrix_full$longitude)

dem <- mapzen_dem(lat, lon, square_km, max_tiles = max_tiles)



################################################################################
################################################################################



library(rgeoboundaries)
library(sf)

# Downloading the country boundary of Mongolia
map_boundary <- ne_countries(scale = "medium", returnclass = "sf",country ="switzerland" )

# Defining filepath to save downloaded spatial file
spatial_filepath <- "G:/My Drive/taf/cours fac/Environemental data mining/switzerland/switzerland.shp"

# Saving downloaded spatial file on to our computer
st_write(map_boundary, paste0(spatial_filepath))


MODIStsp_get_prodlayers("M*D13A2") ### NDVI


library(MODIStsp)

MODIStsp(
  gui = FALSE,
  out_folder = "G:/My Drive/taf/cours fac/Environemental data mining/switzerland",
  out_folder_mod = "G:/My Drive/taf/cours fac/Environemental data mining/switzerland",
  selprod = "Vegetation_Indexes_16Days_1Km (M*D13A2)",
  bandsel = "NDVI",
  user = "mstp_test",
  password = "MSTP_test_01",
  start_date = "2020.06.01",
  end_date = "2020.06.01",
  verbose = FALSE,
  spatmeth = "file",
  spafile = spatial_filepath,
  out_format = "GTiff"
)


# Reading in the downloaded NDVI raster data
NDVI_raster <- raster(here::here("G:/My Drive/taf/cours fac/Environemental data mining/switzerland/switzerland/VI_16Days_1Km_v6/NDVI/MYD13A2_NDVI_2020_153.tif"))

# Transforming the data
NDVI_raster <- projectRaster(NDVI_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Cropping the data
NDVI_raster <- raster::mask(NDVI_raster, as_Spatial(map_boundary))

points <- data.frame(matrix_full$longitude,matrix_full$latitude)
points <- sp::SpatialPoints(points,proj4string = sp::CRS(SRS_string = "EPSG:4326"))
NDVI <- extract(NDVI_raster, points, method='bilinear')

matrix_full$NDVI <- NDVI


################################################################################
################################################################################
### landsuse


MODIStsp_get_prodlayers("M*D12Q1")  ### landcover

library(MODIStsp)

MODIStsp(
  gui = FALSE,
  out_folder = "G:/My Drive/taf/cours fac/Environemental data mining/switzerland",
  out_folder_mod = "G:/My Drive/taf/cours fac/Environemental data mining/switzerland",
  selprod = "LandCover_Type_Yearly_500m (MCD12Q1)",
  bandsel = "LC_Prop2_Assessment",
  user = "mstp_test",
  password = "MSTP_test_01",
  start_date = "2019.01.01",
  end_date = "2019.12.31",
  verbose = FALSE,
  spatmeth = "file",
  spafile = spatial_filepath,
  out_format = "GTiff"
)

# Reading in the downloaded NDVI raster data
#PFT = Plant Functional Types
LC_raster <- raster(here::here("G:/My Drive/taf/cours fac/Environemental data mining/switzerland/switzerland/LandCover_Type_Yearly_500m_v6/LC_Prop2_Assessment/MCD12Q1_LC_Prop2_Assessment_2019_001.tif"))

# Transforming the data
LC_raster <- projectRaster(LC_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Cropping the data
LC_raster <- raster::mask(LC_raster, as_Spatial(map_boundary))

points <- data.frame(matrix_full$longitude,matrix_full$latitude)
LC <- extract(LC_raster, points, method='simple')



matrix_full$LC <- round(LC)
unique(matrix_full$LC )

#https://lpdaac.usgs.gov/documents/101/MCD12_User_Guide_V6.pdf

matrix_full$LC[matrix_full$LC >40]  <- "Unclassified"
matrix_full$LC[(matrix_full$LC >0 & matrix_full$LC <= 1)]  <- "barren"
matrix_full$LC[(matrix_full$LC >1 & matrix_full$LC <= 2)]  <- "Permanent_Snow_and_Ice"
matrix_full$LC[(matrix_full$LC >2 & matrix_full$LC <= 3)]  <- "Water_Bodies"
matrix_full$LC[(matrix_full$LC >3 & matrix_full$LC <= 9)]  <- "Urban_and_Built_up_Lands"
matrix_full$LC[(matrix_full$LC >9 & matrix_full$LC <= 10)]  <- "Dense_Forests"
matrix_full$LC[(matrix_full$LC >10 & matrix_full$LC <= 20)]  <- "Open_Forests"
matrix_full$LC[(matrix_full$LC >20 & matrix_full$LC <= 25)]  <- "Forest_Cropland_Mosaics"
matrix_full$LC[(matrix_full$LC >25 & matrix_full$LC <= 30)]  <- "Natural_Herbaceous"
matrix_full$LC[(matrix_full$LC >30 & matrix_full$LC <= 35)]  <- "Natural_Herbaceous_Croplands_Mosaics"
matrix_full$LC[(matrix_full$LC >35 & matrix_full$LC <= 36)]  <- "Herbaceous_Croplands"
matrix_full$LC[(matrix_full$LC >36 & matrix_full$LC <= 40)]  <- "Shrublands"




###############################################################################
##############################################################################





################################################################################
################################################################################
############ 3d map

############## plot 3d  
library(rayshader)

# And convert it to a matrix:
elmat <- raster_to_matrix(elevation_data)


mapbox_key <- "pk.eyJ1IjoibWFudWRmeiIsImEiOiJjbGF0bWI5ZW4wMjh1M3BwOHd2NW12dHp0In0.7T4zPM1bBeKV3rdELHCyeA"
# https://docs.mapbox.com/accounts/guides/tokens/#default-public-access-token

overlay_image <-
  slippy_overlay(
    elevation_data,
    image_source = "mapbox",
    image_type = "satellite",
    png_opacity = 0.6,
    api_key = mapbox_key
  )


# We use another one of rayshader's built-in textures:
elmat %>% 
  sphere_shade(sunangle = 270, texture = "bw") %>%
  add_overlay(overlay_image)  %>%
  plot_3d(elmat, zscale = 250, fov = 0, theta = 135, zoom = 0.75, 
          phi = 45, windowsize = c(1500, 800))



render_points(
  extent = extent(switzerland),size = 10,
  lat = matrix_full$latitude, long = matrix_full$longitude,
  altitude = elevation+100, zscale = 150, color = "darkred"
)




