# File to calculate summary information about our dataframes

# Load in libraries
library(stringr)
library(tidyr)
library(dplyr)

# Load in tables
neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")

economic <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20(Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")

comparablewageindex <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.csv")

yaledata <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

# Function that takes in dataset and returns a list of info about it
summary_info <- list()

# Calculate number of counties in the Comparable Wage Index for Teachers
total_counties <- nrow(comparablewageindex)

# Calculate number of neighborhoods in neighborhoods
num_neighborhoods <- nrow(neighborhoods)

# Calculate number of school districts in economic
num_school_districts <- nrow(economic)

# Calculate number of columns and rows in Yale Data
num_locations <- nrow(yaledata)

# Calculate the mean amount of people who support CO2 emission limits
support_co2_limits <- sprintf("%0.1f%%", yaledata %>%
  summarize(CO2limits = mean(CO2limits)) %>%
  pull(CO2limits))

# Calculate the average amount of citizens that want there to be
# education for global warming in schools
for_global_warming_edu <- sprintf("%0.1f%%", yaledata %>%
  summarize(teachGW = mean(teachGW)) %>%
  pull(teachGW))

# Calculate neighborhood with lowest poverty ratio
max_pov_neighborhood <- neighborhoods %>%
  filter(IPR_EST == max(IPR_EST)) %>%
  head(1) %>%
  pull(IPR_EST)

# Calculate neighborhood with highest poverty ratio
min_pov_neighborhood <- neighborhoods %>%
  filter(IPR_EST == min(IPR_EST)) %>%
  pull(IPR_EST)

# Calculate mean poverty rate of neighborhoods
mean_pov_rate <- neighborhoods %>%
  summarize(IPR_EST = mean(IPR_EST)) %>%
  pull(IPR_EST)

# Calculate average Comparable Wage Index for Teachers
mean_comp_wage <- comparablewageindex %>%
  summarize(CNTY_CWIFTEST = mean(CNTY_CWIFTEST)) %>%
  pull(CNTY_CWIFTEST)
