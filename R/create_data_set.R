#Looks through all the job descriptions and checks for mentions of a range of tools and programming languages. Produces a file, ready for further analysis.

all_advert_data <- cleaned_data_csv %>%
  read_csv %>%
  left_join(adverts_csv_name %>%
              read_csv, by = c('job_id'='job_ref')) %>%
  select(job_id, "Job description", job_department, date_downloaded) %>%
  filter(!is.na(`Job description`)) %>%
  mutate(description_word_count = str_count(`Job description`, '\\w+'))
  
tool_regexs <- read_tsv(regexs_table)

#Produces a single row for a job, with a column for each tool
tool_mentions <- function(job_description, job_id){
  if(!isTruthy(job_description)){
    return(NULL)
  }
  counts <- tool_regexs %>%
    mutate(counts = str_count(job_description, regex)) %>%
    select(-regex) %>%
    spread(tool, counts) %>%
    mutate(job_id = job_id,
           length = nchar(job_description))
  return(counts)
}

analytical_professions <- c("Statistics", "Operational Research", "Economist", "Social Research")

job_role_types <- role_data_csv %>%
  read_csv %>%
  filter(role_type %in% analytical_professions) %>%
  group_by(job_id) %>%
  summarise(roles = paste(role_type, collapse = ", "),
            number_of_professions = length(role_type)) %>%
  mutate(roles = replace(roles, number_of_professions >2, "More than 2 professions mentionned")) %>%
  select(-number_of_professions)

advert_tool_counts <-
  map2(all_advert_data$`Job description`, all_advert_data$job_id, tool_mentions) %>%
  reduce(bind_rows) %>%
  right_join(all_advert_data) %>%
  select(-`Job description`)  %>%
  left_join(job_role_types) %>%
  replace_na(list(roles = "Not in an analytical profession"))

write_csv(advert_tool_counts, tool_counts_by_job_file)
