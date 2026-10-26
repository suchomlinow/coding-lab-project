# Lecture 3: Data Manipulation
# Open coding-lab-project.Rproj. Save as code/2-manipulate-summarize.R.
# Run from the top in a new R session. The source CSV is unchanged.

# IMPORT
library(tidyverse)
data_file <- file.path(
  "data",
  "Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv"
)
budget_raw <- read_csv(
  data_file,
  col_types=cols(.default=col_character())
)


# PREPARE
budget <- budget_raw
budget$ESTIMATED_REVENUE <-
  parse_number(budget_raw$ESTIMATED_REVENUE)

dim(budget)
sum(is.na(budget$ESTIMATED_REVENUE)) #Check for missing values

# REVIEW
large_items <- budget %>%
  filter(FUND_CODE == "0100") %>%
  select(FUND_CODE, REVENUE_SOURCE, ESTIMATED_REVENUE) %>%
  arrange(desc(ESTIMATED_REVENUE)) %>%
  rename(
    fund_code = FUND_CODE, 
    revenue_source = REVENUE_SOURCE, 
    revenue = ESTIMATED_REVENUE
  ) %>%
  mutate(revenue_in_millions = revenue / 1e6) %>%
  mutate(z_score = revenue - mean(revenue) / sd(revenue))
  

dim(large_items)


estimated_revenue_by_source <- budget %>%
  group_by(REVENUE_SOURCE) %>%
  summarise(
    average = mean(ESTIMATED_REVENUE) 
  )


  select(REVENUE_SOURCE, ESTIMATED_REVENUE, FUND_CODE) %>%
  arrange(desc(ESTIMATED_REVENUE))


head(large_items, 10)

# RENAME
budget_clean <- budget %>%
  rename(
    fund_code = FUND_CODE,
    fund_name = FUND_NAME,
    revenue_source = REVENUE_SOURCE,
    revenue_group_type = REVENUE_GROUP_TYPE,
    revenue_catergory  = REVENUE_CATEGORY,
    revenue = ESTIMATED_REVENUE
  )
names(budget_clean)

# MUTATE
budget_clean <- budget_clean %>%
  mutate(revenue_millions = revenue / 1e6) %>%
  select(fund_code, revenue, revenue_millions)

glimpse(budget_clean)


  head(3)

# INDICATOR
budget_clean <- budget_clean %>%
  mutate(large_item = revenue >= 1e8)


budget_clean <- budget_clean %>%
  mutate(z_score = revenue - mean(revenue) / sd(reve))


budget_clean %>%
  select(revenue_millions, large_item) %>%
  head(3)

# IFELSE
budget_clean <- budget_clean %>%
  mutate(size_label = ifelse(
    large_item, "At least 100m", "Below 100m"
  ))

# DESCRIPTIVE
summary(budget_clean$revenue_millions)

# SUMMARIZE
item_summary <- budget_clean %>%
  summarise(
    items = n(),
    missing = sum(is.na(revenue)),
    total_m = sum(revenue_millions),
    mean_m = mean(revenue_millions),
    median_m = median(revenue_millions)
  )
item_summary

# MISSING EXAMPLE
practice <- c(10, NA, 30)
sum(practice)
sum(practice, na.rm=TRUE)
sum(is.na(practice))

# AUDIT
budget_clean %>%
  select(fund_code, fund_name, revenue_source,
         revenue_millions) %>%
  arrange(fund_code) %>%
  print(n=12)
sum(duplicated(budget_raw))

# FUND TOTALS
fund_totals <- budget_clean %>%
  group_by(fund_code, fund_name) %>%
  summarise(
    items = n(),
    missing = sum(is.na(revenue)),
    total_revenue = sum(revenue),
    .groups = "drop"
  ) %>%
  arrange(desc(total_revenue))

# TOP FUNDS
fund_totals <- fund_totals %>%
  mutate(total_m = total_revenue / 1e6)
fund_totals %>%
  select(fund_code, total_m, items) %>%
  head(3)

# TOTAL CHECKS
nrow(fund_totals)
anyDuplicated(fund_totals$fund_code)
isTRUE(all.equal(
  sum(fund_totals$total_revenue),
  sum(budget_clean$revenue)
))

# FUND SHARE
fund_totals <- fund_totals %>%
  mutate(share_pct =
    100 * total_revenue / sum(total_revenue))
fund_totals %>%
  select(fund_name, total_m, share_pct) %>%
  head(3)

# WITHIN SHARE
item_shares <- budget_clean %>%
  group_by(fund_code) %>%
  mutate(
    fund_total = sum(revenue),
    within_fund_pct = 100 * revenue / fund_total
  ) %>%
  ungroup()

# LOOKUP
fund_lookup <- budget_clean %>%
  distinct(fund_code, fund_name)
anyDuplicated(fund_lookup$fund_code)

# LEFT JOIN
totals_by_code <- budget_clean %>%
  group_by(fund_code) %>%
  summarise(total_revenue = sum(revenue),
            .groups = "drop")
labeled_totals <- totals_by_code %>%
  left_join(fund_lookup, by="fund_code")

# JOIN CHECK
nrow(totals_by_code)
nrow(labeled_totals)
sum(is.na(labeled_totals$fund_name))

# BIND
corporate_items <- budget_clean %>%
  filter(fund_code == "0100")
other_items <- budget_clean %>%
  filter(fund_code != "0100")
recombined <- bind_rows(corporate_items, other_items)
nrow(recombined)

# ANSWER UNITS
large_items_billions <- budget_clean %>%
  mutate(revenue_billions = revenue / 1e9) %>%
  filter(revenue_billions >= 0.1) %>%
  select(fund_name, revenue_source, revenue_billions) %>%
  arrange(desc(revenue_billions))
head(large_items_billions, 3)

# ANSWER FUNDS
two_funds <- budget_clean %>%
  filter(fund_code %in% c("0100", "0200")) %>%
  group_by(fund_code, fund_name) %>%
  summarise(items = n(),
            total_m = sum(revenue) / 1e6,
            .groups = "drop") %>%
  arrange(desc(total_m))
two_funds %>% select(fund_code, items, total_m)

# CASE
budget_bands <- budget_clean %>%
  mutate(size_band = case_when(
    is.na(revenue) ~ NA_character_,
    revenue >= 1e8 ~ "At least 100m",
    revenue >= 1e7 ~ "10m to below 100m",
    TRUE ~ "Below 10m"
  ))

# MORE STATS
quantile(budget_clean$revenue_millions)
sd(budget_clean$revenue_millions)

# SETS
a <- tibble(code=c("0100", "0200"))
b <- tibble(code=c("0200", "0300"))
dplyr::intersect(a, b)
dplyr::setdiff(a, b)
