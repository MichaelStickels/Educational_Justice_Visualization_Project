# A table of aggregate information regarding the comparable wages of teachers
# in specific neighborhoods, school districts, and states.

library(dplyr)


# Load in data frames
neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")

economic <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20(Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")

comparablewageindex <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.csv")

yaledata <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")


# Aggregated table of Yale Climate Data and create a table by state with
# percentage of citizens that want to teach students about global warming and
# support limiting CO2 emissions.
education_table <- yaledata %>%
  filter(GeoType == "State") %>%
  group_by(GeoName) %>%
  filter(teachGW == max(teachGW)) %>%
  filter(CO2limits == max(CO2limits)) %>%
  select(State = GeoName, Support_Controlling_CO2_Emissions = CO2limits,
         Support_Teaching_about_Global_Warming = teachGW)
  
  
# Create a table averaging the Comparable Wage Index for Teachers by state
cwift_by_state <- comparablewageindex %>%
  group_by(ST_NAME) %>%
  mutate(CNTY_AVG = mean(CNTY_CWIFTSE)) %>%
  select(State = ST_NAME, Average_CWIFT = CNTY_AVG) %>%
  distinct(State, Average_CWIFT)
  
  
# Final table showing how the CWIFT compares to amount of environmental
#   education in each state
education_cwift_table <- left_join(education_table, cwift_by_state,
                                         by = "State") %>%
                          filter(State %in% c("Arizona", "California",
                                              "Georgia", "Illinois",
                                              "Missoury", "New York",
                                              "Oregon", "South Dakota",
                                              "Washington"))
