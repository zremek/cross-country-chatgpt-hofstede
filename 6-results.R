library(car)
library(sjPlot)
library(sf)
library(scatterpie)
library(table1)
library(tidyverse)


# fix var names #### 

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

# cartodiagram pie #### 

library(rnaturalearth)
library(rnaturalearthdata)
library(ggrepel)
library(ggnewscale)


world <- ne_countries(scale = "medium", returnclass = "sf")

# Merge with your data
# Ensure your dataframe 'd' has a column 'country_code' with ISO A3 country codes
world_data <- left_join(world, d, by = join_by(name == country))
world_data <- cbind(world_data, st_coordinates(st_centroid(world_data$geometry)))

world_data_21 <- st_drop_geometry(world_data) %>% 
  filter(!is.na(already_used_chatgpt_pct_yes))

# Add a column for the remaining percentage
world_data_21$remaining_pct <- 100 - world_data_21$already_used_chatgpt_pct_yes

world_data_21$pop_radius <- sqrt(world_data_21$population) / 2500

####### mappping 
base_map_pie <- ggplot(data = world_data %>% 
                         filter(sov_a3 != "ATA")) +
  geom_sf(aes(fill = !is.na(already_used_chatgpt_pct_yes)), lwd = 0.1) +
  scale_fill_manual(values = c("gray95", "gray99")) +
  guides(fill = "none") +
  new_scale_fill() +
  coord_sf()



# Add pie charts to represent population size and ChatGPT usage
cartodiagram_pie <- base_map_pie +
  geom_scatterpie(aes(x = label_x, y = label_y, r = pop_radius),
                  data = world_data_21 %>% filter(name != "Pakistan"),
                  cols = c("already_used_chatgpt_pct_yes", "remaining_pct"),
                  donut_radius = 0, sorted_by_radius = FALSE, 
                  color = NA,
                  alpha = 0.9) +
  geom_scatterpie(aes(x = label_x, y = label_y, r = pop_radius),
                  data = world_data_21 %>% filter(name == "Pakistan"),
                  cols = c("already_used_chatgpt_pct_yes", "remaining_pct"),
                  donut_radius = 0, sorted_by_radius = FALSE, 
                  color = NA,
                  alpha = 0.9) +
  geom_label_repel(data = world_data_21,
                   aes(label = name, x = label_x, y = label_y),
                   min.segment.length = 0.5, force = 1, box.padding = 0.5,
                   nudge_x = 1, 
                   nudge_y = -4, segment.size = 0.2, size = 2, max.overlaps = Inf, 
                   fontface = "bold", alpha = 0.8) +
  # new_scale_fill() +
  scale_fill_manual(values = c("darkorange3", "lightblue"),
                    name = "GPTUSE: Have you already used ChatGPT? (%)",
                    labels = c("Yes", "No")) +
  geom_scatterpie_legend(radius = world_data_21$pop_radius,
                         x = -150, y = -40, n = 3,
                         labeller = function(x) ((x * 2500)^2) / 1e6, 
                         breaks = c(sqrt(100 * 1e6) / 2500,
                                    sqrt(300 * 1e6) / 2500,
                                    sqrt(1000 * 1e6) / 2500), 
                         size = 3) +
  annotate("text", label = "Population\n(Millions of people)", x = -150, y = -10, size = 3) +
  theme_classic() + 
  theme(legend.position = "bottom", 
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(), 
        legend.text = element_text(size = 8), 
        legend.title = element_text(size = 8))





# ggsave("cartodiagram_pie.png", plot = cartodiagram_pie, units = "cm", width = 16, height = 10)

# tab1 #### 

table1::table1(~GPTUSE + NETUSE + PDI + IND + ASU + UAI + LTO + 
                 IUG + population, data = df)

# tab corr matrix

sjPlot::tab_corr(df %>% dplyr::select(-country),
                 na.deletion = "pairwise", triangle = "lower")

# TODO models #### 

sjPlot::tab_model(m1_baseline, m2_reduced, m3_core)

sjPlot::tab_model(m4_control, m5_population, m7_arobust)

## Check for multicollinearity among your independent variables using Variance Inflation Factor (VIF). If VIF values are high (typically above 10), consider removing or combining variables.
## car::vif(fitted_lm)

# tabela semi-partial correlations 


