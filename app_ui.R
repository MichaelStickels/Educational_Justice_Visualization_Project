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

  img(
    src = "mariamedem.jpg",
    height = 450,
    width = 600,
    style = "display: block;
       margin-left: auto; margin-right: auto;"
  ),

  br(),

  div(
    class = "box",

    h1("Introduction to Educational Justice"),

    p(
      "This project studies how inequality affects primary and secondary
      education and people's environmental beliefs. We primarily used data from
      the National Center for Education Statistics (NCES) and Yale Climate
      Opinion. We wanted to investigate these data types together to understand
      how the United States' education system may be affecting climate change
      opinions. Climate change is an environmental justice problem because
      low-income and minority communities will be most vulnerable to its
      effects. To ensure communities are prepared for the oncoming effects of
      climate change we must further analyze what is affecting public opinion
      on the problem, which is why we chose to investigate education data.
      Through our analysis we hope to further our understanding of the
      complexities behind climate opinions and prompt further discussion on
      changing environmental education."
    ),

    br(),

    h2("In this report, we want to answer the following questions:"),

    HTML(
      "

      <ul>
      <li>Is environmental education a popular public opinion?</li>
      <li>How do state poverty levels impact environmental
      education attitudes?</li>
      <li>How does public education differ between states?</li>
      </ul>

    "
    ),
  ),

  br(),

  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
)




page_one <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>> Chart 1

  "Policy Support",

  h1("Is Environmental Education a Popular Public Opinion?"),

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
    get a more focused view on select state opinions on these policies."
  ),

  br(),

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

      br()
    ),
  ), )
)






page_two <- tabPanel(# >>>>>>>>>>>>>>>>>>>> Chart 2

  "Poverty/Attitudes",

  div(
    class = "centered",

    h1(
      "How do Poverty Levels Impact Attitudes Toward Environmental Education
      and Issues?"
    ),

    mainPanel(
      class = "column8",

      fluidRow(
        column(6, plotOutput(outputId = "ipr_plot")),
        column(
          6,
          plotOutput(outputId = "types_plot")
        )
      ),

      fluidRow(
        column(6),
        column(
          6,
          selectInput(
            input = "type",
            label = "Choose an Aspect of Environmental Education",
            choices = c(
              "Support Consistently Discussing Global Warming"
              = "Support_Discussions",
              "Support Increasing Fossil Fuel Taxes"
              = "Support_Tax_Reductions",
              "Support Limiting CO2 Production"
              = "Support_CO2_Limits",
              "Support Local Officials Doing More to Address Global
                     Warming" = "Support_Local_Officials",
              "Support Congress Doing More to Address Global Warming"
              = "Support_Congress",
              "Support the President Doing More to Address Global
                     Warming" = "Support_President",
              "Support Corporations Doing More to Address Global Warming"
              = "Support_Corporations",
              "Support Regulating CO2 as a Pollutant"
              = "Support_Regulations",
              "Support Requiring Utilities to Produce Electricity from
                     20% Renewable Resources" = "Support_Renewable_Standards",
              "Support Expanding Offshore Drilling for Oil & Natural Gas"
              = "Support_Offshore_Drilling",
              "Support Drilling for Oil in the Arctic National Wildlife
                     Refuge" = "Support_Arctic_Drilling",
              "Support Increasing Funding for Renewable Energy Sources"
              = "Support_Funding_Renewables",
              "Support Global Warming as a High Priority for the
                     President & Congress" = "See_Global_Warming_as_Priority",
              "Support Teaching About the Causes and Potential Solutions
                     for Global Warming in Schools"
              = "Support_Teaching_Global_Warming",
              "Think that Global Warming is Happening"
              = "Agree_Climate_Change_is_Happening",
              "Are Somewhat/Very Worried about Global Warming"
              = "Worried_About_Global_Warming"
            )
          )
        ),
      ),

      br(),

      fluidRow(
        class = "margin",
        p(
          "In these charts, you can compare how a state's Income-to-Poverty
          Ratio (IPR) relates to certain attitudes toward environmental
          education and/or environmental issues. We wanted to see the
          correlation between attitudes toward environmental education and the
          poverty rates in each state. As you can see, depending on the
          topic/issue, attitudes are often reflective of the IPR in each state
          as they tend to stay similar when plotting different issues."
        ),

        p(
          "The chart on the left displays the average IPR by state. The IPR is
      defined as the percentage of family income that is above or below the
      federal poverty level. It ranges from 0 to 999 where lower IPR values
      indicate a higher level of poverty. This chart shows the average IPR of
      each state. An IPR value of 100 would represent a family with an
          income at the poverty threshold."
        ),

        p(
          "The map to the right will change based on the specific aspect of
      environmental education you select to view. Darker shades indicate
      higher support and lighter shades indicate a lower percentage of
      support for the policy. The purpose of placing these two maps next to
      each other is so the viewer can observe if there exists a correlation
      between the IPR of the state and public opinion on a specific
          environmental concern."
        )
      )
    )
  )
)




page_three <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>> Chart 3

  "Education Funding Sources by State",


  sidebarLayout(
    sidebarPanel(
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

      br(),

      p(
        "This stacked bar chart compares education funding per state based on
        the percentage of funding that comes from federal, state, and local
        sources. You may select the order by which you want to see each source
        of funding for ease of viewing differences between each state. The
        purpose of this chart was to determine how sources of funding differ by
        state. These differences raise the question of why states differ so much
        in what percentage of their funding comes from each source, and further
        analysis could be done on how these differences affect education
        practices in each state."
      ),

      br()
    )
  ),



  br(),
  br(),

  sidebarLayout(
    sidebarPanel(switchInput(
      inputId = "switch",
      label = "Adjusted",
      value = F
    )),

    mainPanel(
      plotlyOutput("funding_comparison_plot", height = 800),

      br(),

      p(
        "This chart displays the total funding per student by state. They are
      displayed in two colors for ease of viewing so one can distinguish between
      various states more easily. The chart is ordered by funding per student,
      so the state with the lowest funding per student is at the top, and the
      state with the highest funding per student is at the bottom (it maintains
      the same order when switched to adjusted for ease of viewing). You can
      choose to adjust the chart by the Comparable Wage Index for Teachers, a
      cost index which adjusts the values based the average cost of living for
      that state, which may give a more accurate picture of public school
      spending."
      ),

      br()
    )
  )
)




page_four <- tabPanel(
  # >>>>>>>>>>>>>>>>>>>>  Conclusion page

  "Conclusion",

  div(
    class = "box",

    h1(
      strong("Findings: Inequality, Education, and the Environment"),
      align = "center"
    ),

    br(),

    h3("In this report, we wanted to answer:"),

    h2("Is environmental education a popular public opinion?"),

    p(
      "We found that compared to other environmental policies, teaching global
    warming/climate change in schools was the second most supported policy,
    which shows that it is overall a popular public opinion. This implies that
    the education system may play a substantial role in American climate belief,
    which leads us to consider how school funding is related to public support
    of climate education."
    ),

    br(),

    p(
      "Generally, the more school funding a state has, the more support there is
    for climate education and other positive climate policies (Regulating CO2,
    imposing carbon tax, researching renewable energy). Predictably, having more
    school funding correlated with reduced support for policies that negatively
    impact the climate (drilling). On the other hand, having less school funding
    correlated with states showing more support for policies that negatively
    impact the climate."
    ),

    br(),

    p(
      paste(
        "In conclusion, teaching global warming/climate change in schools is in
        fact a highly supported policy across the U.S., with the average
        percentage of support being ",
        avg_pct_teaching_support,
        ", and school
        funding tends to help that support. However, schools with less funding
        tend to be the most supportive of negative climate policy and less
        supportive of positive climate policy, implying that school funding and
        climate education can have an effect on climate belief. In order for the
        U.S. to make positive progress on climate change, they must address
        inequality in their educational system.",
        sep = ""
      )
    ),

    tableOutput(clim_op_table),

    br(),

    h2(
      "How do state poverty levels impact environmental education attitudes?"
    ),

    p(
      paste(
        "We found that the average IPR in each state tended to correlate with
        public opinion on environmental issues when compared across the country.
        An example of this correlation between IPR and climate policy support is
        that states with lower IPR averages tended to demonstrate stronger
        support for offshore drilling (a negative climate policy), while states
        with a relatively high IPR average tended to show stronger support for
        teaching more about global warming in schools (a positive
        climate policy). These differences in support indicate that the level
        of income/poverty in a state has the ability to contribute to a person's
        political opinions as seen through the differences in opinions by state
        in the two charts. For reference, the state with the lowest IPR was ",
        state_ipr_lowest,
        ", and the state with the highest IPR was ",
        state_ipr_highest,
        sep = ""
      )
    ),

    br(),

    h2("How does public education differ between states?"),

    p(
      paste(
        "We found that based on which state you are in, you may be receiving
            a vastly different education than you would in another state. Each
            state had   very different sources of funding, based on percentage
            of funding coming  from federal, state, and local sources. There was
            also a large difference in  funding per student by state where some
            states were paying more than double   per student than another state
            even when you adjust for differences in cost   by state. We found
            that the state with the lowest funding per student was ",
        state_lowest_school_fund,
        " with $",
        lowest_school_fund,
        " per student total funding, and the state with the highest funding
            per   student was ",
        state_highest_school_fund,
        " with $",
        highest_school_fund,
        " per student total funding. That is a
            difference of ",
        fund_difference,
        "x. These differences in funding
            indicate that even within the same country, students are likely
            receiving a   very different education.",
        sep = ""
      )
    ),

    br(),

    h2("Data sources"),

    HTML(
      "

          <a href=\"https://nces.ed.gov/programs/edge/Home\">
          National Center for Education Statistics</a>
          <a href=\"https://climatecommunication.yale.edu/visualizations-data/yc
          om-us/\">Yale Program on Climate Change Communication</a>
          <a href=\"https://www.census.gov/programs-surveys/school-finances.html
          \">US Census Bureau Annual Survey of School System Finances</a>

         "
    )
  )
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
