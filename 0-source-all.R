# source all

scripts <- c("1-cultural-dim-hofstede-data.R", 
             "2-gpo-ai-data.R",
             "3-worldpop-data.R",              
             "4-internet-users.R",
             "6-results.R")

lapply(scripts, source)
