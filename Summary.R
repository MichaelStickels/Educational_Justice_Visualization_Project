# File to calculate summary information about our dataframes  

# Load in libraries 
library(stringr)
library(tidyr)
library(dplyr)

# Load in tables 
Neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project
  /main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")
Economic <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_
  Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20
  (Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")
ComparableWageIndex <- read.delim("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_
  Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.txt")

# Function that takes in dataset and returns a list of info about it 
summary_info <- list() 

# Calculate number of counties in the Comparable Wage Index for Teachers 
summary_info$total_counties <- nrow(ComparableWageIndex)

# Calculate number of neighborhoods in Neighborhoods 
summary_info$num_neighborhoods <- nrow(Neighborhoods)

# Calculate number of school districts in Economic 
summary_info$num_school_districts <- nrow(Economic)

# Calculate neighborhood with max poverty estimate 
summary_info$max_pov_neighborhood <- Neighborhoods %>%
  filter(IPR_EST == max(IPR_EST)) %>%
  select(NAME, IPR_EST)

# Calculate mean poverty rate of Neighborhoods 
summary_info$mean_pov_rate <- Neighborhoods %>%
  summarize(IPR_EST = mean(IPR_EST)) %>%
  select(IPR_EST)




