#
#   App UI
#
#   Educational Justice and the Environment
#



source("app_data-prep.R")
source("app_server.R")



# *************** Pages *************** #



main_page <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>> Introduction page
  
  "Introduction",
  
  h1(
    strong("Inequality, Education, and the Environment"),
    style = "font-size:50px;",
    align = "center"
  ),
  
  p(
    "education and injustice funding poverty income inequality climate change
     disproportionate communities attitudes public opinion and policy
     minorities",
    style = "font-size:30px;",
    align = "center"
  ),
  
  img(
    src = 'mariamedem.jpg',
    height = 450,
    width = 600,
    style = "display: block;
       margin-left: auto; margin-right: auto;"
  ),
  
  br(),
  
  h1("Introduction to Educational Justice"),
  
  p("This project studies how inequality affects primary and secondary education
    and people's environmental beliefs. We primarily used data from the National
    Center for Education Statistics (NCES) and Yale Climate Opinion. We wanted
    to investigate these data types together to understand how the United
    States' education system may be affecting climate change opinions. Climate
    change is an environmental justice problem because low-income and minority
    communities will be most vulnerable to its effects. To ensure communities
    are prepared for the oncoming effects of climate change we must further
    analyze what is affecting public opinion on the problem, which is why we
    chose to investigate education data. Through our analysis we hope to further
    our understanding of the complexities behind climate opinions and prompt
    further discussion on changing environmental education.", 
    style = "font-size:25px;"),
  
  br(),
  
  p("In this report, we want to answer the following questions:", 
    style = "font-size:25px;"),
  
  h2(
    "How do environmental attitudes indicate the effects of environmental
      education?",
    style = "font-size:25px;"
  ),
  
  p("Comparing data from Yale Climate Opinion Maps", style = "font-size:20px;"),
  
  br(),
  
  h3(
    "How do poverty levels impact attitudes toward environmental education and regulations?",
    style = "font-size:25px;"
  ),
  
  p(
    "Comparing data from National Center for Education Statistics (NCES) and
     Yale Climate Opinion Maps",
    style = "font-size:20px;"
  ),
  
  br(),
  
  h4("How does school funding impact environmental education?",
     style = "font-size:25px;"),
  
  p(
    "Comparing data from Comparable Wage Index for Teachers (CWIFT) and Yale
     Climate Opinion Maps",
    style = "font-size:20px;"
  ),
  
  br()
  
)




page_one <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>> Chart 1
  
  "Education/Attitudes",
  
  titlePanel("chart 1 page"),
  
  h1("Is environmental education a popular public opinion?"),
  
  p(
    "In this chart we compare the support for climate education in schools to
     other environmental policies to visualize the priority of climate education
     within American public opinion on climate policy. When you look at the
    chart, the state at the top provides the least funding per student and the
    following states are ordered based on this, so the last state provides the
    most funding per student. You may select any of the individual policies to
    compare how public opinion on that policy compares to public opinion on
    teaching about global warming (climate change) in schools. You may also
    choose between viewing the trend lines and the mean lines for each policy
    based on the collective states. Finally, you may select specific states to
    get a more focused view of select state opinions on these policies.",
    style = "font-size:20px;"
  ),
  
  fluidPage(sidebarLayout(
    sidebarPanel(
      radioButtons(
        "chart1_radio",
        label = "Select Policies:",
        choices = list(
          "All" = 1,
          "Carbon Tax" = 2,
          "Funding Research for Renewable Energy" = 3,
          "Offshore Drilling" = 4,
          "Regulating CO2" = 5
        ),
        selected = 1
      ),
      
      radioButtons(
        "chart1_radio2",
        label = "Chart Options:",
        choices = list("Trend Lines" = 1, "Mean Lines" = 2),
        selected = 1
      ),
      
      pickerInput(
        "statepicker",
        label = "Select States:",
        choices = unique(states),
        options = list(`actions-box` = TRUE),
        multiple = T,
        selected = states
      )
      
    ),
    
    mainPanel(
      plotlyOutput("policy_plot", height = 800),
      
      tableOutput("state"),
      
      br(),
      
      p(
        "This plot shows the estimated percent of support for different
            environmental policies in each state. Teaching Global Warming is
            the second highest most supported policy-- only topped by
            Funding Research for Renewable Energy, and having more support
            than Regulating CO2."
      ),
      
    ),
    
  ))
  
)




page_two <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>> Chart 2
  
  "Poverty/Attitudes",
  
  mainPanel(plotOutput(outputId = "ipr_plot")),
  
  sidebarLayout(sidebarPanel(
    selectInput(
      input = "type",
      label = "Choose an Aspect of Environmental Education",
      choices = c(
        "Support_Discussions",
        "Support_Tax_Reductions",
        "Support_CO2_Limits",
        "Support_Local_Officials",
        "Support_Congress",
        "Support_President",
        "Support_Corporations",
        "Support_Regulations",
        "Support_Renewable_Standards",
        "Support_Offshore_Drilling",
        "Support_Arctic_Drilling",
        "Support_Funding_Renewables",
        "See_Global_Warming_as_Priority",
        "Support_Teaching_Global_Warming",
        "Agree_Climate_Change_is_Happening",
        "Worried_About_Global_Warming"
      )
    )
  ),
  mainPanel(plotOutput(outputId = "types_plot"))),
  
  sidebarLayout(sidebarPanel(),
                
                mainPanel(
                  plotlyOutput(outputId = "povertyclimateplot")
                  
                )),
  
  p(
    "In these charts, you can compare how a state's Income-to-Poverty Ratio
    (IPR) relates to certain attitudes toward environmental education and/or
    environmental issues. We wanted to see the correlation between attitudes
    toward environmental education and the poverty rates in each state. As you
    can see, depending on the topic/issue, attitudes are often reflective of the
    IPR in each state as they tend to stay similar when plotting different
    issues."
  ),
  
  p("These two maps allow for a comparison between poverty data and public
   support for various aspects of environmental education. The top chart,
   displays the average income-to-poverty ratio by state. The income-to-poverty
   ratio is defined as the percentage of family income that is above or below
   the federal poverty level. It ranges from 0 to 999 where lower IPR values
   indicate a higher level of poverty. This chart averages the IPR of each state
   in general, and an IPR value of 100 would represent a family with an income
   at the poverty threshold. Lighter shades on this chart would therefore
   indicate that state to be closer to poverty level."),
  
  p("The map below the first, will change based on the aspect of environmental
  education you select to view. The dark shades indicate a lighter the shade,
  the lower the percentage of support for that policy will be. The purpose of
  placing these two maps next to each is so the viewer can observe if there is a
  correlation between the IPR of the state and public opinion on environmental
  education in that state."),
  
  
)




page_three <- tabPanel(# >>>>>>>>>>>>>>>>>>>> Chart 3
  
  "Education Funding Sources by State",
  
  
  sidebarLayout(sidebarPanel(
    radioButtons(
      "funding_radio",
      label = "Order By:",
      choices = list(
        "Federal" = 1,
        "State" = 2,
        "Local" = 3
      ),
      selected = 2
    )
    
  ),
  
  mainPanel(
    plotOutput("funding_plot", height = 800),
    
    p("This stacked bar chart compares education funding per state based on the
      percentage of funding that comes from federal, state, and local sources.
      You may select the order by which you want to see each source of funding
      for ease of viewing differences between each state. The purpose of this
      chart was to determine how sources of funding differ by state. These
      differences raise the question of why states differ so much in what
      percentage of their funding comes from each source, and further analysis
      could be done on how these differences affect education practices in each
      state.")
    
  )))




page_four <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>>  Conclusion page
  
  "Conclusion",
  
  h1(
    strong("Findings: Inequality, Education, and the Environment"),
    style = "font-size:50px;",
    align = "center"
  ),
  
  br(),
  
  p("In this report, we wanted to answer:",
    style = "font-size:25px;"),
  
  h2(
    "How do environmental attitudes indicate the effects of environmental
      education?",
    style = "font-size:30px;"
  ),
  
  p("We found that abc xyz",
    style = "font-size:20px;"),
  
  br(),
  
  h3(
    "How does poverty levels impact environmental education attitudes?",
    style = "font-size:30px;"
  ),
  
  p("We found that abc xyzs",
    style = "font-size:20px;"),
  
  br(),
  
  h4("How does school funding impact environmental education?",
     style = "font-size:30px;"),
  
  p("We found that abc xyz",
    style = "font-size:20px;"),
  
  br(),
  
  h3("Data sources", style = "font-size:30px;")
  
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