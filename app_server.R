#
#   App server
#
#   Educational Justice and the Environment
#


source("app_data-prep.R")


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # [_____] Plot
  output$policy_plot <-  renderPlotly({ 
    
    US_climate_opinion <- US_climate_opinion [-c(1,53:4563), ] 
    
    US_climate_opinion <- select(US_climate_opinion, GeoName, fundrenewables,
                                 regulate, reducetax, drilloffshore, teachGW, )
    
    colnames(US_climate_opinion) <- c("State", "Funding Research for Renewable Energy", 
                                      "Regulating CO2", "Carbon Tax", 
                                      "Offshore Drilling", "Teaching Global Warming")
    
    # chart1_radio 
    
    if(input$chart1_radio == 1){
      US_climate_opinion <- US_climate_opinion 
    }
    if (input$chart1_radio == 2){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Carbon Tax")
    }
    if (input$chart1_radio == 3){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Funding Research for Renewable Energy")
    }
    if (input$chart1_radio == 4){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Offshore Drilling")
    }
    if (input$chart1_radio == 5){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Regulating CO2")
    }
    
    climate_policy_support <- gather(US_climate_opinion, key = policy, value = percent,
                                     -State)
    #plot climate support data
    psp <- ggplot(data = climate_policy_support, aes(x = State, 
                                                     y = percent, color = policy)) + 
      geom_line(aes(group  =  policy)) +
      scale_colour_brewer(palette = "Dark2") +
      theme(axis.text.x = element_text(angle = 90)) +
      labs(
        title= "Climate Policy Support, by State",
        x = "State",
        y = "Estimated Percentage of Support")
    
    policy_support_plot <- ggplotly(psp)
    policy_support_plot 
  })
  
  
  # [_____] Plot
  # output$....
  
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
  
  
  
  # Poverty Climate Attitudes Plot
  # output$....
  
}



url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)
fig <- plot_ly() 
fig <- fig %>% add_trace(
  type="choroplethmapbox",
  geojson=counties,
  locations=funding_chart_data$FIPS,
  z=funding_chart_data$ppspend,
  colorscale="Viridis",
  #zmin=0,
  #zmax=12,
  marker=list(line=list(
    width=0),
    opacity=0.5
  )
)
fig <- fig %>% layout(
  mapbox=list(
    style="carto-positron",
    zoom =2,
    center=list(lon= -95.71, lat=37.09))
)
fig

