## Nathaniel Flemming 4/3/23
# Adds crosswalk information to municipality file

#set directory
setwd('C:/Users/natha/OneDrive/Documents/GitHub/muni-incorporation/rawdata')

#tidyverse to read in files and convenience
library(tidyverse)

#read in municipal incorporation data
muni_incorporation<-readxl::read_xlsx('muni-incorporation.xlsx')

#read in crosswalk file
fips_crosswalk<-readxl::read_xlsx('fips_crosswalk.xlsx')

#rename crosswalk variables
fips_crosswalk <- fips_crosswalk %>%
  rename(census_id = `Census ID Number`,
         muniname = Name,
         statefips = `FIPS State Numeric Code`,
         statecode = `Census State Numeric Code`,
         statename = `State Name`,
         stateabb = `Official USPS Code` ,
         countyfips = `FIPS County Numeric Code`,
         countycode = `Census County Numeric Code`,
         countyname = `County Name`,
         placefips = `FIPS Place Numeric Code`,
         unitcode = `Census Unit Numeric Code`,
         govtype = `Census Govt Type Code`,
         lat = `Latitude (GNIS)`,
         lon = `Longitude (GNIS)`)

# merge dataframes and save as csv
muni_incorporation_date<-left_join(muni_incorporation, fips_crosswalk, by='census_id')

write.csv(muni_incorporation_date, 'muni_incorporation_date.csv')
