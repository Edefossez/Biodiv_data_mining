
library(rgbif)
library(rnaturalearth)
library(ggplot2)


# IF YOU HAVE ONLY ONE SPECIES ----
myspecies <- c("Festuca rubra")

# download GBIF occurrence data for this species; this takes time if there are many data points!
gbif_data <- occ_data(scientificName = myspecies, hasCoordinate = TRUE, limit = 5000)
plot(gbif_data$data$decimalLatitude,gbif_data$data$decimalLongitude)

# if your species is widespread but you want to work on a particular region, you can download records within a specified window of coordinates:
gbif_data <- occ_data(scientificName = myspecies, hasCoordinate = TRUE, limit = 10000, decimalLongitude = "0, 100", decimalLatitude = "40, 80")  # note that coordinate ranges must be specified this way: "smaller, larger" (e.g. "-5, -2")
plot(gbif_data$data$decimalLatitude,gbif_data$data$decimalLongitude)



occur  <- gbif_data$data

gbif_data_switerland <- occur[occur$country == "Switzerland",]
gbif_data_europe<- occur[occur$continent == "EUROPE",]


Switzerland <- ne_countries(scale = "medium", returnclass = "sf",country ="Switzerland" )
Europe <- ne_countries(scale = "medium", returnclass = "sf",continent = "europe" )


ggplot(data = Switzerland) +
  geom_sf()   +
  geom_point(data = gbif_data_switerland, aes(x = decimalLongitude, y = decimalLatitude), size = 4, 
             shape = 23, fill = "darkgreen") + theme_classic() #+
#coord_sf(xlim = c(-10, 10), ylim = c(40, 55)) 


################################################################################
################################################################################
### add climatic data 

library(raster)
library(sp)

#r <- getData("worldclim",var="bio",res=10)
r <- r[[c(1)]]
names(r) <- c("Temp")

points <- SpatialPoints(data.frame(gbif_data_switerland$decimalLongitude,gbif_data_switerland$decimalLatitude))     ### add your points

values <- extract(r,points)
temp <- values/10

gbif_data_switerland$temp <- temp


################################################################################
################################################################################
################################################################################
################################################################################
############## Manipulate Temporal data 


library("lubridate")

gbif_data_switerland_ST <-  gbif_data_switerland[,c("decimalLongitude","decimalLatitude","eventDate","temp")]

list_date <- gbif_data_switerland_ST$eventDate
list_date[1]
class(list_date[1])

################################################################################
################################################################################

date_convert <- ymd_hms(list_date[1])
class(date_convert)


################################################################################
################################################################################

date_convert <- ymd_hms(list_date)
class(date_convert)

plot(gbif_data_switerland_ST$decimalLongitude~date_convert)

gbif_data_switerland_ST$eventDate <- ymd_hms(gbif_data_switerland_ST$eventDate )

###### extrat date or time 
x_time <- format(gbif_data_switerland_ST$eventDate, format = "%H:%M:%S")   # Extract information
                
x_date<- format(gbif_data_switerland_ST$eventDate,format = "%d-%m-%y")   # Extract information

gbif_data_switerland_ST$x_date <- as.Date(x_date,format = "%d-%m-%y")

ggplot(gbif_data_switerland_ST, aes(x=x_date, y=temp)) +
  geom_line()+scale_x_date(date_labels = "%y-%m-%d")


  
##### create time serie object 
library(tsbox)

Time_serie_data  <- xts(x = gbif_data_switerland_ST$temp, order.by = gbif_data_switerland_ST$eventDate)
plot(Time_serie_data)

Time_serie_data2 <- Time_serie_data[!duplicated(index(Time_serie_data))]
ts_ggplot(total = Time_serie_data2) + theme_tsbox() + scale_color_tsbox()

##### round date

date_convert <- ymd_hms(list_date[1])
day(date_convert)
month(date_convert)
year(date_convert)


#### add a column month and day  in the dataset 

date_convert <- ymd_hms(list_date)
gbif_data_switerland_ST$month <- month(date_convert)
gbif_data_switerland_ST$day <- day(date_convert)


########### filter by month 

gbif_data_switerland_ST_july <- gbif_data_switerland_ST[gbif_data_switerland_ST$month == 7,]

ggplot(gbif_data_switerland_ST_july, aes(x=x_date, y=decimalLongitude)) +
  geom_line()+scale_x_date(date_labels = "%d-%m-%y")

class(gbif_data_switerland_ST$eventDate)
gbif_data_switerland_ST_july <- gbif_data_switerland_ST[gbif_data_switerland_ST$eventDate > "2021-06-30 UTC",]


################################################################################
################################################################################
################################################################################
################################################################################
############## Manipulate spatial data 
library(rinat)
library(raster)

red_fox <- get_inat_obs(query = "Vulpes vulpes",place_id = "switzerland")


dat <- data.frame(as.numeric(red_fox$longitude), as.numeric(red_fox$latitude))
colnames(dat) <- c("longitude", "latitude")
dat <- na.omit(dat)
dat <- data.frame(dat)

spatial_coord <- SpatialPoints(dat)

proj4string(spatial_coord) <- CRS("EPSG:4326") 



spatial_coord2  <-sp::spTransform(spatial_coord, CRS("EPSG:3857"))

spatial_coord3  <-sp::spTransform(spatial_coord2, CRS("+proj=longlat +datum=WGS84 +no_defs "))





