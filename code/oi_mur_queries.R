library(tidyverse)
library(DBI) #  For database query
library(odbc)
library(sp) # For maps
library(rgdal) # For maps
library(lubridate)

#  Load the AKFIN database user name and password from an external file.
params <- read_csv("code/markdown_odbc_params.csv")

#  Connect to the AKFIN database
# con <- dbConnect(odbc::odbc(), "akfin", UID=rstudioapi::askForPassword("Enter AKFIN Username"), PWD= rstudioapi::askForPassword("Enter AFSC Password"))
con <- dbConnect(odbc::odbc(), "akfin", UID=params$uid, PWD=params$pass)



#Query OISST temperature for the Eastern Gulf of Alaska on 4th of July 2021 and plot heatmap
sst<-dbFetch(dbSendQuery(con,
                    paste0("select read_date, temp, ecosystem_sub, longitude, latitude
                            from afsc.erddap_oi_sst a                            
                            INNER JOIN (select * 
                                      from afsc.erddap_oi_sst_spatial_lookup
                                      where ecosystem_sub = 'Eastern Gulf of Alaska') b
                            ON a.oi_id = b.id
                            where read_date='04-JUL-09'")))
#define spatial extent
xmin <- -145
xmax <- -129
ymin <- 53
ymax <- 61
#import basemap polygon
BASE<-tidy(readOGR(dsn="Data",
                        layer="AKbasemap",
                        verbose=FALSE)) # Load basemap

  ggplot()+geom_tile(data=sst, aes(LONGITUDE, LATITUDE, fill=TEMP))+
    geom_polygon(data=BASE,aes(x=long,y=lat,group=factor(group)),fill="gray40")+
    xlim(c(xmin,xmax))+ylim(c(ymin,ymax))+
    scale_fill_viridis_c()+
    theme_bw()
  
#Connect MUR SST with observer data to model whether SST influenced salmon shark catch in the GOA trawl fleet
  #Fortunately AKFIN already connected observer data with MUR SST in the comprehensive observer data view so we can just query that
  #Data are limited to GOA (not AI) and pelagic trawl gear
  mursst<-dbFetch(dbSendQuery(con,
                           paste0(
"select distinct(a.haul_join), a.avg_sst_celsius as SST, b.obs_specie_code
from council.comprehensive_obs_v a
left join (select obs_specie_code, haul_join
from council.comprehensive_obs_v 
where obs_specie_code=67) b
on a.haul_join=b.haul_join
where a.reporting_area_code>= 620 and
a.avg_sst_celsius>0 and
a.akr_gear_code = 'PTR'")))
  mursst<-mursst %>% mutate(shark=ifelse(is.na(OBS_SPECIE_CODE),0,1))
model<-glm(shark~SST, data=mursst, family="binomial")
summary(model)  
dummy<-data.frame(SST=seq(min(mursst$SST), max(mursst$SST), len=500))
dummy$shark<-predict(model, dummy, type="response")
plot(shark ~ SST, data=mursst, col="steelblue")
lines(shark ~ SST, data=dummy, lwd=2)
