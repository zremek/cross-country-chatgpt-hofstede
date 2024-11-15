library(car)
library(sjPlot)
library(sf)
library(scatterpie)
library(table1)
library(tidyverse)


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

# ew. karto ze zmienną zależną, nazwami krajów i populacją

ggsave("cartodiagram_pie.png", plot = cartodiagram_pie,units = "cm", width = 16, height = 10)

# tab1 ze statystkami opisowymi 

table1::table1(~GPTUSE + NETUSE + PDI + IND + ASU + UAI + LTO + 
                 IUG + population, data = df)

# tab corr matrix - no nie wiem...

sjPlot::tab_corr(df %>% dplyr::select(-country),
                 na.deletion = "pairwise", triangle = "lower")

# tabela z modelami jest gotowa i modele opisane 

sjPlot::tab_model(m1_baseline, m2_reduced, m3_core)

sjPlot::tab_model(m4_control, m5_population, m7_arobust)

## Check for multicollinearity among your independent variables using Variance Inflation Factor (VIF). If VIF values are high (typically above 10), consider removing or combining variables.
## car::vif(fitted_lm)

# tabela semi-partial correlations 

# rozrzut IND vs. GPTUSE z etykietami krajów (na koniec wyników)

point_ind_gptuse <-
  ggplot(df) +
  geom_point(aes(x = IND, y = GPTUSE), size = 3) +
  geom_label_repel(
    aes(label = country, x = IND, y = GPTUSE),
    min.segment.length = 0.5,
    force = 1,
    box.padding = 0.5,
    segment.size = 0.2,
    size = 2,
    max.overlaps = Inf,
    fontface = "bold",
    alpha = 0.8
  ) +
  coord_fixed() +
  scale_x_continuous(breaks = c(10, 20, 30, 40, 50, 60, 70, 80)) +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50, 60, 70, 80),
                     expand = expansion(add = 20)) +
  theme_classic() +
  theme(axis.text = element_text(size = 6),
        axis.title = element_text(size = 8))

print(point_ind_gptuse)

ggsave("point_ind_gptuse.png", plot = point_ind_gptuse, units = "cm",
       width = 12, height = 12) # 12 wygląda dobrze, poprawić nazwy osi
