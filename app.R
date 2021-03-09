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

library(rsconnect)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)

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
    p("Climate education in the United States is not well measured because of its
      apparent political controversy. In these charts we compare the support for 
      climate education in schools to other environmental policies to visualize
      the priority of climate education within climate policy.",
      style = "font-size:20px;"),
    
)


page_three <- tabPanel( #chart 2 
    "Poverty/Attitudes",
        titlePanel("chart 2 page"),
    h1("How do poverty levels impact attitudes toward environmental education?")
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

    output$distPlot <- renderPlot({
       
        
        
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
