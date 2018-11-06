####Title: Spatial Analysis
####Author: Grant A. Allard and Marcos Segantini 
####Date: 


#Libraries
library(dplyr)
library(stringr)
library(readr)
require(tidyr)
require(ggplot2)
library(leaflet)

#Load Data
load('inventor_df.RData')


#subset data for NZ and UY
inventor_UY_NZ_df<-inventor_df[inventor_df$country=="UY" | inventor_df$country=="NZ",]

  
#Visualize UY
leaflet(inventor_UY_NZ_df) %>% 
  addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>% 
  addCircleMarkers(lng=inventor_df$longitude, lat=inventor_df$latitude, color="yellow")
