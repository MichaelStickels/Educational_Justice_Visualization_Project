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

cwift_state <-
  read.csv3(
    "https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visua
    lization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Tea
    chers%20(2016)/EDGE_ACS_CWIFT2016_State.csv"
  )

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





# >>>>>>>>>>>>>>>>>>>> Climate Opinion & Poverty Chart Data

climate_op_data_a <- climate_op_data %>%
  filter(GeoType == "State") %>%
  select(
    GeoName,
    fundrenewables,
    regulate,
    reducetax,
    drilloffshore,
    teachGW
  ) %>%
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




states <- c(unique(climate_op_data %>%
  filter(GeoType == "State") %>%
  pull(GeoName)))




# >>>>>>>>>>>>>>>>>>>> Map Chart

# Aggregate and mutate Yale data to get attitudes and combine with
#  Economic/CWIFT data

poverty_estimates_new <-
  as.data.frame(sapply(poverty_estimates, toupper))

states_1 <- states_p1 %>%
  select(
    Code = ncessch,
    NAME = schnam09,
    State = mstate09
  )

states_2 <- states_p2 %>%
  select(
    Code = ncessch,
    NAME = schnam09,
    State = mstate09
  )

states_3 <- states_p3 %>%
  select(
    Code = ncessch,
    NAME = schnam09,
    State = mstate09
  )

poverty_data <- poverty_estimates_new %>%
  select(Code = NCESSCH, NAME, IPR_EST, IPR_SE)

states_1_2 <- rbind(states_1, states_2)

states_full <- rbind(states_1_2, states_3)

# Final data frames with state names and IPR
poverty_data_full <-
  left_join(poverty_data, states_full, by = "NAME")

yale_by_state <- climate_op_data %>%
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




# >>>>>>>>>>>>>>>>>>>> Conclusion Data

avg_pct_teaching_support <- sprintf(
  "%0.1f%%",
  climate_op_data %>%
    filter(GeoType == "National") %>%
    pull(teachGW)
)

clim_op_table <- climate_op_data %>%
  filter(GeoType == "National") %>%
  select(
    fundrenewables,
    regulate,
    reducetax,
    drilloffshore,
    teachGW
  ) %>%
  mutate(fundrenewables = sprintf("%0.1f%%", fundrenewables),
         regulate = sprintf("%0.1f%%", regulate),
         reducetax = sprintf("%0.1f%%", reducetax),
         drilloffshore = sprintf("%0.1f%%", drilloffshore),
         teachGW = sprintf("%0.1f%%", teachGW))


colnames(clim_op_table) <- c(
  "Funding Research for Renewable Energy",
  "Regulating CO2",
  "Carbon Tax",
  "Offshore Drilling",
  "Teaching Global Warming"
)


state_ipr_lowest <- fips_data %>%
  left_join(average_ipr, by = c("state_abbreviation" = "region")) %>%
  filter(state %in% states) %>%
  filter(IPR_AVG == min(IPR_AVG)) %>%
  pull(state)

state_ipr_highest <- fips_data %>%
  left_join(average_ipr, by = c("state_abbreviation" = "region")) %>%
  filter(state %in% states) %>%
  filter(IPR_AVG == max(IPR_AVG)) %>%
  pull(state)


state_highest_school_fund <- state_school_funding %>%
  left_join(cwift_state, by = c("state" = "ST_NAME")) %>%
  mutate(adjusted = total_funding / ST_CWIFTEST) %>%
  filter(adjusted == max(adjusted)) %>%
  pull(state)

highest_school_fund <- state_school_funding %>%
  left_join(cwift_state, by = c("state" = "ST_NAME")) %>%
  mutate(adjusted = total_funding / ST_CWIFTEST) %>%
  filter(adjusted == max(adjusted)) %>%
  pull(adjusted)

state_lowest_school_fund <- state_school_funding %>%
  left_join(cwift_state, by = c("state" = "ST_NAME")) %>%
  mutate(adjusted = total_funding / ST_CWIFTEST) %>%
  filter(adjusted == min(adjusted)) %>%
  pull(state)

lowest_school_fund <- state_school_funding %>%
  left_join(cwift_state, by = c("state" = "ST_NAME")) %>%
  mutate(adjusted = total_funding / ST_CWIFTEST) %>%
  filter(adjusted == min(adjusted)) %>%
  pull(adjusted)

fund_difference <- round(highest_school_fund / lowest_school_fund, 1)
