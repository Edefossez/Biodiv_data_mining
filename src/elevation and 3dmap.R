
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
  extent = extent(switzerland),size = 9,
  lat = matrix_full$latitude, long = matrix_full$longitude,
  altitude = elevation+500, zscale = 150, color = "darkred"
)

