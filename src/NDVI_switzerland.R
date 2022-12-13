

# remotes::install_github("wmgeolab/rgeoboundaries")
# install.packages("sf")
library(rgeoboundaries)
library(sf)

# Downloading the country boundary of Mongolia
map_boundary <- geoboundaries("switzerland")

# Defining filepath to save downloaded spatial file
spatial_filepath <- "./path/switzerland/switzerland.shp"

# Saving downloaded spatial file on to our computer
st_write(map_boundary, paste0(spatial_filepath))


library(MODIStsp)

MODIStsp(
  gui = FALSE,
  out_folder = "./path/switzerland",
  out_folder_mod = "./path/switzerland",
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


library(rgeoboundaries)
library(sf)
library(raster)
library(here)
library(ggplot2)
library(viridis)
library(rgdal)

# Downloading the boundary of switzerland
map_boundary <- geoboundaries("switzerland")

# Reading in the downloaded NDVI raster data
NDVI_raster <- raster(here::here("./path/switzerland/switzerland/VI_16Days_1Km_v6/NDVI/MYD13A2_NDVI_2020_153.tif"))

# Transforming the data
NDVI_raster <- projectRaster(NDVI_raster, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Cropping the data
NDVI_raster <- raster::mask(NDVI_raster, as_Spatial(map_boundary))

# Dividing values by 10000 to have NDVI values between -1 and 1
gain(NDVI_raster) <- 0.0001

# Converting the raster object into a dataframe
NDVI_df <- as.data.frame(NDVI_raster, xy = TRUE, na.rm = TRUE)
rownames(NDVI_df) <- c()

# Visualising using ggplot2
ggplot() +
  geom_raster(
    data = NDVI_df,
    aes(x = x, y = y, fill = MYD13A2_NDVI_2020_153)
  ) +
  geom_sf(data = map_boundary, inherit.aes = FALSE, fill = NA) +
  scale_fill_viridis(name = "NDVI") +
  labs(
    title = "NDVI (Normalized Difference Vegetation Index) in switzerland",
    subtitle = "01-06-2020",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal()



#######################

projection(Object1) 
#c("+proj=longlat +ellps=WGS84 +no_defs")

projection(Object2)
#c("+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

# use crs() to extract CRS from raster
Object2reprojected <- spTransform(Object2,crs(Object1))


