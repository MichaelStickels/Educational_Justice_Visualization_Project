# Create a chart that answers the question: "How do poverty levels impact environmental education attitudes?"
library(stringr)

# Load in data 
poverty_estimates <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/School%20Neighborhood%20Poverty%20Estimates%20(2015-2016)/EDGE_SIDE1216_PUBSCHS1516.csv",
                              encoding = "UTF-8")

states_p1 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/sc091aai.csv")

states_p2 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/sc091akn.csv")

states_p3 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/sc091aow.csv")

# Aggregate and mutate Yale data to get attitudes and combine with Economic/CWIFT data 

poverty_estimates$NAME = toupper(str_trim(poverty_estimates$NAME))
