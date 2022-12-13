
library(rayshader)
library(rinat)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)

############# elevation data 


Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="switzerland" )

ggplot(data = Switzerland) +
  geom_sf()   +
  geom_point(data = matrix_full, aes(x = longitude, y = latitude,fill=source), size = 4, 
             shape = 23) + theme_classic() 

###### extract a country from polygon 

Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="switzerland" )
sf  <- switzerland$geometry
#st_crs(sf) <- 4326

elevation_data <- elevatr::get_elev_raster(locations = sf, z = 6, clip = "locations")


points <- SpatialPoints(data.frame(matrix_full$longitude,matrix_full$latitude))   

plot(elevation_data)
plot(points,add=T)


elevation_points <- extract(elevation_data, points, method='bilinear')

########
matrix_full$elevation <- elevation_points


############################################################
###########################################################

require(rgdal)
require(raster)


##### from spatail point 
limit_sp <- extent(points)
p <- as(limit_mnt, 'SpatialPolygons')  
projection(p) <-  CRS("EPSG:4326" )

elevation_data <- elevatr::get_elev_raster(locations = p, z = 6, clip = "locations")
plot(elevation_data)


###3 from points 
points <- SpatialPoints(data.frame(matrix_full$longitude,matrix_full$latitude))   
projection(points) <-  CRS("EPSG:4326" )

cvx_hull <- hull_polygon(points, hull_type = "convex")
elevation_data <- elevatr::get_elev_raster(locations = cvx_hull, z = 6, clip = "locations")


plot(elevation_data)

##### from coordiantes

x <- c(9.849204 ,7.017550,6.251097,6.426160,7.008280,9.849204)
y <- c(46.83324,46.20816,46.22592,46.65422,47.37753,46.83324)
limit_manual <- data.frame(x,y)

p = Polygon(limit_manual)
ps = Polygons(list(p),1)
sps = SpatialPolygons(list(ps))
projection(sps) <-  CRS("EPSG:4326" )
plot(sps)

elevation_data <- elevatr::get_elev_raster(locations = sps, z = 6, clip = "locations")

