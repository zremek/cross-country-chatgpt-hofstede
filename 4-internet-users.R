library(tidyverse)
library(readxl)
library(sjPlot)
library(sjmisc)

# source https://data.worldbank.org/indicator/IT.NET.USER.ZS 

users <- read_excel(
  "API_IT.NET.USER.ZS_DS2_en_excel_v2_10876.xls",
  sheet = "Data",
  skip = 3
)

u <- users %>% dplyr::select(`Country Name`, `2020`:`2023`)

u <- u %>% mutate(
  internet = coalesce(`2023`, `2022`, `2021`, `2020`)
)

u <- u %>% dplyr::rename(country = `Country Name`)

u[252, 1] <- "United States of America"

du <- left_join(d, u %>% dplyr::select(country, internet))


