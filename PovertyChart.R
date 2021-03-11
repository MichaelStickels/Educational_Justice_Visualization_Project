# Create a chart that answers the question: "How do poverty levels impact attitudes toward environmental education?"
library(stringr)
library(patchwork)
library(mapproj)

# Load in data 
YaleData <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

poverty_estimates <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/ec10209f8db8f63feff6991ed33e6a2a356a9fef/NCES%20Poverty%20Levels.csv",
                              encoding = "UTF-8")

states_p1 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/sc091aai.csv", encoding = "UTF-8")

states_p2 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/sc091akn.csv", encoding = "UTF-8")

states_p3 <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/sc091aow.csv", encoding = "UTF-8")

# Aggregate and mutate Yale data to get attitudes and combine with Economic/CWIFT data 

poverty_estimates_new <- as.data.frame(sapply(poverty_estimates, toupper))

states_1 <- states_p1 %>%
  select(Code = ncessch, NAME = schnam09, State = mstate09)

states_2 <- states_p2 %>%
  select(Code = ncessch, NAME = schnam09, State = mstate09)

states_3 <- states_p3 %>%
  select(Code = ncessch, NAME = schnam09, State = mstate09)

poverty_data <- poverty_estimates_new %>%
  select(Code = NCESSCH, NAME, IPR_EST, IPR_SE)

states_1_2 <- rbind(states_1, states_2)

states_full <- rbind(states_1_2, states_3)

# Final data frames with state names and IPR 
poverty_data_full <-left_join(poverty_data, states_full, by = "NAME")

yale_by_state <- YaleData %>%
  filter(GeoType == "State") %>%
  group_by(GeoName) 

yale_by_state$GeoName <- state.abb[match(yale_by_state$GeoName, state.name)]

# Find the average IPR_EST in each state using the poverty data 
average_ipr <- poverty_data_full %>%
  group_by(State) %>%
  mutate(IPR_AVG = mean(as.numeric(IPR_EST, na.rm = T))) %>%
  select(region = State, IPR_AVG) %>%
  distinct(State, IPR_AVG)

code_state <- state_codes %>% 
  select(region = state_abbreviation, state_code, state)

# Create an interactive map chart that displays IPR by state 
join_ipr_codes <- left_join(average_ipr, code_state, by = "region")

join_ipr_codes$state = tolower(join_ipr_codes$state)

maps_totals_data <- join_ipr_codes %>%
  select(IPR_AVG, abbrev = region, state_code, region = state)

map_shape_ipr <- map_data("state") %>%
  left_join(maps_totals_data, by = "region")

# Define a minimalist theme 
map_theme <- theme_bw() +
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(), 
    axis.title = element_blank(),
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank()
  )

# Map chart displaying average IPR in each state 
output$plot <- renderPlot({
  
  map_chart_ipr <- ggplot(data = map_shape_ipr) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = IPR_AVG),
    color = "purple",
    size = .3
  ) +
  coord_map() +
  scale_fill_continuous(low = "thistle1", high = "purple4") + 
  labs(fill = "Average IPR") +
  map_theme +
  ggtitle("Average Income-to-Poverty Ratio (IPR) by State")

return(map_chart_ipr)

})


# Create an interactive map chart that displays different attitudes by state 
yale_map_data <- yale_by_state %>%
  select(region = GeoName, TotalPop, discuss, reducetax, CO2limits, localofficials, congress, 
         president, corporations, citizens, regulate, supportRPS, drilloffshore, drillANWR, 
         fundrenewables, gwvoteimp, teachGW, happening, worried)

join_yale_codes <- left_join(yale_map_data, code_state, by = "region")

join_yale_codes$state = tolower(join_yale_codes$state)

maps_totals_data <- join_yale_codes %>%
  select(abbrev = region, state_code, TotalPop, Support_Discussions = discuss, 
         Support_Tax_Reductions = reducetax, Support_CO2_Limits = CO2limits, 
         Support_Local_Officials = localofficials, Support_Congress = congress, 
         Support_President = president, Support_Corporations = corporations, 
         Support_Regulations = regulate, Support_Renewable_Standards = supportRPS, 
         Support_Offshore_Drilling = drilloffshore, Support_Arctic_Drilling = drillANWR, 
         Support_Funding_Renewables = fundrenewables, See_Global_Warming_as_Priority = gwvoteimp, 
         Support_Teaching_Global_Warming = teachGW, Agree_Climate_Change_is_Happening = happening, 
         Worried_About_Global_Warming = worried, region = state)

map_shape_type <- map_data("state") %>%
  left_join(maps_totals_data, by = "region")

# Map chart displaying average IPR in each state 
output$types_plot <- renderPlot({
  
  map_chart_types <- ggplot(data = map_shape_type) +
    geom_polygon(
      mapping = aes(x = long, y = lat, group = group, fill = Support_Regulations),
      color = "purple",
      size = .3
    ) +
    coord_map() +
    scale_fill_continuous(low = "lightgoldenrodyellow", high = "blue4") + 
    labs(fill = "% Support") +
    map_theme +
    ggtitle("Percentage of People Who Support ")
  
  return(map_chart_types)
  
})

# Input for UI 
map_chart_layout <- sidebarLayout(
  sidebarPanel(
    selectInput(
      input = type,
      label = "Choose an Aspect of Environmental Education",
      choices = c(Support_Discussions, 
                  Support_Tax_Reductions, Support_CO2_Limits, 
                  Support_Local_Officials, Support_Congress, 
                  Support_President, Support_Corporations, 
                  Support_Regulations, Support_Renewable_Standards, 
                  Support_Offshore_Drilling, Support_Arctic_Drilling, 
                  Support_Funding_Renewables, See_Global_Warming_as_Priority, 
                  Support_Teaching_Global_Warming, Agree_Climate_Change_is_Happening, 
                  Worried_About_Global_Warming)
    )
  ),
  mainPanel(plotOutput(outputId = "types_plot"))
)






  

