#
#   App
#
#   Educational Justice and the Environment
#



# Libraries
library(leaflet)
library(rjson)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(plotly)
library(shiny)
library(shinyWidgets)
library(ggplot2)
library(scales)



# Source files
source("app_ui.R")
source("app_server.R")
#source("app_data-prep.R")



# Run application 
shinyApp(ui, server)
