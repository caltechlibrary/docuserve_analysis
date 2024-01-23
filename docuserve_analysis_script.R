# Install all dependencies
install.packages("tidyverse")
install.packages("readxl")
# https://readxl.tidyverse.org/
library("readxl")
library("tidyverse")
# place excel files for analysis in the /data/ folder

# Imports XLSX file into dataframe:
docuserve_data_all <- read_xlsx("./data/2023_docuserve_doc_del_requests.xlsx")

# Filters for the selected columns:
docuserve_data_filtered <- select(docuserve_data_all, `Request Type`, 
`Loan Author`, `Loan Title`, `Loan Publisher`, `Loan Date`, `Loan Edition`, 
`Photo Journal Title`, `Photo Journal Year`, `Transaction Date`, `Photo Item Author`, 
`Photo Item Place`, `Photo Item Publisher`, `Photo Item Edition`, `Document Type`, 
`Web Request Form`, `User Name1`, `Status`, `Department`)

# Data frame for loans (books?):
docuserve_loans <- docuserve_data_filtered %>%
  filter(`Request Type` == "Loan")

# Data frame for articles:
docuserve_articles <- docuserve_data_filtered %>%
  filter(`Request Type` == "Article")

# standardize capitalization - make all lowercase
docuserve_articles$`Photo Journal Title` <- 
  tolower(docuserve_articles$`Photo Journal Title`)

# need regex to get rid of trailing period or comma
docuserve_articles$`Photo Journal Title` <- 
  gsub('^\\.|\\.$', '', docuserve_articles$`Photo Journal Title`)

# remove all commas
docuserve_articles$`Photo Journal Title` <- 
  gsub(pattern = "\\,", '', docuserve_articles$`Photo Journal Title`)

# remove all periods
docuserve_articles$`Photo Journal Title` <- 
  gsub(pattern = "\\.", '', docuserve_articles$`Photo Journal Title`)

# get rid of trailing forward slash
docuserve_articles$`Photo Journal Title` <- 
  gsub(' /$', '', docuserve_articles$`Photo Journal Title`)

# get rid of "the " in front of titles
docuserve_articles$`Photo Journal Title` <- 
  gsub('the ', '', docuserve_articles$`Photo Journal Title`)

# remove ü and replace with u
docuserve_articles$`Photo Journal Title` <- 
  gsub('ü', 'u', docuserve_articles$`Photo Journal Title`)

# replace ampersand with "and"
docuserve_articles$`Photo Journal Title` <- 
  gsub('&', 'and', docuserve_articles$`Photo Journal Title`)

# replace "j" with "journal"
docuserve_articles$`Photo Journal Title` <- 
  gsub("(?i)\\b[j]\\b", "journal", docuserve_articles$`Photo Journal Title`)

# replace "trans" with "transactions"
docuserve_articles$`Photo Journal Title` <- 
  gsub("trans", "transactions", docuserve_articles$`Photo Journal Title`)

# extract Journal titles and arrange by number:
journal_count <- docuserve_articles %>%
  count(`Photo Journal Title`, sort = TRUE)

# alphabetical order
journal_abc <- journal_count[order(journal_count$`Photo Journal Title`),]

# export to csv files
write_csv(journal_abc, file = "./data/2023_docuserve_doc_del_journal_abc.csv")
write_csv(journal_count, file = "./data/2023_docuserve_doc_del_journal_count.csv")


