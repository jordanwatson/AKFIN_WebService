```{r, echo=FALSE,message=FALSE,warning=FALSE,fig.height=6,eval=FALSE}
xmin <- 165
xmax <- 230
ymin <- 50
ymax <- 68

#  Load the non-Crab areas
area<- readOGR(dsn="Data/Alaska_Marine_Management_Areas.gdb",
               layer="Alaska_Marine_Areas_dd",
               verbose=FALSE)
test.df <- merge(fortify(area), as.data.frame(area), by.x="id", by.y=0) %>%
  mutate(long2=ifelse(long>0,long-360, long),
         BSIERP_ID=ifelse(BSIERP_ID==0,NA,BSIERP_ID)) %>% 
  rename(`NMFS Area`=NMFS_REP_AREA,
         `ESR Region`=Ecosystem_Subarea,
         `ADFG Stat Area`=STAT_AREA,
         `BSIERP Region`=BSIERP_ID)

#  Load and merge the two different crab shapefiles.
# crab <- readOGR(dsn="../../Other_People/Erin_Fedewa/Data",layer="BristolBay") %>% 
#   fortify() %>% 
#   mutate(long2=ifelse(long<0,long+360, long),
#          group="bb") %>% 
#   bind_rows(readOGR(dsn="../../Other_People/Erin_Fedewa/Data",layer="St_Matthew_District") %>% 
#               fortify() %>% 
#               mutate(long2=ifelse(long<0,long+360,long),
#                      group="stm"))

#  Merge the different polygon fields and shapefiles.
newdata <- test.df %>% 
  filter(!is.na(`NMFS Area`)) %>% 
  mutate(stratum="NMFS Areas") %>% 
  bind_rows(test.df %>% 
              filter(!is.na(`BSIERP Region`)) %>% 
              mutate(stratum="BSIERP Regions")) %>% 
  bind_rows(test.df %>% 
              filter(!is.na(`ESR Region`)) %>% 
              mutate(stratum="ESR Regions")) %>% 
  bind_rows(test.df %>% 
              filter(!is.na(`ADFG Stat Area`)) %>% 
              mutate(stratum="ADF&G Stat Areas")) %>% 
  bind_rows(readOGR(dsn="Data",layer="BristolBay",verbose=FALSE) %>%  # Read in and merge crab shapefiles
              fortify() %>% 
              mutate(long2=ifelse(long<0,long+360, long),
                     group="bb") %>% # To avoid duplicating group factors from the other shapefiles, create a distinct grouping level for crab. bb is Bristol Bay
              bind_rows(readOGR(dsn="Data",
                                layer="St_Matthew_District",
                                verbose=FALSE) %>%
                          fortify() %>% 
                          mutate(long2=ifelse(long<0,long+360,long),
                                 group="stm")) %>% # Similar to Bristol Bay, create St. Matthews grouping factor
              mutate(stratum="Crab Mgmt Areas"))

ggplot() + 
  geom_polygon(data=tidy(readOGR(dsn="Data",
                                 layer="AKbasemap",
                                 verbose=FALSE)) %>% # Load basemap
                 mutate(long2=ifelse(long<0,long+360,long))
               ,aes(x=long2,y=lat,group=factor(group)),fill="grey70") +
  geom_polygon(data=newdata,aes(long2,lat,group=factor(group)),
               fill=NA,
               color="black") + 
  facet_wrap(~stratum,ncol=2) +
  coord_map("albers",lat0=54,lat1=62,xlim=c(xmin,xmax),ylim=c(ymin,ymax)) + 
  theme_void()
```