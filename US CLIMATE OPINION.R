install.packages("dplyr")
library(tidyr)

US_climate_opinion <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")
View(US_climate_opinion)

# Is Climate Change Happening?' by State
USCO_states <- US_climate_opinion %>% 
  filter(GeoType == "State") %>% 
  select(GeoName, happening, happeningOppose) %>% 
  gather(key = opinion, value = percentage_of_state, c(happening, happeningOppose))

HAPPENING_PLOT <- ggplot(USCO_states) +
  geom_col(mapping = aes(x = GeoName, y = percentage_of_state, fill = opinion), 
           position = "fill") +
  scale_fill_manual(values=c("olivedrab2", "red2")) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(
    title= "'Is Climate Change Happening?' by State",
    x = "State",
    y = "Estimated Percentage of State Population")
HAPPENING_PLOT

#Should We Teach Global Warming?' by State

USCO_states <- US_climate_opinion %>% 
    filter(GeoType == "State") %>% 
    select(GeoName, teachGW, teachGWOppose) %>% 
    gather(key = opinion, value = percentage_of_state, c(teachGW, teachGWOppose))
  
TEACH_PLOT <- ggplot(USCO_states) +
    geom_col(mapping = aes(x = GeoName, y = percentage_of_state, fill = opinion), 
             position = "fill") +
    scale_fill_manual(values=c("olivedrab2", "red2")) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(
    title= "'Should We Teach Global Warming?' by State",
    x = "State",
    y = "Estimated Percentage of State Population")
TEACH_PLOT
