## Nathaniel Flemming 6/3/23
# Uses merged incorporation/crosswalk file to look at county level fragmentation over time

#set directory
setwd('C:/Users/natha/OneDrive/Documents/GitHub/muni-incorporation/rawdata')

#tidyverse to read in files and convenience
library(tidyverse)

#read in merged data file
muni_incorporation_date<-read.csv('muni_incorporation_date.csv')

#sum incorporations in each county in each year
county_incorporation<-
  muni_incorporation_date %>%
  group_by(stateabb, countyname, yr_incorp) %>% #group by state, county name and year of incorporation
  tally()%>% #tally up number of observations in each group
  ungroup()

#create variable that indicates year to year growth in incorporations
county_incorporation <-
  county_incorporation %>%
  group_by(stateabb, countyname)%>%#group by state, county name
  mutate(current_munis = cumsum(n), #cumulative total of municipalities
         total_munis = sum(n),#total municipalities over all time
         chng_munis = current_munis - lag(current_munis)) %>% # change in number of munis year to year
  ungroup() 

# plot number of incorporations over time