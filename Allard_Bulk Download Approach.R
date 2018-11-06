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
library(maps)

#Session Info
sessionInfo()

#Assignees####
#Load in Assignee Data
assignee_file<-"assignee.tsv"
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
assignee_location_file<-"inventor.tsv"
assignee_location_raw<-read_tsv(assignee_location_file)

#Create df
assignee_location_df<-as_data_frame(assignee_location_raw)

#create assignee_id
assignee_location_df$location_id<-assignee_location_df$id
assignee_location_df$id<-NULL

str(assignee_df)
str(assignee_location_df)


#Inventors####
inventor_file<-"inventor.tsv"
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
inventor_location_file<- "location_inventor.tsv"
inventor_location_raw<-read_tsv(inventor_location_file, col_names=TRUE)

#Clean Data
inventor_location_df<-as_data_frame(inventor_location_raw)
inventor_location_df[is.na(inventor_location_df),]<-"Not Listed"


#Locations
locations_file<-"location.tsv"
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
Patents_file<-"patent.tsv"
Patents_raw<-read_tsv(Patents_file)

names(Patents_raw)

#Data Cleaning####
#Inventor_df####
inventor_backup2_df<-inventor_df

#Add location_id to inventor_df
inventor_df<-left_join(inventor_df, inventor_location_df, by="inventor_id")

#Add location information (if needed) It is not. 
#inventor_df<-left_join(inventor_df, locations_df, by="location_id")

#Clean 'inventor_df'####
str(inventor_df)

#Convert longitude to numeric
inventor_df$longitude<-as.numeric(inventor_df$longitude)

#Find NAs on no country listed - 569,702 observations
NoCountry<-(inventor_df[is.na(inventor_df$country),])

#Remove from dataset - Keep 9,613,849 observations
inventor_df<-inventor_df[!(inventor_df$inventor_id %in% NoCountry$inventor_id & is.na(inventor_df$country)),]

#Find NAs on no last name - 5 of them  - Korean names all put into first name
NoLastName<-(inventor_df[is.na(inventor_df$name_last),])

#Find NAs - 13 cases missing both long and lat 
nrow(inventor_df[is.na(inventor_df$longitude) & is.na(inventor_df$latitude) ,])

#Number of results for uruguay - 318
nrow(inventor_df[inventor_df$country=="UY",])

#Find observations with country = UY, long, and lat - 318. We are good! 
nrow(inventor_df[inventor_df$country=="UY" & !is.na(inventor_df$longitude) & !is.na(inventor_df$latitude),])

#Number of results for New Zealand - 9,091
nrow(inventor_df[inventor_df$country=="NZ",])

#Find observations with country, long, and lat - 9,091. We are good! 
nrow(inventor_df[inventor_df$country=="NZ" & !is.na(inventor_df$longitude) & !is.na(inventor_df$latitude),])

#Save 'inventor_df'
save(inventor_df, file="inventor_df.RData")


