#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
rsconnect::setAccountInfo(name='kourbet', 
                          token='5ED136DAAAF9F899B061FF897FF42138', 
                          secret='33oE5CCd1V5B/7ZNoOdylJnYN763HjCvxZMSxing')

#packages

library(leaflet)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(plotly)

#data
US_climate_opinion <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")
# Define UI for application that draws a histogram

page_one <- tabPanel( #introduction page 
    "Introduction",
    titlePanel("introductory page"),
    
    h1(strong("Inequality, Education, and the Environment"), style = "font-size:50px;", 
       align = "center"),
    
    p("education and injustice funding poverty income inequality climate change
      disproportionate communities attitudes public opinion and policy minorities", 
      style = "font-size:30px;", 
      align = "center"),
    
    img(src ='mariamedem.jpg', height = 450, width = 600, 
        style="display: block; margin-left: auto; margin-right: auto;"),
    
    br(),
    
    p("In this report, we want to answer:", 
      style = "font-size:25px;"),
    
    h2("How do environmental attitudes indicate the effects of environmental education?", 
      style = "font-size:30px;"),
    p("Comparing data from Yale Climate Opinion Maps", 
      style = "font-size:20px;"),
    
    br(),
    
    h3("How does poverty levels impact environmental education attitudes?", 
      style = "font-size:30px;"),
    p("Comparing data from National Center for Education Statistics (NCES) and 
      Yale Climate Opinion Maps", 
      style = "font-size:20px;"),
      
    br(),
    
    h4("How does school funding impact environmental education?", 
      style = "font-size:30px;"),
    p("Comparing data from Comparable Wage Index for Teachers (CWIFT) and 
      Yale Climate Opinion Maps", 
      style = "font-size:20px;"),
    
    br()

)


page_two <- tabPanel( #chart 1 
    "Education/Attitudes",
        titlePanel("chart 1 page"),
    h1("Is environmental education a popular public opinion?"),
    p("In this chart we compare the support for climate education in schools to 
      other environmental policies to visualize the priority of climate education 
      within American public opinion on climate policy.",
      style = "font-size:20px;"),
    
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          
          radioButtons("radio", label = h3("Select policies"), 
                             choices = list("All" = 1, "Carbon Tax" = 2,
                                            "Funding Research for Renewable Energy" = 3,
                                            "Offshore Drilling" = 4, 
                                            "Regulating CO2" = 5),
                             selected = 1),
        ),
        
        mainPanel(
          plotlyOutput("policy_plot"),
          
          tableOutput("state"),
          
          br(),
          
          p("This plot shows the estimated percent of support for different
            environmental policies in each state. Teaching Global Warming is
            the second highest most supported policy-- only topped by
            Funding Research for Renewable Energy, and having more support
            than Regulating CO2."),
          
        ),
      )
    )
)
    



page_three <- tabPanel( #chart 2 
    "Poverty/Attitudes",
        titlePanel("chart 2 page"),
)    

page_four <- tabPanel( #chart 3 
    "Funding/Education",
        titlePanel("chart 3 page"),
)  

page_five <- tabPanel( #conclusion page 
    "Conclusion",
        titlePanel("conclusion page"),
    
    h1(strong("Findings: Inequality, Education, and the Environment"), style = "font-size:50px;", 
       align = "center"),
    
    br(),
    
    p("In this report, we wanted to answer:", 
      style = "font-size:25px;"),
    
    h2("How do environmental attitudes indicate the effects of environmental education?", 
       style = "font-size:30px;"),
    p("We found that abc xyz", 
      style = "font-size:20px;"),
    
    br(),
    
    h3("How does poverty levels impact environmental education attitudes?", 
       style = "font-size:30px;"),
    p("We found that abc xyzs", 
      style = "font-size:20px;"),
    
    br(),
    
    h4("How does school funding impact environmental education?", 
       style = "font-size:30px;"),
    p("We found that abc xyz", 
      style = "font-size:20px;"),
    
    br()
)   


ui <- navbarPage(
    "Environmental and Educational Justice",
    page_one, 
    page_two,
    page_three,
    page_four,
    page_five
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$policy_plot <-  renderPlotly({ 
    
    US_climate_opinion <- US_climate_opinion [-c(1,53:4563), ] 
    
    US_climate_opinion <- select(US_climate_opinion, GeoName, fundrenewables,
                               regulate, reducetax, drilloffshore, teachGW, )
  
    colnames(US_climate_opinion) <- c("State", "Funding Research for Renewable Energy", 
                                    "Regulating CO2", "Carbon Tax", 
                                    "Offshore Drilling", "Teaching Global Warming")
  
  # radio 
    
    if(input$radio == 1){
      US_climate_opinion <- US_climate_opinion 
    }
    if (input$radio == 2){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Carbon Tax")
    }
    if (input$radio == 3){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Funding Research for Renewable Energy")
    }
    if (input$radio == 4){
      US_climate_opinion <- US_climate_opinion %>% 
        select("State", "Teaching Global Warming", "Offshore Drilling")
    }
    if (input$radio == 5){
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
  
  }


# Run the application 
shinyApp(ui = ui, server = server)
