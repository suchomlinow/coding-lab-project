# Load my libraries:

library(tidyverse)

budget_raw <- read_csv("data/Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv")

# Inspect

glimpse(budget_raw)
head(budget_raw)

colnames(budget_raw)
dim(budget_raw)

budget_clean <- budget_raw

budget_clean$ESTIMATED_REVENUE

sum(budget_raw$ESTIMATED_REVENUE)

budget_clean$ESTIMATED_REVENUE <- parse_number(budget_raw$ESTIMATED_REVENUE)

sd(budget_clean$ESTIMATED_REVENUE)


sum(budget_clean$ESTIMATED_REVENUE)

mean(budget_clean$ESTIMATED_REVENUE)

