

library(rgeoboundaries)
library(raster)
library(ggplot2)
library(viridis)
library(rinat)
library(rnaturalearth)

canis_lupus <- get_inat_obs(query = "canis lupus",place_id = "switzerland") # ,year = 2019,month = 1


dat <- data.frame( as.numeric(canis_lupus$longitude),as.numeric(canis_lupus$latitude))
colnames(dat) <- c("longitude", "latitude")
dat <- na.omit(dat)
dat <- data.frame(dat)

spatial_coord <- SpatialPoints(dat)
plot(spatial_coord)


switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="switzerland" )

ggplot(data = switzerland) +
  geom_sf()   +
  geom_point(data = dat2, aes(x = longitude, y = latitude), size = 4, 
             shape = 23, fill = "darkgreen") + theme_classic() 