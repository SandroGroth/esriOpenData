# esriOpenData

[![CRAN version](https://www.r-pkg.org/badges/version/esriOpenData)](https://CRAN.R-project.org/package=esriOpenData)
[![Build Status](https://travis-ci.org/SandroGroth/esriOpenData.svg?branch=master)](https://travis-ci.org//SandroGroth/esriOpenData)
[![Lifecycle:experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)

## Introduction

esriOpenData is an R package, that provides easy to use functions to access, query and donwload datasets from Esri's Open Data platform. Esri Open Data Hub stores a over 17,000 free and open datasets in different categories, ranging from climate to demography data. Many of these that can be helpful as ancilliary data in a remote sensing analysis. To explore the web interface of Esri Open Data Hub, see <http://hub.arcgis.com/pages/open-data>.

esriOpenData can be installed using devtools:

```R
devtools::install_github("SandroGroth/esriOpenData")
```

## Getting started

In this demo, a demography dataset should be obtained for Germany from querying the server to having a ready to use dataset in the R Environment. In the first step, all necessary packages have to be imported:

```R
library(rgdal)
library(leaflet)
library(magrittr)
library(esriOpenData)
```

### Setting an output directory

Next, the path where obtained datasets should be stored gets set:

```R
set_dir("/home/sandro/Desktop/ESRIDownload")
```

### Setting an AOI

Since in this example, only datasets which contain features in Germany should be considered, a project-wide aoi can be set. Therefore, a shapefile containing a bounding box of Germany is loaded into R and assigned to the esriOpenData API:

```R
bbox_shp <- readOGR("/home/sandro/Documents/EAGLE_Data/R_Projects/esriOpenData/examples/data/germany_bbox.shp")
set_aoi(bbox_shp)
```

### Searching for datasets

Having now all parameters set, Esri's Open Data Hub can be queried in order to find demography datasets within Germany:

```R
found_ds <- search_datasets(query = "Demography", aoi = TRUE)
```

### Selecting a suitable dataset

After studying the found_ds dataframe, a desired dataset can be now selected by passing the row id to the select_dataset function:

```R
selected_ds <- select_dataset(found_ds, 1)
```

### Getting the available field of a dataset

To get a better feeling for the data, the available fields can be retrieved, using:

```R
fields(selected_ds)
```

In the next step, a subset of these field names can be used to filter the dataset and eliminate unused fields.

### Loading the dataset into R

Having now selected a suitable dataset, the actual import of the data can be executed. In this example, only the numbers of young people between 18 and 29 years, stored in the field "ALTER_1" should be considered. To get only the desired fields, a vector of field names has to be specified. If the imported subset should be stored persistently on the hard drive, the parameter export should be set to TRUE.

```R
demography <- get_dataset(selected_ds, fields = c("OBJECTID", "NAME", "DES", "ALTER_1"))
```

### Visualizing the data

Now the data is loaded and ready to be visualized or used in further analysis.
```R
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
```

### Download full dataset

The whole selected dataset can be also downloaded directly to the specified output directory. Supported datatypes are .shp, .kml and .csv :
```R
download_full_dataset(selected_ds, format = "kml")
```
