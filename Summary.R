# File to calculate summary information about our dataframes  

# Load in libraries 
library(stringr)
library(tidyr)
library(dplyr)

# Load in tables 
Neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")

Economic <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20(Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")

ComparableWageIndex <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.csv")

YaleData <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

# Function that takes in dataset and returns a list of info about it 
summary_info <- list() 

# Calculate number of counties in the Comparable Wage Index for Teachers 
summary_info$total_counties <- nrow(ComparableWageIndex)

# Calculate number of neighborhoods in Neighborhoods 
summary_info$num_neighborhoods <- nrow(Neighborhoods)

# Calculate number of school districts in Economic 
summary_info$num_school_districts <- nrow(Economic)

# Calculate number of columns and rows in Yale Data 
summary_info$num_locations <- nrow(YaleData)

# Calculate the mean amount of people who support CO2 emission limits 
summary_info$support_CO2_limits <- YaleData %>%
  summarize(CO2limits = mean(CO2limits)) %>%
  select(CO2limits)

# Calculate the average amount of citizens that want there to be 
# education for global warming in schools 
summary_info$for_global_warming_edu <- YaleData %>%
  summarize(teachGW = mean(teachGW)) %>%
  select(teachGW)

# Calculate neighborhood with lowest poverty ratio 
summary_info$max_pov_neighborhood <- Neighborhoods %>%
  group_by(NAME) %>%
  filter(IPR_EST == max(IPR_EST)) %>%
  pull(NAME, IPR_EST)

# Calculate neighborhood with highest poverty ratio
summary_info$min_pov_neighborhood <- Neighborhoods %>%
  filter(IPR_EST == min(IPR_EST)) %>%
  select(NAME, IPR_EST)

# Calculate mean poverty rate of Neighborhoods 
summary_info$mean_pov_rate <- Neighborhoods %>%
  summarize(IPR_EST = mean(IPR_EST)) %>%
  select(IPR_EST)

# Calculate average Comparable Wage Index for Teachers 
summary_info$mean_comp_wage <- ComparableWageIndex %>%
  summarize(CNTY_CWIFTEST = mean(CNTY_CWIFTEST)) %>%
  select(CNTY_CWIFTEST)
