# Install all dependencies
install.packages("tidyverse")
install.packages("readxl")
# https://readxl.tidyverse.org/
library("readxl")
library("tidyverse")
# place excel files for analysis in the /data/ folder

# Imports XLSX file into dataframe:
# updated 2025-07-09 by PJ to take filepaths from prompts to user
# docuserve_data_docdel <- read_xlsx("./data/2023_docuserve_docdel_requests.xlsx")
docuserve_data_docdel <- read_xlsx(readline(prompt="Enter the path of the document delivery .xlsx file to import: "))
# docuserve_data_borrowing <- read_xlsx("./data/2023_docuserve_borrowing_requests.xlsx")
docuserve_data_borrowing <- read_xlsx(readline(prompt="Enter the path of the borrowing .xlsx file to import: "))

# append docuserve_data_borrowing to docuserve_data_docdel
docuserve_data <- bind_rows(docuserve_data_docdel, docuserve_data_borrowing)

# Filter docuserve_data for the selected columns:
docuserve_data_filtered <- select(docuserve_data, `Request Type`, `Loan Author`, `Loan Title`, `Loan Publisher`, `Loan Date`, `Loan Edition`, `Photo Journal Title`, 
                          `Photo Journal Year`, `Transaction Date`, `Photo Item Author`, `Photo Item Place`, `Photo Item Publisher`, `Photo Item Edition`, `Location`, `Document Type`, 
                          `Web Request Form`, `DOI`, `User Name1`, `Status`, `Department`)

# standardize journal title capitalization - make all lowercase
docuserve_data_filtered$`Photo Journal Title` <- 
  tolower(docuserve_data_filtered$`Photo Journal Title`)

# regex to get rid of trailing period or comma in journal title
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub('^\\.|\\.$', '', docuserve_data_filtered$`Photo Journal Title`)

# regex to remove all commas
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub(pattern = "\\,", '', docuserve_data_filtered$`Photo Journal Title`)

# regex to remove all periods
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub(pattern = "\\.", '', docuserve_data_filtered$`Photo Journal Title`)

# regex to remove trailing forward slash
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub(' /$', '', docuserve_data_filtered$`Photo Journal Title`)

# regex to remove "the " in front of titles
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub('the ', '', docuserve_data_filtered$`Photo Journal Title`)

# regex to remove ü and replace with u
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub('ü', 'u', docuserve_data_filtered$`Photo Journal Title`)

# regex to replace ampersand with "and"
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub('&', 'and', docuserve_data_filtered$`Photo Journal Title`)

# regex to replace "j" with "journal"
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[j]\\b", "journal", docuserve_data_filtered$`Photo Journal Title`)

# regex to replace "trans" with "transactions"
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[trans]\\b", "transactions", docuserve_data_filtered$`Photo Journal Title`)

# regex to replace "spectrocsopy" with "spectroscopy"
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[spectrocsopy]\\b", "spectroscopy", docuserve_data_filtered$`Photo Journal Title`)

# regex to replace "lett" with "letters"
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[lett]\\b", "letters", docuserve_data_filtered$`Photo Journal Title`)

# regex to replace "nat" with "nature"
docuserve_data_filtered$`Photo Journal Title` <- 
  gsub("(?i)\\b[nat]\\b", "nature", docuserve_data_filtered$`Photo Journal Title`)

# regex to replace "neurosciene" with "neuroscience"
docuserve_data_filtered$`Photo Journal Title` <-
  gsub("(?i)\\b[neurosciene]\\b", "neuroscience", docuserve_data_filtered$`Photo Journal Title`)

# extract Document Type and arrange by number:
document_types_total <- docuserve_data_filtered %>%
  count(`Document Type`, sort = TRUE)

# extract combinations of process/request/document type and arrange by frequency
request_type_freq <- docuserve_data %>% 
  group_by(`Process Type`, `Request Type`, `Document Type`) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count))

# extract Article and DOI document types
docuserve_data_article_doi <- docuserve_data_filtered %>%
  filter(`Document Type` == "Article" | `Document Type` =="DOI")

# extract journal titles and arrange by number:
docuserve_article_doi_journal_count <- docuserve_data_article_doi %>%
  count(`Photo Journal Title`, sort = TRUE)

# alphabetical order
docuserve_article_doi_journal_abc <- docuserve_article_doi_journal_count[order(docuserve_article_doi_journal_count$`Photo Journal Title`),]

# export to csv files
# write_csv(docuserve_article_doi_journal_abc, file = "./data/2023_docuserve_article_doi_journal_abc.csv")
write_csv(docuserve_article_doi_journal_abc, file = readline(prompt="Enter the path and name of the exported journal title csv file: "))
