#
#   App server
#
#   Educational Justice and the Environment
#

source("app_data-prep.R")


# Server Function
server <- function(input, output) {
  output$policy_plot <- renderPlotly({
    # chart1_radio input

    if (input$chart1_radio == 1) {
      climate_op_data2 <- climate_op_data_a %>%
        filter(State %in% input$statepicker)
    }
    else if (input$chart1_radio == 2) {
      climate_op_data2 <- climate_op_data_a %>%
        select(
          "State",
          "Teaching Global Warming",
          "Carbon Tax",
          total_funding_per
        ) %>%
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
        select(
          "State",
          "Teaching Global Warming",
          "Offshore Drilling",
          total_funding_per
        ) %>%
        filter(State %in% input$statepicker)
    }
    else if (input$chart1_radio == 5) {
      climate_op_data2 <- climate_op_data_a %>%
        select(
          "State",
          "Teaching Global Warming",
          "Regulating CO2",
          total_funding_per
        ) %>%
        filter(State %in% input$statepicker)
    }

    climate_policy_support <- gather(climate_op_data2,
      key = policy,
      value = percent,
      -State, -total_funding_per
    )

    climate_policy_support_mean <- climate_policy_support %>%
      group_by(policy) %>%
      summarize(mean = mean(percent))

    # plot climate support data
    if (input$chart1_radio2 == 1) {
      policy_support_plot <- ggplot(
        data = climate_policy_support,
        aes(
          x = reorder(State, -total_funding_per),
          y = percent,
          color = policy
        )
      ) +
        geom_point(size = 2) +
        ylim(25, 100) +
        geom_smooth(
          aes(group = policy, color = policy),
          method = "lm",
          formula = "y ~ x",
          se = F
        ) +
        theme(
          plot.title = element_text(hjust = 0.5),
          axis.title.y = element_blank()
        ) +
        labs(
          title = "Climate Policy Support, by State",
          y = "Estimated Percentage of Support"
        ) +
        coord_flip()
    } else {
      policy_support_plot <- ggplot(
        data = climate_policy_support,
        aes(
          x = reorder(State, -total_funding_per),
          y = percent,
          color = policy
        )
      ) +
        geom_point(size = 2) +
        ylim(25, 100) +
        geom_hline(
          data = climate_policy_support_mean,
          aes(yintercept = mean, color = policy),
          linetype = 2
        ) +
        theme(
          plot.title = element_text(hjust = 0.5),
          axis.title.y = element_blank()
        ) +
        labs(
          title = "Climate Policy Support, by State",
          y = "Estimated Percentage of Support"
        ) +
        coord_flip()
    }



    psp <- ggplotly(policy_support_plot)

    return(psp)
  })





  # Create an interactive map chart that displays IPR by state
  join_ipr_codes <-
    left_join(average_ipr, code_state, by = "region")

  join_ipr_codes$state <- tolower(join_ipr_codes$state)

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

  join_yale_codes$state <- tolower(join_yale_codes$state)

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

  # Map chart displaying attitudes toward different climate change issues
  #  based on state
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
      ggtitle("Percentage of People Who... ")

    return(map_chart_types)
  })





  output$funding_plot <- renderPlot({
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
        ggplot(
          stacked_bart_chart_data,
          aes(
            fill = factor(type, levels = federal_order),
            y = percent,
            x = reorder(State, -order)
          )
        ) +
        geom_bar(position = "fill", stat = "identity") +
        labs(
          fill = "Funding Source",
          y = "Percent of Total Funding"
        ) +
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
        ggplot(
          stacked_bart_chart_data,
          aes(
            fill = factor(type, levels = state_order),
            y = percent,
            x = reorder(State, -order)
          )
        ) +
        geom_bar(position = "fill", stat = "identity") +
        labs(
          fill = "Funding Source",
          yaxis = "Percent of Total Funding"
        ) +
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
        ggplot(
          stacked_bart_chart_data,
          aes(
            fill = factor(type, levels = local_order),
            y = percent,
            x = reorder(State, -order)
          )
        ) +
        geom_bar(position = "fill", stat = "identity") +
        labs(
          fill = "Funding Source",
          yaxis = "Percent of Total Funding"
        ) +
        theme(axis.title.y = element_blank()) +
        coord_flip()
    }

    print(fund_plot)
  })


  output$funding_comparison_plot <- renderPlotly({
    color_df <-
      data.frame("color" = head(rep(c(
        "tomato3", "tomato1"
      ), 26), -1))

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


    comp_chart <-
      ggplot(
        comparison_bar_data,
        aes(
          x = reorder(state, order),
          y = total_funding,
          fill = color
        )
      ) +
      geom_bar(stat = "identity", width = .5) +
      scale_fill_manual(values = c("tomato3", "tomato1")) +
      labs(
        title = "Total Funding Per Student by State",
        caption = "source: mpg",
        x = "State",
        y = "Funding per Student"
      ) +
      ylim(0, 32000) +
      theme(
        axis.title.y = element_blank(),
        legend.position = "none"
      ) +
      coord_flip()


    adjust_chart <-
      ggplot(
        cwift_adjusted,
        aes(
          x = reorder(state, order),
          y = adjusted_total_funding,
          fill = color
        )
      ) +
      geom_bar(stat = "identity", width = .5) +
      scale_fill_manual(values = c("tomato3", "tomato1")) +
      labs(
        title = "Total Funding Per Student by State, Adjusted by CWIFT",
        caption = "source: mpg",
        x = "State",
        y = "Funding per Student"
      ) +
      ylim(0, 32000) +
      theme(
        axis.title.y = element_blank(),
        legend.position = "none"
      ) +
      coord_flip()


    if (input$switch == T) {
      return(ggplotly(adjust_chart, tooltip = "y"))
    } else {
      return(ggplotly(comp_chart, tooltip = "y"))
    }
  })
  output$clim_op_table <- renderTable(clim_op_table)
}
