library(tidyverse)
library(readxl)

world_bank_pop %>% summary() # for codes? 


# data source: https://population.un.org/wpp/Download/Standard/Population/ 

p <- read_excel("WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx", 
                            sheet = "Estimates", skip = 16)

p_country_2023 <- p %>% filter(Type == "Country/Area", Year == 2023)

p_21 <- p_country_2023 %>% filter(`Region, subregion, country or area *` %in% d$country) # 20 - sth missing! 

p_21 <- p_21 %>% rename(country = `Region, subregion, country or area *`)

left_join(d, p_21 %>% dplyr::select(country, `Location code`)) %>% print(n = 21)


d[19, 1] <- "United States of America"

p_21_usa <- p_country_2023 %>% filter(`Region, subregion, country or area *` %in% d$country) # 21 :) 

# TODO rowsums and lefjoin 