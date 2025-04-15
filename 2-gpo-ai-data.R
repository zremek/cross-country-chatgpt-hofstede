library(tidyverse)
library(sjPlot)
library(DataExplorer)
library(readxl)

# source https://utoronto.sharepoint.com/sites/ArtSci-SRI-External/_layouts/15/download.aspx?SourceUrl=%2Fsites%2FArtSci%2DSRI%2DExternal%2FDocuments%2FGPO%2DAI%5FFinal%20Version%5FMay%2027%5Fupdated%2Epdf 


gpoai_data <- read_xlsx("already_used_chatgpt.xlsx")

hofstede_data$country <- stringr::str_to_title(hofstede_data$country)

d <- left_join(gpoai_data, hofstede_data)


# no hofstede for South Africa United Kingdom and United States 


# DataExplorer::create_report(d)


