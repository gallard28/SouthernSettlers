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
names(inventor_UY_NZ_df)

head(inventor_df[inventor_df$country=="NZ",])
  
#Visualize data ###

#Count of inventors per country 

country_table<-inventor_UY_NZ_df %>% 
  group_by(country) %>% 
  count()
  
country_table

#Set palette 
pal<- colorFactor(c("white","blue"), domain= c("NZ", "UY"))
  
#Sample Map
map<-leaflet(inventor_UY_NZ_df) %>% 
  addProviderTiles(providers$CartoDB.DarkMatter) %>% 
  addCircleMarkers(lng= ~longitude, lat= ~latitude, color= ~pal(country), stroke=FALSE, fillOpacity = 0.5)
map


