library(sf)
library(rinat)
library(dplyr)

############ https://www.swisstopo.admin.ch/fr/geodata/landscape/tlmregio.html

# Load shapefile
shapename <- read_sf("./path/swissTLMRegio_Product_LV95/Landcover/swissTLMRegio_LandCover.shp")

red_fox <- get_inat_obs(query = "Vulpes vulpes",place_id = "switzerland")


dat <- data.frame(as.numeric(red_fox$longitude), as.numeric(red_fox$latitude))
colnames(dat) <- c("longitude", "latitude")
dat <- na.omit(dat)
dat <- data.frame(dat)

spatial_coord <- SpatialPoints(dat)
proj4string(spatial_coord) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

spatial_coord2  <-sp::spTransform(spatial_coord, CRS("EPSG:2056"))

pnts_sf <- st_as_sf(spatial_coord2, coords = c('y', 'x'))

pnts <- pnts_sf %>% mutate(
  intersection = as.integer(st_intersects(geometry, shapename))
  , area = if_else(is.na(intersection), '', shapename$OBJVAL[intersection])
) 

data_landuse <- data.frame(pnts)
area <- data_landuse$area
nindiv <- rep(1, length(area))

data_plot <- data.frame(area,nindiv)
check <- tapply(data_plot$nindiv,data_plot$area,sum,na.rm=T)

