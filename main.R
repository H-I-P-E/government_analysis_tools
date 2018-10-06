library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(purrr)
library(shiny)
library(ggplot2)

build_dataset = F #Set to true to recreate dataset for app from raw data

raw_data_folder <- 'raw_data' #Data from civil_service_jobs repo
shiny_app_folder <- 'shiny-app'
data_folder <- 'data'

cleaned_data_csv <- file.path(raw_data_folder, 'cleaned_advert_data.csv')
role_data_csv <- file.path(raw_data_folder, 'role_data.csv')
grade_data_csv <- file.path(raw_data_folder, 'grade_data.csv')
adverts_csv_name <- file.path(raw_data_folder, 'all_full_advert_data.csv')

regex_file <- 'tool_regexs.txt'
tool_counts_file <- 'tool_counts_by_job.csv'

#Paths for shiny app
regexs_shiny_path <- file.path(data_folder, regex_file)
tool_counts_by_job_shiny_path <- file.path(data_folder, tool_counts_file)

#Pasths for command line
tool_counts_by_job_file <- file.path(shiny_app_folder, tool_counts_by_job_shiny_path)
regexs_table <- file.path(shiny_app_folder, regexs_shiny_path)


#Check if data set exists - rebuild if necessary
if(build_dataset){
source('R//create_data_set.R')}

runApp(shiny_app_folder)
