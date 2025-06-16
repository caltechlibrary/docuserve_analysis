# Install all dependencies
install.packages("tidyverse")
install.packages("readxl")
# https://readxl.tidyverse.org/
library("readxl")
library("tidyverse")
# place excel files for analysis in the /data/ folder

# Imports XLSX file into dataframe. Change the names of the files as needed:
docuserve_data_docdel <- read_xlsx("./data/docuserve borrowing requests jan-march 2025.xlsx")
docuserve_data_borrowing <- read_xlsx("./data/docuserve borrowing requests jan-march 2025.xlsx")

# Filter docdel data for the selected columns:
docdel_filtered <- select(docuserve_data_docdel, `Request Type`, `Loan Author`, `Loan Title`, `Loan Publisher`, `Loan Date`, `Loan Edition`, `Photo Journal Title`, 
`Photo Journal Year`, `Transaction Date`, `Photo Item Author`, `Photo Item Place`, `Photo Item Publisher`, `Photo Item Edition`, `Location`, `Document Type`, 
`Web Request Form`, `DOI`, `User Name1`, `Status`, `Department`)

# Filer borrowing data for the selected columns:
borrowing_filtered <- select(docuserve_data_borrowing, `Request Type`, `Loan Author`, `Loan Title`, `Loan Publisher`, `Loan Date`, `Loan Edition`, `Photo Journal Title`, 
`Photo Journal Year`, `Transaction Date`, `Photo Item Author`, `Photo Item Place`, `Photo Item Publisher`, `Photo Item Edition`, `Location`, `Document Type`, 
`Web Request Form`, `DOI`, `User Name1`, `Status`, `Department`)

# standardize capitalization - make all lowercase
docdel_filtered$`Photo Journal Title` <- 
  tolower(docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  tolower(borrowing_filtered$`Photo Journal Title`)

# need regex to get rid of trailing period or comma
docdel_filtered$`Photo Journal Title` <- 
  gsub('^\\.|\\.$', '', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub('^\\.|\\.$', '', borrowing_filtered$`Photo Journal Title`)

# remove all commas
docdel_filtered$`Photo Journal Title` <- 
  gsub(pattern = "\\,", '', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub(pattern = "\\,", '', borrowing_filtered$`Photo Journal Title`)

# remove all periods
docdel_filtered$`Photo Journal Title` <- 
  gsub(pattern = "\\.", '', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub(pattern = "\\.", '', borrowing_filtered$`Photo Journal Title`)

# get rid of trailing forward slash
docdel_filtered$`Photo Journal Title` <- 
  gsub(' /$', '', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub(' /$', '', borrowing_filtered$`Photo Journal Title`)

# get rid of "the " in front of titles
docdel_filtered$`Photo Journal Title` <- 
  gsub('the ', '', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub('the ', '', borrowing_filtered$`Photo Journal Title`)

# remove ü and replace with u
docdel_filtered$`Photo Journal Title` <- 
  gsub('ü', 'u', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub('ü', 'u', borrowing_filtered$`Photo Journal Title`)

# replace ampersand with "and"
docdel_filtered$`Photo Journal Title` <- 
  gsub('&', 'and', docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub('&', 'and', borrowing_filtered$`Photo Journal Title`)

# replace "j" with "journal"
docdel_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[j]\\b", "journal", docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[j]\\b", "journal", borrowing_filtered$`Photo Journal Title`)

# replace "trans" with "transactions"
docdel_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[trans]\\b", "transactions", docdel_filtered$`Photo Journal Title`)
borrowing_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[trans]\\b", "transactions", borrowing_filtered$`Photo Journal Title`)

# Data frame for docdel loans (books?):
docdel_loans <- docdel_filtered %>%
  filter(`Request Type` == "Loan")

# Data frame for docdel articles:
docdel_articles <- docdel_filtered %>%
  filter(`Request Type` == "Article")

# Data frame for borrowing loans (books?):
borrowing_loans <- borrowing_filtered %>%
  filter(`Request Type` == "Loan")

# Data frame for borrowing articles:
borrowing_articles <- borrowing_filtered %>%
  filter(`Request Type` == "Article")

# extract docdel loans journal titles and arrange by number:
docdel_loans_journal_count <- docdel_loans %>%
  count(`Photo Journal Title`, sort = TRUE)

#extract docdel articles journal titles and arrange by number
docdel_articles_journal_count <- docdel_articles %>%
  count(`Photo Journal Title`, sort = TRUE)

# extract borrowing loans journal titles and arrange by number:
borrowing_loans_journal_count <- borrowing_loans %>%
  count(`Photo Journal Title`, sort = TRUE)

# extract borrowing articles journal titles and arrange by number:
borrowing_articles_journal_count <- borrowing_articles %>%
  count(`Photo Journal Title`, sort = TRUE)

# alphabetical order
borrowing_articles_journal_abc <- borrowing_articles_journal_count[order(borrowing_articles_journal_count$`Photo Journal Title`),]

# export to csv files
# write_csv(journal_abc, file = "./data/2023_docuserve_doc_del_journal_abc.csv")
# write_csv(journal_count, file = "./data/2023_docuserve_doc_del_journal_count.csv")


