####Title: Software for Pulling and Cleaning Patents Data for the Southern Settlers Project
####Author: Grant A. Allard and Marcos Segantini 
####Date: 

####Library####
library(patentsview)
library(tidyr)
library(dplyr)
library(httr)
library(jsonlite)
library(utils)


#Practice from https://ropensci.org/blog/2017/09/19/patentsview/ ####
library(patentsview)

# Write a query:
query <- with_qfuns( # with_qfuns is basically just: with(qry_funs, ...)
  and(
    begins(cpc_subgroup_id = 'H04L63/02'),
    gte(patent_year = 2007)
  )
)

# Create a list of fields:
fields <- c(
  c("patent_number", "patent_year"),
  get_fields(endpoint = "patents", groups = c("assignees", "cpcs"))
)

# Send HTTP request to API's server:
pv_res <- search_pv(query = query, fields = fields, all_pages = TRUE)

#Unnesting dataframe and creating a data object - Sample  
data <-
  pv_res$data$patents %>%
  unnest(assignees) %>%
  select(assignee_id, assignee_organization, patent_number,
         assignee_longitude, assignee_latitude) %>%
  group_by_at(vars(-matches("pat"))) %>%
  mutate(num_pats = n()) %>%
  ungroup() %>%
  select(-patent_number) %>%
  distinct() %>%
  mutate(popup = paste0("<font color='Black'>",
                        htmlEscape(assignee_organization), "<br><br>Patents:",
                        num_pats, "</font>")) %>%
  mutate_at(vars(matches("_l")), as.numeric) %>%
  filter(!is.na(assignee_id))
#End Practice###


#Code for pulloing data ####
library(patentsview)

# Write a query:
query <- with_qfuns( # with_qfuns is basically just: with(qry_funs, ...)
  and(
    contains( = 'US'),
    gte(patent_year = 2017)
  )
)

query <- with_qfuns( # with_qfuns is basically just: with(qry_funs, ...)
  and(
    begins(cpc_subgroup_id = 'H04L63/02'),
    gte(patent_year = 2007)
  )
)


# Create a list of fields:
fields <- c(
  c("patent_number", "patent_year"),
  get_fields(endpoint = "patents"))
fields

# Send HTTP request to API's server:
pv_res <- search_pv(query = query, fields = fields, all_pages = TRUE)

#Unnesting dataframe and creating a data object - Sample  
data <-
  pv_res$data$patents %>%
  unnest(assignees) %>%
  select(assignee_id, assignee_organization, patent_number,
         assignee_longitude, assignee_latitude)


group_by_at(vars(-matches("pat"))) %>%
  mutate(num_pats = n()) %>%
  ungroup() %>%
  select(-patent_number) %>%
  distinct() %>%
  mutate(popup = paste0("<font color='Black'>",
                        htmlEscape(assignee_organization), "<br><br>Patents:",
                        num_pats, "</font>")) %>%
  mutate_at(vars(matches("_l")), as.numeric) %>%
  filter(!is.na(assignee_id))
#End Practice###






####Pull Request: US####
USSearch<-'{"_eq":{"inventor_lastknown_country": US}}'
USSearch<- qry_funs$contains(inventor_lastknown_country= "US")

US_JSON<-search_pv(USSearch, fields=get_fields(endpoint="inventors"))
US<-fromJSON(US_JSON)







data <-
  pv_res$data$patents %>%
  unnest(assignees) %>%
  select(assignee_id, assignee_organization, patent_number,
         assignee_longitude, assignee_latitude) %>%
  group_by_at(vars(-matches("pat"))) %>%
  mutate(num_pats = n()) %>%
  ungroup() %>%
  select(-patent_number) %>%
  distinct() %>%
  mutate(popup = paste0("<font color='Black'>",
                        htmlEscape(assignee_organization), "<br><br>Patents:",
                        num_pats, "</font>")) %>%
  mutate_at(vars(matches("_l")), as.numeric) %>%
  filter(!is.na(assignee_id))

#Map data  
leaflet(data) %>%
  addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%
  addCircleMarkers(lng = ~assignee_longitude, lat = ~assignee_latitude,
                   popup = ~popup, ~sqrt(num_pats), color = "yellow")



####Title: Bulk Download Approach 
####Author: Grant A. Allard and Marcos Segantini 
####Date: 


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
assignee_location_df<-left_join(assignee_location_df, locations_df, by="location_id" )


#Can't figure out how to tie these together. Need help on the disambiguation. 

