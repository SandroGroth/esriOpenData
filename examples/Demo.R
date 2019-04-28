library(rgdal)
library(esriOpenData)
library(maptools)
library(leaflet)
library(magrittr)

set_dir("/home/sandro/Desktop/ESRIDownload")

bbox_shp <- readOGR("./examples/data/germany_bbox.shp")
set_aoi(bbox_shp)

found_ds <- search_datasets(query = "Demography", aoi = TRUE)
View(found_ds)

selected_ds <- select_dataset(found_ds, 1)
View(selected_ds)

fields(selected_ds)

demography <- get_dataset(selected_ds, fields = c("OBJECTID", "NAME", "DES", "ALTER_1"))

pal <- colorNumeric(
  palette = "YlOrRd",
  domain = demography$ALTER_1
)

map <- leaflet(demography) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd", ALTER_1)(ALTER_1)) %>%
  addTiles() %>%
  addLegend("topright", pal = pal, values = ~ALTER_1,
            title = "Age 18-29",
            labFormat = labelFormat(),
            opacity = 1
  )
map

download_full_dataset(selected_ds, format = "kml")
