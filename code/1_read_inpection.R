# Libraries

library(tidyverse)

budget_df <- read_csv("data/Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv")

# Inspect the dataset

#Visual inspection

# R inspection

dim(budget_df)

names(budget_df)

head(budget_df)

glimpse(budget_df)

# Slice some columns

col_revenue <- budget_df$ESTIMATED_REVENUE

budget_df2 <- budget_df

budget_df2$ESTIMATED_REVENUE <- parse_number(budget_df$ESTIMATED_REVENUE)

mean(budget_df2$ESTIMATED_REVENUE)

sum(budget_df2$ESTIMATED_REVENUE)

count(budget_df2$ESTIMATED_REVENUE)

budget_filter <- budget_df2 %>%
  select(
    FUND_CODE, REVENUE_SOURCE, ESTIMATED_REVENUE
  ) %>%
  filter(
    ESTIMATED_REVENUE > 1000000
  ) %>%
  mutate(
    AVERAGE = ESTIMATED_REVENUE / sum(ESTIMATED_REVENUE)
  )
