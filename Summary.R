# Load in libraries 
library(stringr)
library(tidyr)
library(readxl)

# Load in tables 
Neighborhoods <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv")
Economic <- read_excel("ACS-ED_2014-2018_RecordLayouts.xlsx")

# Function that takes in dataset and returns info about it 