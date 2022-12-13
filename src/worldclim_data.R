library(raster)
library(sp)

r <- getData("worldclim",var="bio",res=10)
#Bio 1 and Bio12 are mean anual temperature and anual precipitation:

#tmax_data <- getData(name = "worldclim", var = "tmax", res = 10) ## monthly

r<- getData('CMIP5', var='tmin', res=10, rcp=45, model='HE', year=50) ## future climate


  
r <- r[[c(1)]]
names(r) <- c("Temp","Prec")

gain(r$Temp) <- 0.1 ## converrt to celcius 


points <- spsample(as(r@extent, 'SpatialPolygons'),n=100, type="random")     ### add your points


values <- extract(r,points)

df <- cbind.data.frame(coordinates(points),values)

head(df)


plot(r[[1]])
plot(points,add=T)


# BIO1 = Annual Mean Temperature
# BIO2 = Mean Diurnal Range (Mean of monthly (max temp - min temp))
# BIO3 = Isothermality (BIO2/BIO7) (×100)
# BIO4 = Temperature Seasonality (standard deviation ×100)
# BIO5 = Max Temperature of Warmest Month
# BIO6 = Min Temperature of Coldest Month
# BIO7 = Temperature Annual Range (BIO5-BIO6)
# BIO8 = Mean Temperature of Wettest Quarter
# BIO9 = Mean Temperature of Driest Quarter
# BIO10 = Mean Temperature of Warmest Quarter
# BIO11 = Mean Temperature of Coldest Quarter
# BIO12 = Annual Precipitation
# BIO13 = Precipitation of Wettest Month
# BIO14 = Precipitation of Driest Month
# BIO15 = Precipitation Seasonality (Coefficient of Variation)
# BIO16 = Precipitation of Wettest Quarter
# BIO17 = Precipitation of Driest Quarter
# BIO18 = Precipitation of Warmest Quarter
# BIO19 = Precipitation of Coldest Quarter



sw_clim <- worldclim_country("switzerland", var="tmin", path=tempdir()) #"tmin", "tmax", "tavg", "prec" and "bio"
sw_clim_br <- brick(sw_clim)


