####Title: Bulk Download Approach 
####Author: Grant A. Allard and Marcos Segantini 
####Date: 

#Visualizations 
#Show NZ has more patents than UY in number. 
#Linkage between patents and institutions. 

#Visualization for next week: 
#Map patents, inventors to Uruguay and NZ -Monday or Tuesday


library(dplyr)
library(stringr)
library(readr)
require(tidyr)
require(ggplot2)

#Session Info
sessionInfo()

#Assignees####
#Load in Assignee Data
assignee_file<-"/Users/GrantAllard/Documents/Allard Scholarship/Southern Settlers/Data/SouthernSettlers/Data/Assignee/20180528/bulk-downloads/assignee.tsv"
assignee_raw<-read_tsv(assignee_file, col_names=TRUE)

#Check Data
str(assignee_raw)
assignee_raw_backup<-assignee_raw

#Create DataFrame
assignee_df<-as_data_frame(assignee_raw) %>% 
  drop_na(id)

#Add character vectors for missing data
assignee_df[is.na(assignee_df$name_first),"name_first"]<-"Not Applicable"
assignee_df[is.na(assignee_df$name_last),"name_last"]<-"Not Applicable"
assignee_df[is.na(assignee_df$organization),"organization"]<-"Not Applicable"

#Need to find out what "type" means. 
#classification of assignee (2 - US Company or Corporation, 3 - Foreign Company or Corporation, 4 - US Individual, 5 - Foreign Individual, 6 - US Government, 7 - Foreign Government, 8 - Country Government, 9 - State Government (US). Note: A "1" appearing before any of these codes signifies part interest)

#RecodeID to 'assignee_id'
assignee_df$assignee_id<-assignee_df$id
assignee_df$id<-NULL

#Assignee Locations
assignee_location_file<-"/Users/GrantAllard/Documents/Allard Scholarship/Southern Settlers/Data/SouthernSettlers/Data/Inventor/20180528/bulk-downloads/inventor.tsv"
assignee_location_raw<-read_tsv(assignee_location_file)

#Create df
assignee_location_df<-as_data_frame(assignee_location_raw)

#create assignee_id
assignee_location_df$location_id<-assignee_location_df$id
assignee_location_df$id<-NULL

str(assignee_df)
str(assignee_location_df)


#Inventors####
inventor_file<-"/Users/GrantAllard/Documents/Allard Scholarship/Southern Settlers/Data/SouthernSettlers/Data/Inventor/20180528/bulk-downloads/inventor.tsv"
inventor_raw<-read_tsv(inventor_file, col_names=TRUE)

#Check Data
str(inventor_raw)
inventor_raw_backup<-inventor_raw

#Create DataFrame
inventor_df<-as_data_frame(inventor_raw) %>% 
  drop_na("id")

#InventorID
inventor_df$inventor_id<-inventor_df$id
inventor_df$id<-NULL

#Inventor Locations#
inventor_location_file<- "/Users/GrantAllard/Documents/Allard Scholarship/Southern Settlers/Data/SouthernSettlers/Data/Location_Inventor/20180528/bulk-downloads/location_inventor.tsv"
inventor_location_raw<-read_tsv(inventor_location_file, col_names=TRUE)

#Clean Data
inventor_location_df<-as_data_frame(inventor_location_raw)
inventor_location_df[is.na(inventor_location_df),]<-"Not Listed"

#Locations
locations_file<-"/Users/GrantAllard/Documents/Allard Scholarship/Southern Settlers/Data/SouthernSettlers/Data/Location/20180528/bulk-downloads/location.tsv"
locations_raw<-read_tsv(locations_file)

#Clean Data
locations_df<-as_data_frame(locations_raw)

locations_df$location_id<-locations_df$id
locations_df$id<-NULL

#Join Locations onto Assignee_Location 
inventor_location_df<-left_join(inventor_location_df, locations_df, by="location_id" )
head(inventor_location_df)

#Can't figure out how to tie these together. Need help on the disambiguation. 

#Patents
Patents_file<-"/Users/GrantAllard/Documents/Allard Scholarship/Southern Settlers/SouthernSettlers/Data/Patents/data/20180528/bulk-downloads/patent.tsv"
Patents_raw<-read_tsv(Patents_file)



