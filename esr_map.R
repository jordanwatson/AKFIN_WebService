library(tidyverse)
library(sf)
  
#  Load basemap
base<-st_read(dsn="Data",layer="AKbasemap") #import basemap polygon

#  What was the name of that projected layer again?
st_layers("Data/Alaska_Marine_Management_Areas.gdb")

#  Load projected layer for ESR regions.
esr <- st_read("Data/Alaska_Marine_Management_Areas.gdb",layer="Alaska_Marine_Areas_AK_prj") %>% #load regions
  filter(Area_Type=="Ecosystem Subarea")

#  Extract locations for lat-lon points for each ESR (depth-filtered GOA and Bering)
lkp <- readRDS("Data/crwsst_spatial_lookup_table.RDS") %>% #import lookup table
  filter(ECOSYSTEM_SUB!="NA") %>%
  filter((ECOSYSTEM != "Aleutian Islands") & DEPTH<=-10 & DEPTH>=-200) %>% 
  bind_rows(readRDS("Data/crwsst_spatial_lookup_table.RDS") %>% #import lookup table
              filter(ECOSYSTEM_SUB!="NA" & ECOSYSTEM == "Aleutian Islands")) %>% 
  rename_all(tolower) %>% 
  mutate(longitude2=longitude,latitude2=latitude)
  
#  Project gridded data
points_sf = st_as_sf(lkp %>% dplyr::select(id,longitude,latitude,longitude2,latitude2), coords = c("longitude2", "latitude2"), crs = 4326, agr = "constant") 

#  Let's see what its projection is.
# print(st_crs(esr)$proj4string)
# print(st_crs(base)$proj4string)

#  Transform the points and basemap to match the ESR regions projection
efh_pts <- points_sf %>% st_transform(st_crs(esr)$proj4string)
base <- base %>% st_transform(st_crs(esr)$proj4string)

pdf("esr_map_depth_filters.pdf")
ggplot() + 
  geom_sf(data=efh_pts,size=0.05,color="grey80") + 
  geom_sf(data=esr,fill=NA) + 
  geom_sf(data=base,fill="grey35",color="black") +
  coord_sf(xlim=c(-2538555, 1351449), ylim=c(43371,2434528))+
  theme_void()
dev.off()
