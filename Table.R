# A table of aggregate information regarding the comparable wages of teachers 
# in specific neighborhoods, school districts, and states. 

# Load in data frames 
Neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project
  /main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")
Economic <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_
  Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20
  (Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")
ComparableWageIndex <- read.delim("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_
  Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.txt")
YaleData <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project
  /main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

# Group CWI dataframe by state 
CWI_by_state <- ComparableWageIndex %>%
  group_by(ST_NAME)

# Create aggregate table using Comparable Wage Index data 
CWIAgg = aggregate(ComparableWageIndex, by = list(State = ComparableWageIndex$ST_NAME, 
  Average.CWIFT = ComparableWageIndex$CNTY_CWIFTEST),
  FUN = mean) 


# Create aggregate table using Neighborhoods data 

# Create aggregate table using Economic data 






