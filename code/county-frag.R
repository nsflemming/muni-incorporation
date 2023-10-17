## Nathaniel Flemming 6/3/23
# Uses merged incorporation/crosswalk file to look at county level fragmentation over time

#set directory
setwd('C:/Users/natha/OneDrive/Documents/GitHub/muni-incorporation/rawdata')

#tidyverse to read in files and convenience
library(tidyverse)
library(stringr) #string manipulation

#read in merged data file
muni_incorporation_date<-read.csv('muni_incorporation_date.csv')

#sum incorporations in each county in each year
county_incorporation<-
  muni_incorporation_date %>%
  group_by(statefips, countyfips, yr_incorp) %>% #group by state, county name and year of incorporation
  tally()%>% #tally up number of observations in each group
  ungroup()

#create variable that indicates year to year growth in incorporations
county_incorporation <-
  county_incorporation %>%
  group_by(statefips, countyfips)%>%#group by state, county name
  mutate(current_munis = cumsum(n), #cumulative total of municipalities
         total_munis = sum(n),#total municipalities over all time
         chng_munis = current_munis - lag(current_munis)) %>% # change in number of munis year to year
  ungroup()

#select out just total number of municipalities and create geoid
num_munis_county<-
  county_incorporation%>%
  select(statefips, countyfips, total_munis)%>%
  mutate(statefips = as.character(statefips),
         countyfips = as.character(countyfips))%>%
  distinct()

###### Create geoid state+county
num_munis_county$statefips<-str_pad(num_munis_county$statefips, width=2, pad = '0')
num_munis_county$countyfips<-str_pad(num_munis_county$countyfips, width=3, pad = '0')
num_munis_county$geoid = paste0(num_munis_county$statefips,num_munis_county$countyfips)

#save to csv
write.csv(num_munis_county, file='num_munis_county')

# plot number of incorporations over time