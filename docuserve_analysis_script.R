# Install all dependencies
install.packages("tidyverse")
install.packages("readxl")
# https://readxl.tidyverse.org/
library("readxl")
library("tidyverse")
# place excel files for analysis in the /data/ folder
# Imports XLSX file into dataframe:
docuserve_data_all <- read_xlsx("./data/2021_docuserve_borrowing_requests.xlsx")
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
# Journal titles:
journal_count <- docuserve_articles %>%
  count(`Photo Journal Title`)
# alphabetical order
journal_abc <- journal_count[order(journal_count$`Photo Journal Title`),]
# need regex to get rid of training period or comma
# need regex to standardize capitalization
# need regex to get rid of "The " at the start of journals
