require(jsonlite)
require(plyr)
library(rayshader)
library(ggmap)


# pull data  
abq <- fromJSON("http://coagisweb.cabq.gov/arcgis/rest/services/public/APD_Incidents/MapServer/0/query?where=1%3D1&text=&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=4326&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson")

# Get the 'locations' part of the list
locsabq <- abq$features

# These are all the columns that it contains...
names(locsabq)

#define data frame
df <- locsabq$geometry


# define map (after getting a Google API key   ) 
ABQ <- get_map(c(-106.59,35.110833),12, source='google',maptype="hybrid")

ABQ_3d <- get_map(c(-106.59,35.110833),12, source='google',maptype="terrain-background")

# make ggplot
p <- ggmap(ABQ) + stat_density_2d(data=df,aes(x,y,fill = stat(level)),  geom = 'polygon', alpha=.3) + 
  scale_fill_viridis_c(option = 'magma', name= "crime density") +
  ggtitle("Albuquerque Crime") + ylab("latitude\n") + xlab("longitude") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
p

p2 <- ggmap(ABQ_3d) + stat_density_2d(data=df,aes(x,y,fill = stat(level)),  geom = 'polygon', alpha=.3) + 
  scale_fill_viridis_c(option = 'magma', name= "crime density") +
  ggtitle("Albuquerque Crime\n") + ylab("latitude\n") + xlab("longitude") +
  theme_void() + theme(legend.position = 'bottom')
  
p2


# render 3D
par(mfrow = c(1, 2))
plot_gg(p, width = 4, raytrace = FALSE, preview = TRUE)

plot_gg(p2, width = 3, multicore = TRUE, windowsize = c(800, 800), 
        zoom = 0.65, phi = 35, theta = 30, sunangle = 225, soliddepth = -100)

render_snapshot(clear = TRUE)





