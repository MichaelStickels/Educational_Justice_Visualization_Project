library(ggplot2)
library(ggmap)
library(tidyverse)
library(mapproj)



# Load datasets
cwift_data <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_State.csv")

state_codes <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/FIPS_State_Codes.csv")


# Manipulate and extract data
cwift_state <- cwift_data %>%
  mutate(region = tolower(ST_NAME)) %>%
  select(region, ST_CWIFTEST)


# Define a minimalist theme for maps
blank_theme <- theme_bw() +
  theme(
    axis.line = element_blank(),        # remove axis lines
    axis.text = element_blank(),        # remove axis labels
    axis.ticks = element_blank(),       # remove axis ticks
    axis.title = element_blank(),       # remove axis titles
    plot.background = element_blank(),  # remove gray background
    panel.grid.major = element_blank(), # remove major grid lines
    panel.grid.minor = element_blank(), # remove minor grid lines
    panel.border = element_blank()      # remove border around plot
  )


# Load a shapefile of U.S. states using ggplot's `map_data()` function
state_shape <- map_data("state") %>%
  left_join(cwift_state, by = "region")

# Create a blank map of U.S. states
ggplot(state_shape) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = ST_CWIFTEST),
    color = "white", # show state outlines
    size = .1        # thinly stroked
  ) +
  coord_map() + # use a map-based coordinate system
  scale_fill_continuous(low = "gray57", high = "Blue") +
  labs(fill = "CWIFT") +
  blank_theme # variable containing map styles (defined in next code snippet)
