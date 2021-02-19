library(ggplot2)
library(tidyverse)

# Load in datasets
data_cdp03 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Selected%20Economic%20Characteristics%20of%20Relevant%20Children%20Enrolled%20(Public%20and%20Private)%20(2014-2018)/CDP03_104_USSchoolDistrictAll.csv")
data_cdp02 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/CDP02%20SELECTED%20SOCIAL%20CHARACTERISTICS%20OF%20CHILDREN%20IN%20THE%20UNITED%20STATES/CDP02_105_USSchoolDistrictAll_21824157365.csv")
fips_data <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/FIPS_State_Codes.csv")

# Join and mutate data
state_join <- data_cdp02 %>%
  select(GeoId, CDP02_93pct) %>%
  mutate(state_code = as.integer(substr(GeoId, 8, 9))) %>%
  left_join(fips_data)
state_join2 <- data_cdp03 %>%
  select(GeoId, CDP03_54pct) %>%
  mutate(state_code = as.integer(substr(GeoId, 8, 9))) %>%
  left_join(fips_data)

chart_data <- state_join %>%
  left_join(state_join2) %>%
  filter(state %in% c("Washington", "Oregon", "California", "South Dakota", 
                      "Georgia", "Missouri", "Arizona", "Illinois", "New York"))

# Create a scatterplot of choice states
computer_poverty <- ggplot(data = chart_data) +
  geom_point(
    mapping = aes(x = CDP02_93pct, y = CDP03_54pct),
    color = "dodgerblue4",
    alpha = .6
  ) +
  
  # Add title and axis labels
  labs(
    title = "Percent Households with Computer versus Poverty by State", # plot title
    x = "Percentage of households with a computer", # x-axis label
    y = "Percentage of households under poverty line" # y-axis label
    
  ) +
  
  theme(plot.title = element_text(hjust = 0.5)  # center title
        )+
  
  facet_wrap(~state)

plot(computer_poverty)
