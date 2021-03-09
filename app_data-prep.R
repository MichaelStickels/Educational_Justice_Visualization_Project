#
#   Data prep and manipulating
#
#   Educational Justice and the Environment
#



# Load data
US_climate_opinion <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

school_finance_data <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/US%20Census%202018%20school%20finance%20data/elsec18.csv")

climate_op_data <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.csv")

cwift_county <- read.csv("https://raw.githubusercontent.com/MichaelStickels/Educational_Justice_Visualization_Project/main/Data/NCES%20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2016)/EDGE_ACS_CWIFT2016_County.csv")





# Funding & Climate Opinion Chart Data
climate_op_state <- climate_op_data %>%
  select(GEOID, happening)

cwift_county_select <- cwift_county %>%
  select(CNTY_FIPS, CNTY_CWIFTEST) %>%
  summarize(GEOID = CNTY_FIPS, CNTY_CWIFTEST)

funding_chart_data <- school_finance_data %>%
  select(STATE, CONUM, TCURELSC , V33) %>%
  group_by(CONUM) %>%
  summarize(GEOID = CONUM, ppspend = mean(TCURELSC / V33, na.rm = T)) %>%
  left_join(climate_op_state, by = 'GEOID') %>%
  left_join(cwift_county_select, by = 'GEOID') %>%
  mutate(adjusted_spend = ppspend * CNTY_CWIFTEST) %>%
  filter_all(all_vars(!is.infinite(.)))
  