library(car)
library(sjPlot)
library(sf)
library(scatterpie)
library(table1)
library(tidyverse)


# TODO 
# nazwy i kolejność zmiennych z du

df <- du[, c(1:2, 10, 3:9)]

df <- df %>% 
  rename(
    GPTUSE = already_used_chatgpt_pct_yes, 
    NETUSE = internet,
    PDI = pwr_dist, 
    IND = indiv, 
    ASU = achiev_succes, 
    UAI = unct_avoid, 
    LTO = long_term,
    IUG = indulg
  )

# karto ze zmienną zależną, nazwami krajów i populacją

# tab1 ze statystkami opisowymi 

table1::table1(~GPTUSE + NETUSE + PDI + IND + ASU + UAI + LTO + 
                 IUG + population, data = df)

# tabela z modelami 

## Check for multicollinearity among your independent variables using Variance Inflation Factor (VIF). If VIF values are high (typically above 10), consider removing or combining variables.
## car::vif(fitted_lm)

# tabela semi-partial correlations 
