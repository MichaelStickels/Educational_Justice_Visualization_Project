#
#   App UI
#
#   Educational Justice and the Environment
#



# *************** Pages *************** #



main_page <- tabPanel( # >>>>>>>>>>>>>>>>>>>> Introduction page
  
  "Introduction",
  
  h1(strong("Inequality, Education, and the Environment"),
     style = "font-size:50px;", align = "center"),
  
  p("education and injustice funding poverty income inequality climate change
     disproportionate communities attitudes public opinion and policy
     minorities", style = "font-size:30px;", align = "center"),
  
  img(src ='mariamedem.jpg', height = 450, width = 600, style="display: block;
       margin-left: auto; margin-right: auto;"),
  
  br(),
  
  p("In this report, we want to answer:", style = "font-size:25px;"),
  
  h2("How do environmental attitudes indicate the effects of environmental
      education?", style = "font-size:30px;"),
  
  p("Comparing data from Yale Climate Opinion Maps", style = "font-size:20px;"),
  
  br(),
  
  h3("How do poverty levels impact attitudes toward environmental education and regulations?",
     style = "font-size:30px;"),
  
  p("Comparing data from National Center for Education Statistics (NCES) and
     Yale Climate Opinion Maps", style = "font-size:20px;"),
  
  br(),
  
  h4("How does school funding impact environmental education?",
     style = "font-size:30px;"),
  
  p("Comparing data from Comparable Wage Index for Teachers (CWIFT) and Yale
     Climate Opinion Maps", style = "font-size:20px;"),
  
  br()
  
)




page_one <- tabPanel( # >>>>>>>>>>>>>>>>>>>> Chart 1 
  
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
        
        radioButtons("chart1_radio", label = "Select Policies:",
                     choices = list("All" = 1, "Carbon Tax" = 2,
                                    "Funding Research for Renewable Energy" = 3,
                                    "Offshore Drilling" = 4,
                                    "Regulating CO2" = 5),
                     selected = 1),
        
        radioButtons("chart1_radio2", label = "Chart Options:",
                     choices = list("Trend Lines" = 1, "Mean Lines" = 2),
                     selected = 1),
        
        pickerInput("statepicker",
                    label = "Select States:",
                    choices = unique(climate_policy_support$State),
                    options = list(`actions-box` = TRUE), multiple = T,
                    selected = states)
        
      ),
      
      mainPanel(
        
        plotlyOutput("policy_plot", height = 800),
        
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




page_two <- tabPanel(  # >>>>>>>>>>>>>>>>>>>> Chart 2
  
  "Poverty/Attitudes",
  
  mainPanel(plotOutput(outputId = "ipr_plot")),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        input = "type",
        label = "Choose an Aspect of Environmental Education",
        choices = c("Support_Discussions", 
                    "Support_Tax_Reductions", "Support_CO2_Limits", 
                    "Support_Local_Officials", "Support_Congress", 
                    "Support_President", "Support_Corporations", 
                    "Support_Regulations", "Support_Renewable_Standards", 
                    "Support_Offshore_Drilling", "Support_Arctic_Drilling", 
                    "Support_Funding_Renewables", "See_Global_Warming_as_Priority", 
                    "Support_Teaching_Global_Warming", "Agree_Climate_Change_is_Happening", 
                    "Worried_About_Global_Warming")
      )
    ),
    mainPanel(plotOutput(outputId = "types_plot"))
  ),
  
  sidebarLayout(
    
    sidebarPanel(
      
    ),
    
    mainPanel(
plotlyOutput(outputId = "povertyclimateplot")

    )

  ),

 p("In these charts, you can compare how a state's Income-to-Poverty Ratio (IPR) relates to certain attitudes
   toward environmental education and/or environmental issues. We wanted to see the correlation between
   attitudes toward environmental education and the poverty rates in each state. As you can see, depending 
   on the topic/issue, attitudes are often reflective of the IPR in each state as they tend to stay similar
   when plotting different issues.")

)




page_three <- tabPanel( # >>>>>>>>>>>>>>>>>>>> Chart 3
  
  "Funding/Education",
  
  titlePanel("chart 3 page"),
  
)




page_four <- tabPanel( # >>>>>>>>>>>>>>>>>>>>  Conclusion page
  
  "Conclusion",
  
  titlePanel("conclusion page"),
  
  h1(strong("Findings: Inequality, Education, and the Environment"),
     style = "font-size:50px;", align = "center"),
  
  br(),
  
  p("In this report, we wanted to answer:", 
    style = "font-size:25px;"),
  
  h2("How do environmental attitudes indicate the effects of environmental
      education?", style = "font-size:30px;"),
  
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




# **************** UI **************** #



ui <- navbarPage(
  
  "Educational Justice and the Environment",
  
  main_page, 
  page_one,
  page_two,
  page_three,
  page_four
  
)