library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(purrr)

raw_data_folder <- 'raw_data' #Data from civil_service_jobs repo
cooked_data_folder <- 'cooked_data'
lookups_folder <- 'lookups'


cleaned_data_csv <- file.path(raw_data_folder, 'cleaned_advert_data.csv')
role_data_csv <- file.path(raw_data_folder, 'role_data.csv')
grade_data_csv <- file.path(raw_data_folder, 'grade_data.csv')
adverts_csv_name <- file.path(raw_data_folder, 'all_full_advert_data.csv')

tool_counts_by_job_file <- file.path(cooked_data_folder, 'tool_counts_by_job.csv')

regexs_table <- file.path(lookups_folder, 'tool_regexs.txt')

source('R//create_data_set.R')