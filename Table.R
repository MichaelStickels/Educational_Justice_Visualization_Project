# A table of aggregate information regarding the comparable wages of teachers 
# in specific neighborhoods, school districts, and states. 

# Load in data frames 
Neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")

Economic <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20(Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")

ComparableWageIndex <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.csv")

YaleData <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project
  /main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

# Aggregated table of Yale Climate Data and create a table with the percentage of citizens who 
# support certain topics 
by_location <- YaleData %>%
  group_by(GeoType)

# Create a table using Yale Climate Opinion dataframe 
Climate_Education <- YaleData %>%
  select(
    Location_Type = GeoType, 
    Location = GeoName, 
    Population = TotalPop, 
    Support_Tax_Reduction = reducetax, 
    Reduce_CO2_limits = CO2limits,
    Support_Local_Officials = localofficials, 
    Support_Governor = governor, 
    Support_Congress = congress, 
    Support_President = president,
    Support_Corporations = corporations, 
    Support_regulating_emissions = regulate, 
    Support_Offshore_Drilling = drilloffshore, 
    Support_Global_warming_edu = teachGW,
    Worried_for_Future = worried
  ) %>%
  arrange(Location)

# Group CWI dataframe by state 
CWI_by_state <- ComparableWageIndex %>%
  group_by(ST_NAME)

# Create aggregate table using Comparable Wage Index data 
CWIAgg = aggregate(ComparableWageIndex, by = list(State = ComparableWageIndex$ST_NAME, 
  Average.CWIFT = ComparableWageIndex$CNTY_CWIFTEST),
  FUN = mean) 

# Neighborhoods dataframe grouped by neighborhoods 
by_neighborhood <- Neighborhoods %>%
  group_by(NAME)

# Create aggregate table using Neighborhoods data and mean IPR
NeighborhoodAgg = aggregate(Neighborhoods, by = list(School = Neighborhoods$NAME, 
  Average.Poverty = Neighborhoods$IPR_EST),
  FUN = mean) 

# Economic dataframe grouped by school districts 
by_district <- Economic %>%
  group_by(Geography)

# Create aggregate table using Economic data 
EconAgg = aggregate(Economic, by = list(District = Economic$Geography, 
  Year = Economic$Year, CDP = Economic$CDP03_1moe),
  FUN = mean)








