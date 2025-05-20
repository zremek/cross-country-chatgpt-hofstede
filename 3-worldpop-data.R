library(tidyverse)
library(readxl)
library(sjPlot)
library(sjmisc)

world_bank_pop %>% summary() # for codes? 


# data source: https://population.un.org/wpp/Download/Standard/Population/ 
# file: https://web.archive.org/web/20241108093430mp_/https://population.un.org/wpp/Download/Files/1_Indicator%20(Standard)/EXCEL_FILES/2_Population/WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx =

p <- read_excel("WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx", 
                            sheet = "Estimates", skip = 16)

p_country_2023 <- p %>% filter(Type == "Country/Area", Year == 2023)

p_21 <- p_country_2023 %>% filter(`Region, subregion, country or area *` %in% d$country) # 20 - sth missing! 

p_21 <- p_21 %>% rename(country = `Region, subregion, country or area *`)

left_join(d, p_21 %>% dplyr::select(country, `Location code`)) %>% print(n = 21)


d[19, 1] <- "United States of America"

p_21_usa <- p_country_2023 %>% filter(`Region, subregion, country or area *` %in% d$country) # 21 :) 

# TODO rowsums and lefjoin 

p_21_usa <- p_21_usa %>% mutate(across(.cols = `0`:`100+`, .fns = as.numeric))

str(p_21_usa)

p_21_usa <- sjmisc::row_sums(x = p_21_usa, `0`:`100+`, n = Inf)

p_join <- p_21_usa %>%
  rename(country = `Region, subregion, country or area *`, 
         population = rowsums) %>% 
  dplyr::select(country, population)

d <- left_join(d, p_join)

# population is in K, make it in 1: 

d <- d %>% mutate(population = population * 1000)
