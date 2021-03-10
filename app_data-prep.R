#
#   Data prep and manipulating
#
#   Educational Justice and the Environment
#



# Data Load Helper Function (removes line breaks from links/paths)
read.csv3 <- function(dir,debug=TRUE) {
  read.csv(gsub("\\n *","",dir))
}


# Load data
school_finance_data <- read.csv3("https://raw.githubusercontent.com/MichaelStick
                                 els/Educational_Justice_Visualization_Project/m
                                 ain/Data/US%20Census%202018%20school%20finance%
                                 20data/elsec18.csv")

climate_op_data <- read.csv3("https://raw.githubusercontent.com/MichaelStickels/
                             Educational_Justice_Visualization_Project/main/Data
                             /Yale%20Climate%20Opintion%20Data/YCOM_2020_Data.cs
                             v")

cwift_county <- read.csv3("https://raw.githubusercontent.com/MichaelStickels/Edu
                          cational_Justice_Visualization_Project/main/Data/NCES%
                          20Data/Comparable%20Wage%20Index%20for%20Teachers%20(2
                          016)/EDGE_ACS_CWIFT2016_County.csv")

data_cdp03 <- read.csv3("https://raw.githubusercontent.com/MichaelStickels/Educa
                        tional_Justice_Visualization_Project/main/Data/NCES%20Da
                        ta/Selected%20Economic%20Characteristics%20of%20Relevant
                        %20Children%20Enrolled%20(Public%20and%20Private)%20(201
                        4-2018)/CDP03_104_USSchoolDistrictAll.csv")

data_cdp02 <- read.csv3("https://raw.githubusercontent.com/MichaelStickels/Educa
                        tional_Justice_Visualization_Project/main/Data/NCES%20Da
                        ta/CDP02%20SELECTED%20SOCIAL%20CHARACTERISTICS%20OF%20CH
                        ILDREN%20IN%20THE%20UNITED%20STATES/CDP02_105_USSchoolDi
                        strictAll_21824157365.csv")

fips_data <- read.csv3("https://raw.githubusercontent.com/MichaelStickels/Educat
                       ional_Justice_Visualization_Project/main/Data/FIPS_State_
                       Codes.csv")






# >>>>>>>>>>>>>>>>>>>> Funding & Climate Opinion Chart Data

climate_op_state <- climate_op_data %>%
  select(GeoType, GEOID, happening) %>%
  filter(GeoType == "County") %>%
  group_by(GEOID) %>%
  summarize(happening)

cwift_county_select <- cwift_county %>%
  select(CNTY_FIPS, CNTY_CWIFTEST) %>%
  summarize(GEOID = CNTY_FIPS, CNTY_CWIFTEST)

funding_chart_data <- school_finance_data %>%
  select(STATE, CONUM, TCURINST  , V33) %>%
  group_by(CONUM) %>%
  summarize(exp = mean(TCURINST ), students = mean(V33)) %>%
  rename(GEOID = CONUM) %>%
  mutate(ppspend = exp / students) %>%
  filter(ppspend < 26) %>%
  left_join(climate_op_state, by = 'GEOID') %>%
  left_join(cwift_county_select, by = 'GEOID') %>%
  mutate(pp_adjusted_spend = ppspend * CNTY_CWIFTEST) %>%
  mutate(FIPS = case_when(nchar(GEOID) == 4 ~ paste('0', GEOID, sep = ""),
                          T ~ paste(GEOID)))



state_join <- data_cdp02 %>%
  select(GeoId, CDP02_93pct) %>%
  rename(comp_rate_pct = CDP02_93pct) %>%
  mutate(state_code = as.integer(substr(GeoId, 8, 9))) %>%
  mutate(GEOID = substr(GeoId, 8, 12)) %>%
  left_join(fips_data, by = 'state_code') %>%
  select(state, GEOID, comp_rate_pct)

state_join2 <- data_cdp03 %>%
  select(GeoId, CDP03_54pct) %>%
  rename(pov_rate_pct = CDP03_54pct) %>%
  mutate(state_code = as.integer(substr(GeoId, 8, 9))) %>%
  mutate(GEOID = substr(GeoId, 8, 12)) %>%
  left_join(fips_data, by = 'state_code') %>%
  select(GEOID, pov_rate_pct)

climate_geoid <- climate_op_data %>%
  filter(GeoType == "County") %>%
  select(GEOID, GeoName, happening) %>%
  mutate(GEOID = case_when(nchar(GEOID) == 4 ~ paste('0', GEOID, sep = ""),
                           T ~ paste(GEOID))) %>%
  mutate(GeoName = sub("\\,.*", "", GeoName))

chart_data <- climate_geoid %>%
  left_join(state_join, by = 'GEOID') %>%
  left_join(state_join2, by = 'GEOID') %>%
 # drop_na() %>%
  group_by(GEOID, GeoName, state) %>%
  summarize(happening = mean(happening),
            comp_rate_pct = mean(comp_rate_pct),
            pov_rate_pct = mean(pov_rate_pct))




# >>>>>>>>>>>>>>>>>>>>

