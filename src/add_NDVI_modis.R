################################################################################
################################################################################
################################################################################
######## NDVI

library(rgeoboundaries)
library(sf)

# Downloading the country boundary of Mongolia
map_boundary <- ne_countries(scale = "medium", returnclass = "sf",country ="switzerland" )

# Defining filepath to save downloaded spatial file
spatial_filepath <- "./path/switzerland/switzerland.shp"

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

######################################################################################
######################################################################################
#############landcover


MODIStsp_get_prodlayers("M*D12Q1")  ### landcover

library(MODIStsp)

MODIStsp(
  gui = FALSE,
  out_folder = "G:/My Drive/taf/cours fac/Environemental data mining/switzerland",
  out_folder_mod = "G:/My Drive/taf/cours fac/Environemental data mining/switzerland",
  selprod = "LandCover_Type_Yearly_500m (MCD12Q1)",
  bandsel = "LC1",
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
PFT_raster <- raster(here::here("G:/My Drive/taf/cours fac/Environemental data mining/switzerland/switzerland/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2019_001.tif"))

# Transforming the data
PFT_raster <- projectRaster(PFT_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Cropping the data
PFT_raster <- raster::mask(PFT_raster, as_Spatial(map_boundary))

points <- data.frame(matrix_full$longitude,matrix_full$latitude)
points <- sp::SpatialPoints(points,proj4string = sp::CRS(SRS_string = "EPSG:4326"))
PFT <- extract(PFT_raster, points, method='simple')

matrix_PFT<- as.data.frame(PFT_raster, xy = TRUE, na.rm = TRUE) 

matrix_full$PFT <- PFT


################################################################################