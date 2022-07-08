# Install all dependencies
install.packages("tidyverse")
install.packages("readxl")
# https://readxl.tidyverse.org/
library("readxl")
library("tidyverse")
# place excel files for analysis in the /data/ folder
docuserve_data <-read_xlsx("./data/2021_docuserve_borrowing_requests.xlsx")
