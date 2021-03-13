#
#   App server and Data Handling
#
#   Educational Justice and the Environment
#



# *************** Data *************** #


# Data Load Helper Function (removes line breaks from links/paths)
read.csv3 <- function(dir, debug = TRUE) {
  read.csv(gsub("\\n *", "", dir))
}


# Load data
school_finance_data <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStick
                                 els/Educational_Justice_Visualization_Project/m
                                 ain/Data/US%20Census%202018%20school%20finance%
                                 20data/elsec18.csv"
  )

climate_op_data <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStickels/
                             Educational_Justice_Visualization_Project/main/Data
                             /Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.cs
                             v"
  )

cwift_state <- read.csv3("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_State.csv")

cwift_county <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStickels/Edu
                          cational_Justice_Visualization_Project/main/Data/NCES%
                          20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2
                          016)/EDGE_ACS_CWIFT2016_County.csv"
  )

data_cdp03 <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStickels/Educa
                        tional_Justice_Visualization_Project/main/Data/NCES%20Da
                        ta/Selected%20Economic%20Characteristics%20of%20Relevant
                        %20Children%20Enrolled%20(Public%20and%20Private)%20(201
                        4-2018)/CDP03_104_USSchoolDistrictAll.csv"
  )

data_cdp02 <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStickels/Educa
                        tional_Justice_Visualization_Project/main/Data/NCES%20Da
                        ta/CDP02%20SELECTED%20SOCIAL%20CHARACTERISTICS%20OF%20CH
                        ILDREN%20IN%20THE%20UNITED%20STATES/CDP02_105_USSchoolDi
                        strictAll_21824157365.csv"
  )

fips_data <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStickels/Educat
                       ional_Justice_Visualization_Project/main/Data/FIPS_State_
                       Codes.csv"
  )

state_school_funding <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStic
                                  kels/Educational_Justice_Visualization_Project
                                  /main/Data/state_education_funding_aggregate.c
                                  sv"
  )




# >>>>>>>>>>>>>>>>>>>> Climate Opinion & Poverty Chart Data

climate_op_data_a <- climate_op_data %>%
  filter(GeoType == "State") %>%
  select(GeoName,
         fundrenewables,
         regulate,
         reducetax,
         drilloffshore,
         teachGW) %>%
  rename(state = GeoName) %>%
  left_join(select(state_school_funding, state, total_funding), by = "state")

colnames(climate_op_data_a) <- c(
  "State",
  "Funding Research for Renewable Energy",
  "Regulating CO2",
  "Carbon Tax",
  "Offshore Drilling",
  "Teaching Global Warming",
  "total_funding_per"
)




states = c(unique(climate_op_data %>%
                    filter(GeoType == "State") %>%
                    pull(GeoName)))






# *************** Server *************** #



# Server Function
server <- function(input, output) {
  
  
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Plot 1
  output$policy_plot <-  renderPlotly({
    # chart1_radio input
    
    if (input$chart1_radio == 1) {
      climate_op_data2 <- climate_op_data_a %>%
        filter(State %in% input$statepicker)
    }
    else if (input$chart1_radio == 2) {
      climate_op_data2 <- climate_op_data_a %>%
        select("State",
               "Teaching Global Warming",
               "Carbon Tax",
               total_funding_per) %>%
        filter(State %in% input$statepicker)
    }
    else if (input$chart1_radio == 3) {
      climate_op_data2 <- climate_op_data_a %>%
        select(
          "State",
          "Teaching Global Warming",
          "Funding Research for Renewable Energy",
          total_funding_per
        ) %>%
        filter(State %in% input$statepicker)
    }
    else if (input$chart1_radio == 4) {
      climate_op_data2 <- climate_op_data_a %>%
        select("State",
               "Teaching Global Warming",
               "Offshore Drilling",
               total_funding_per) %>%
        filter(State %in% input$statepicker)
    }
    else if (input$chart1_radio == 5) {
      climate_op_data2 <- climate_op_data_a %>%
        select("State",
               "Teaching Global Warming",
               "Regulating CO2",
               total_funding_per) %>%
        filter(State %in% input$statepicker)
    }
    
    climate_policy_support <- gather(climate_op_data2,
                                     key = policy,
                                     value = percent,-State,
                                     -total_funding_per)
    
    climate_policy_support_mean <- climate_policy_support %>%
      group_by(policy) %>%
      summarize(mean = mean(percent))
    
    #plot climate support data
    if (input$chart1_radio2 == 1) {
      policy_support_plot <- ggplot(data = climate_policy_support,
                                    aes(
                                      x = reorder(State, -total_funding_per),
                                      y = percent,
                                      color = policy
                                    )) +
        geom_point(size = 2) +
        ylim(25, 100) +
        geom_smooth(
          aes(group = policy, color = policy),
          method = "lm",
          formula = 'y ~ x',
          se = F
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              axis.title.y = element_blank()) +
        labs(title = "Climate Policy Support, by State",
             y = "Estimated Percentage of Support") +
        coord_flip()
      
    } else {
      policy_support_plot <- ggplot(data = climate_policy_support,
                                    aes(
                                      x = reorder(State, -total_funding_per),
                                      y = percent,
                                      color = policy
                                    )) +
        geom_point(size = 2) +
        ylim(25, 100) +
        geom_hline(data = climate_policy_support_mean,
                   aes(yintercept = mean, color = policy),
                   linetype = 2) +
        theme(plot.title = element_text(hjust = 0.5),
              axis.title.y = element_blank()) +
        labs(title = "Climate Policy Support, by State",
             y = "Estimated Percentage of Support") +
        coord_flip()
      
    }
    
    
    
    psp <- ggplotly(policy_support_plot)
    
    return(psp)
    
    
  })
  
  
  
  
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Plot 2
  YaleData <-
    read.csv3(
      "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Vis
      ualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Da
      ta.csv"
    )
  
  poverty_estimates <-
    read.csv3(
      "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Vis
      ualization_Project/ec10209f8db8f63feff6991ed33e6a2a356a9fef/NCES%20Poverty
      %20Levels.csv"
    )
  
  states_p1 <-
    read.csv3(
      "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Vis
      ualization_Project/main/sc091aai.csv"
    )
  
  states_p2 <-
    read.csv3(
      "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Vis
      ualization_Project/main/sc091akn.csv"
    )
  
  states_p3 <-
    read.csv3(
      "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Vis
      ualization_Project/main/sc091aow.csv"
    )
  
  state_codes <-
    read.csv3(
      "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Vis
      ualization_Project/main/Data/FIPS_State_Codes.csv"
    )
  
  # Aggregate and mutate Yale data to get attitudes and combine with Economic/CWIFT data
  
  poverty_estimates_new <-
    as.data.frame(sapply(poverty_estimates, toupper))
  
  states_1 <- states_p1 %>%
    select(Code = ncessch,
           NAME = schnam09,
           State = mstate09)
  
  states_2 <- states_p2 %>%
    select(Code = ncessch,
           NAME = schnam09,
           State = mstate09)
  
  states_3 <- states_p3 %>%
    select(Code = ncessch,
           NAME = schnam09,
           State = mstate09)
  
  poverty_data <- poverty_estimates_new %>%
    select(Code = NCESSCH, NAME, IPR_EST, IPR_SE)
  
  states_1_2 <- rbind(states_1, states_2)
  
  states_full <- rbind(states_1_2, states_3)
  
  # Final data frames with state names and IPR
  poverty_data_full <-
    left_join(poverty_data, states_full, by = "NAME")
  
  yale_by_state <- YaleData %>%
    filter(GeoType == "State") %>%
    group_by(GeoName)
  
  yale_by_state$GeoName <-
    state.abb[match(yale_by_state$GeoName, state.name)]
  
  # Find the average IPR_EST in each state using the poverty data
  average_ipr <- poverty_data_full %>%
    group_by(State) %>%
    mutate(IPR_AVG = mean(as.numeric(IPR_EST, na.rm = T))) %>%
    select(region = State, IPR_AVG) %>%
    distinct(region, IPR_AVG)
  
  code_state <- state_codes %>%
    select(region = state_abbreviation, state_code, state)
  
  # Create an interactive map chart that displays IPR by state
  join_ipr_codes <-
    left_join(average_ipr, code_state, by = "region")
  
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
  output$ipr_plot <- renderPlot({
    ggplot(data = map_shape_ipr) +
      geom_polygon(
        mapping = aes(
          x = long,
          y = lat,
          group = group,
          fill = IPR_AVG
        ),
        color = "yellow",
        size = .3
      ) +
      coord_map() +
      scale_fill_continuous(low = "papayawhip", high = "orangered3") +
      labs(fill = "Average IPR") +
      map_theme +
      ggtitle("Average Income-to-Poverty Ratio (IPR) by State")
    
    
  })
  
  
  
  # Create an interactive map chart that displays different attitudes by state
  yale_map_data <- yale_by_state %>%
    select(
      region = GeoName,
      TotalPop,
      discuss,
      reducetax,
      CO2limits,
      localofficials,
      congress,
      president,
      corporations,
      citizens,
      regulate,
      supportRPS,
      drilloffshore,
      drillANWR,
      fundrenewables,
      gwvoteimp,
      teachGW,
      happening,
      worried
    )
  
  join_yale_codes <-
    left_join(yale_map_data, code_state, by = "region")
  
  join_yale_codes$state = tolower(join_yale_codes$state)
  
  maps_totals_data <- join_yale_codes %>%
    select(
      abbrev = region,
      state_code,
      TotalPop,
      Support_Discussions = discuss,
      Support_Tax_Reductions = reducetax,
      Support_CO2_Limits = CO2limits,
      Support_Local_Officials = localofficials,
      Support_Congress = congress,
      Support_President = president,
      Support_Corporations = corporations,
      Support_Regulations = regulate,
      Support_Renewable_Standards = supportRPS,
      Support_Offshore_Drilling = drilloffshore,
      Support_Arctic_Drilling = drillANWR,
      Support_Funding_Renewables = fundrenewables,
      See_Global_Warming_as_Priority = gwvoteimp,
      Support_Teaching_Global_Warming = teachGW,
      Agree_Climate_Change_is_Happening = happening,
      Worried_About_Global_Warming = worried,
      region = state
    )
  
  map_shape_type <- map_data("state") %>%
    left_join(maps_totals_data, by = "region")
  
  # Map chart displaying attitudes toward different climate change issues based on state
  output$types_plot <- renderPlot({
    map_chart_types <- ggplot(data = map_shape_type) +
      geom_polygon(
        mapping = aes(
          x = long,
          y = lat,
          group = group,
          fill = map_shape_type[[input$type]]
        ),
        color = "purple",
        size = .3
      ) +
      coord_map() +
      scale_fill_continuous(low = "grey95", high = "midnightblue") +
      labs(fill = "% Support") +
      map_theme +
      ggtitle("Percentage of People Who Support ")
    
    return(map_chart_types)
    
  })
  
  
  
  
  
  
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Plot 3
  
  
  
  output$funding_plot <-  renderPlot({
    
    federal_order <- c("local", "state", "federal")
    state_order <- c("federal", "local", "state")
    local_order <- c("federal", "state", "local")
    
    bar_fund_data <- state_school_funding %>%
      filter(state != "District of Columbia") %>%
      rename(State = state) %>%
      mutate(
        federal = federal_funding / total_funding,
        state = state_funding / total_funding,
        local = local_funding / total_funding
      ) %>%
      select(State, federal, state, local) %>%
      gather(key = "type", value = "percent", -State) %>%
      arrange(percent)
    
    
    if (input$funding_radio == 1) {
      bar_order <- state_school_funding %>%
        filter(state != "District of Columbia") %>%
        mutate(perc = federal_funding / total_funding) %>%
        arrange(perc) %>%
        mutate(order = row_number()) %>%
        select(state, order) %>%
        rename(State = state)
      
      stacked_bart_chart_data <- bar_fund_data %>%
        left_join(bar_order, by = "State")
      
      fund_plot <-
        ggplot(stacked_bart_chart_data,
               aes(
                 fill = factor(type, levels = federal_order),
                 y = percent,
                 x = reorder(State, -order)
               )) +
        geom_bar(position = "fill", stat = "identity") +
        labs(fill = "Funding Source",
             y = "Percent of Total Funding") +
        theme(axis.title.y = element_blank()) +
        coord_flip()
      
      fund_plot
      
    } else if (input$funding_radio == 2) {
      bar_order <- state_school_funding %>%
        filter(state != "District of Columbia") %>%
        mutate(perc = state_funding / total_funding) %>%
        arrange(perc) %>%
        mutate(order = row_number()) %>%
        select(state, order) %>%
        rename(State = state)
      
      stacked_bart_chart_data <- bar_fund_data %>%
        left_join(bar_order, by = "State")
      
      fund_plot <-
        ggplot(stacked_bart_chart_data,
               aes(
                 fill = factor(type, levels = state_order),
                 y = percent,
                 x = reorder(State, -order)
               )) +
        geom_bar(position = "fill", stat = "identity") +
        labs(fill = "Funding Source",
             yaxis = "Percent of Total Funding") +
        theme(axis.title.y = element_blank()) +
        coord_flip()
      
    } else {
      bar_order <- state_school_funding %>%
        filter(state != "District of Columbia") %>%
        mutate(perc = local_funding / total_funding) %>%
        arrange(perc) %>%
        mutate(order = row_number()) %>%
        select(state, order) %>%
        rename(State = state)
      
      stacked_bart_chart_data <- bar_fund_data %>%
        left_join(bar_order, by = "State")
      
      fund_plot <-
        ggplot(stacked_bart_chart_data,
               aes(
                 fill = factor(type, levels = local_order),
                 y = percent,
                 x = reorder(State, -order)
               )) +
        geom_bar(position = "fill", stat = "identity") +
        labs(fill = "Funding Source",
             yaxis = "Percent of Total Funding") +
        theme(axis.title.y = element_blank()) +
        coord_flip()
      
    }
    
    print(fund_plot)
    
  })
  
  
  output$funding_comparison_plot <-  renderPlotly({
    
    color_df <- data.frame("color" = head(rep(c("tomato3", "tomato1"), 26), -1))
    
    comparison_bar_data <- state_school_funding %>%
      select(state, total_funding) %>%
      arrange(-total_funding) %>%
      mutate(order = row_number()) %>%
      mutate(color = color_df$color)
    
    cwift_adjusted <- comparison_bar_data %>%
      left_join(cwift_state, by = c("state" = "ST_NAME")) %>%
      mutate(adjusted_total_funding = total_funding / ST_CWIFTEST) %>%
      select(state, adjusted_total_funding, order) %>%
      mutate(color = color_df$color)
    
    
    comp_chart <- ggplot(comparison_bar_data, aes(x = reorder(state, order), y = total_funding, fill = color)) + 
      geom_bar(stat="identity", width=.5) + 
      scale_fill_manual(values = c("tomato3", "tomato1")) +
      labs(title="Total Funding Per Student by State",
           caption="source: mpg",
           x = "State",
           y = "Funding per Student") + 
      ylim(0,32000) +
      theme(axis.title.y = element_blank(),
            legend.position = "none") +
      coord_flip()
    
    
    adjust_chart <- ggplot(cwift_adjusted, aes(x = reorder(state, order), y = adjusted_total_funding, fill = color)) + 
      geom_bar(stat="identity", width=.5) +
      scale_fill_manual(values = c("tomato3", "tomato1")) +
      labs(title="Total Funding Per Student by State, Adjusted by CWIFT",
           caption="source: mpg",
           x = "State",
           y = "Funding per Student") + 
      ylim(0,32000) +
      theme(axis.title.y = element_blank(),
            legend.position = "none") +
      coord_flip()

    
    if(input$switch == T) {
      
      return(ggplotly(adjust_chart, tooltip="y"))
      
    } else {
      
      return(ggplotly(comp_chart, tooltip="y"))
      
    }
    
    
  })
  
  
  #
  # waffle <- state_school_funding %>%
  #   filter(state == "Oregon") %>%
  #   mutate(federal = round(federal_funding / total_funding * 100, 0), state = round(state_funding / total_funding * 100, 0)) %>%
  #   mutate(local = 100 - federal - state) %>%
  #   select(federal, state, local)
  #
  # df <- expand.grid(y = 1:10, x = 1:10)
  #
  # df$category <- factor(rep(names(waffle), waffle))
  #
  #
  # ggplot(df, aes(x = x, y = y, fill = category)) +
  #   geom_tile(color = "black", size = 0.5) +
  #   scale_x_continuous(expand = c(0, 0)) +
  #   scale_y_continuous(expand = c(0, 0), trans = 'reverse') +
  #   scale_fill_brewer(palette = "Dark2") +
  #   labs(title="Waffle Chart",
  #        caption="Source: mpg") +
  #   theme(#panel.border = element_rect(size = 2),
  #         plot.title = element_text(size = rel(1.2)),
  #         axis.text = element_blank(),
  #         axis.title = element_blank(),
  #         axis.ticks = element_blank(),
  #         #legend.title = element_blank(),
  #         legend.position = "right")
  #
  
  
  
}



