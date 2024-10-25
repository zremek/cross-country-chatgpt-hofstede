library(tidyverse)
library(rvest)


# from https://www.theculturefactor.com/country-comparison-tool

# example 

hofstede_data_example <- tibble(
  country = c("Argentina", "Australia"),
  pwr_dist = c(49, 38),
  indiv = c(51, 73),
  achiev_succes = c(56, 61),
  unct_avoid = c(86, 51),
  long_term = c(29, 56),
  indulg = c(62, 71)
)



# Read the HTML file
html_file <- "cult-dim.html"
html_content <- read_html(html_file)

# Extract country names and associated Hofstede dimensions
countries <- html_content %>% html_nodes("h4.fadeInUp") %>% html_text()

power_distance <- html_content %>% html_nodes("span.power-distance") %>% html_text() %>% as.numeric()
individualism <- html_content %>% html_nodes("span.individualism") %>% html_text() %>% as.numeric()
motivation <- html_content %>% html_nodes("span.motivation") %>% html_text() %>% as.numeric()
uncertainty_avoidance <- html_content %>% html_nodes("span.uncertainty-avoidance") %>% html_text() %>% as.numeric()
long_term_orientation <- html_content %>% html_nodes("span.long-term-orientation") %>% html_text() %>% as.numeric()
indulgence <- html_content %>% html_nodes("span.indulgence") %>% html_text() %>% as.numeric()

# Combine extracted data into a tibble
hofstede_data <- tibble(
  country = countries,
  pwr_dist = power_distance,
  indiv = individualism,
  achiev_succes = motivation,
  unct_avoid = uncertainty_avoidance,
  long_term = long_term_orientation,
  indulg = indulgence
)



all.equal(
  target = hofstede_data %>% filter(country %in% c("Argentina", "Australia")),
  current = hofstede_data_example
) #TRUE



# write_csv(hofstede_data, "hofstede_data_119_countries.csv")

summary(hofstede_data)

