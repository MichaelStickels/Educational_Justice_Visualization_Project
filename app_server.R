#
#   App server
#
#   Educational Justice and the Environment
#

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
  
  # [_____] Plot
  # output$....
  
}
