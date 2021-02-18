library(ggplot2)
library(ggmap)
library(tidyverse)


# Load datasets
census_data <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20(Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")

state_codes <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/FIPS_State_Codes.csv")


# Manipulate and extract data
joined_census_data <- census_data %>%
  select(GeoId, Geography, )
  mutate(state_code = as.integer(substr(GeoId, 8, 9))) %>%
  left_join(state_codes, by = "state_code")





# Load a shapefile of U.S. states using ggplot's `map_data()` function
state_shape <- map_data("state")

# Create a blank map of U.S. states
  ggplot(state_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group),
    color = "white", # show state outlines
    size = .1        # thinly stroked
  ) +
  coord_map() # use a map-based coordinate system
  
  