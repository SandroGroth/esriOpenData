#################################################################
# Name:       Demo                                              #
# Purpose:    Get Demography data of young people in Germany    #
# Author:     Sandro Groth                                      #
# Created:    29.04.2019                                        #
# Modified:                                                     #
#################################################################


#------------------------ 01. Imports ---------------------------

library(rgdal)
library(esriOpenData)
library(leaflet)
library(magrittr)

#---------------- 02. Setting output directory ------------------

# Set an output directory where later datasets will be downloaded
# If specified directory does not exits, it will be created
set_dir("/home/sandro/Desktop/ESRIDownload")

#-------------------- 03. Setting an AOI ------------------------

bbox_shp <- readOGR("./examples/data/germany_bbox.shp")
plot(bbox_shp)

set_aoi(bbox_shp)

#------------ 04. Search for Demography datasets ----------------

found_ds <- search_datasets(query = "Demography", aoi = TRUE)
View(found_ds)

#----------------- 05. Select Zensus dataset --------------------

selected_ds <- select_dataset(found_ds, 1)
View(selected_ds)

#--------------- 06. Get all fields of dataset ------------------

fields(selected_ds) # ALTER_1 represents Age 18 - 29

#--------------- 07. Load data from the server ------------------

# query layer to exclude all unneccessary fields
demography <- get_dataset(selected_ds, fields = c("OBJECTID", "NAME", "ALTER_1"),
                          export = FALSE)

#-------------------- 08. Visualization -------------------------

# Create a color palette for values of col ALTER_1
pal <- colorNumeric(
  palette = "YlOrRd",
  domain = demography$ALTER_1
)

# Create leaflet object
map <- leaflet(demography) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd", ALTER_1)(ALTER_1)) %>%
  addTiles() %>%  # add basemap
  addLegend("topright", pal = pal, values = ~ALTER_1,
            title = "Age 18-29",
            labFormat = labelFormat(),
            opacity = 1
  )
map

#--------------- OPTIONAL: Download full dataset ----------------

download_full_dataset(selected_ds, format = "kml") # kml, shp, csv
