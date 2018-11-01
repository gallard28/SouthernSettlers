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
    gte(patent_year = 2010),
    eq(inventor_country = "US") #UY for Uruguay and NZ for New Zealand 
  )
)


# Create a list of fields:
fields <- c(
  c("patent_number", "patent_year"),
  get_fields(endpoint = "patents"))
fields

# Send HTTP request to API's server:
pv_res <- search_pv(query = query, fields = fields, page =1, per_page = 25)

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









