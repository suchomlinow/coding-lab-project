# Libraries go first!
library(tidyverse)

# Import dataset
budget_raw <- read_csv("data/Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv")

# Inspect
head(budget_raw)

colnames(budget_raw)

dim(budget_raw)

names(budget_raw)

glimpse(budget_raw)

# let's explore our data

budget_raw$ESTIMATED_REVENUE

sum(budget_raw$ESTIMATED_REVENUE)

# Copy of my data set!
budget_clean <- budget_raw



budget_clean$ESTIMATED_REVENUE <- parse_number(budget_raw$ESTIMATED_REVENUE)

sum(budget_clean$ESTIMATED_REVENUE)

var(budget_clean$ESTIMATED_REVENUE)
mean(budget_clean$ESTIMATED_REVENUE)
