require(tidyverse)
require(sf)
require(marmap)
require(raster)
#define extent
xmin <- 165
xmax <- 230
ymin <- 48
ymax <- 71

#import basemap polygon
BASE<-st_read(dsn="Data",layer="AKbasemap") # Load 
#load regions
GDB <- st_read("Data/Alaska_Marine_Management_Areas.gdb")
#filter to regions, if you don't do this df3 will end up with >1000 points
ESR <- GDB %>% filter(Area_Type=="Ecosystem Subarea")

#bathymetry
#the bathy object works well with autoplot
r.ak <- getNOAA.bathy(lon1=-180,lon2=-129,lat1=47.5,lat2=71, resolution=1)
r.ak2<-r.ak*-1
#but I might have a better time converting to a polygon from a raster
r.ak <- marmap::as.raster( getNOAA.bathy(lon1=-180,lon2=-129,lat1=47.5,lat2=71, resolution=1))
#depths positive
r.ak2<-r.ak*-1
#convert to line with 10 and 200m isobath
r.ak3<-rasterToContour(r.ak2, levels=c(10,200))
#convert to SF object
r.ak4<-st_as_sf(r.ak3)
#clip to regions
#isolate BS and GOA
BSGOA<-ESR%>%filter(Ecosystem_Area != "Aleutian Islands")
#test
ggplot()+
  geom_sf(BSGOA, mapping=aes(color="red"))
#clip bathy line
r.ak5<-st_intersection(st_union(r.ak4), st_union(BSGOA))
#convert back to sf
r.ak6<-st_as_sf(r.ak5)
#convert to polygon
#this didn't work. I can do a good enough map with the line
r.ak7<-st_polygonize(r.ak6)

#
ggplot()+
 geom_sf(data=BASE%>% st_shift_longitude(), fill="gray60")+
 geom_sf(data=ESR%>% st_shift_longitude(), fill=NA, mapping=aes())+
  geom_sf(r.ak6%>%st_shift_longitude(), mapping=aes(), fill="black", size=1, lty=1)+
  coord_sf(xlim=c(xmin, xmax), ylim=c(ymin,ymax))+
  theme_void()

 

