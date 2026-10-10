# PPHA 30110: Lectures 1 and 2
# Example: Chicago's 2026 Budget Ordinance - Revenue
# Open coding-lab-project.Rproj before running this script.
# Save this file as code/1-load-clean-inspect.R inside that project.
# Run one line at a time: Command+Enter (Mac) or Ctrl+Enter (Windows).
# Source CSV: data/Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv
# The script reads the CSV and creates objects in memory. It does not overwrite it.

# 1. Lecture 1: first R commands --------------------------------------------
# An R script saves instructions. The Console displays their results.
7 + 5
12 / 3
2^3

# <- assigns a value to a name. # starts a comment.
my_number <- 3
my_number * 4
my_number <- 5
my_number * 4
hours <- 24 * 2
hours
sqrt(16)
mean(c(3, 4, 5))
7 > 5
7 == 5

# The project root should contain data/ and code/.
getwd()
list.files()
list.files("data")

# Install once if needed, in the Console:
# install.packages("tidyverse")
# Load in each new session:
library(tidyverse)

# Lecture 1 ends with a preview of section 4, reading the downloaded CSV.
# Lecture 2 works through sections 2-7. Section 8 is optional practice.

# 2. Vectors: synthetic practice values ------------------------------------
amounts <- c(10, 20, 30)
funds <- c("0100", "0200", "0300")
amounts
funds
length(amounts)
class(amounts)
class(funds)
amounts > 15

mixed <- c(10, "20", 30)
mixed
class(mixed)

# R positions start at 1.
amounts[1]
amounts[c(1, 3)]
amounts[-2]
amounts * 2
sum(amounts)
amounts[amounts > 15]

# NA means missing. It is different from a recorded zero.
example <- c(10, NA, 30)
is.na(example)
mean(example)
mean(example, na.rm = TRUE)
# na.rm affects this calculation; it does not change example.

# Exercise: predict these results before running them.
practice <- c(5, 15, NA, 25)
practice[c(1, 4)]
is.na(practice)
sum(practice, na.rm = TRUE)

# 3. Lists, data frames, and tibbles ----------------------------------------
project <- list(city = "Chicago", year = 2026, amounts = amounts)
str(project)
project["year"]     # A smaller list
project[["year"]]   # The value inside
project$year        # The value, accessed by name

mini_budget <- data.frame(fund = funds, amount = amounts)
mini_budget
mini_budget[1, ]    # First row, all columns
mini_budget[1, 2]   # First row, second column
mini_budget$amount  # One column as a vector

mini_tbl <- tibble(fund = funds, amount = amounts)
mini_tbl

# 4. Load the actual downloaded data ---------------------------------------
# This path starts at the project root, even though the script is in code/.
data_file <- file.path(
  "data",
  "Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv"
)

# Read all columns as character for this first inspection.
# FUND_CODE is an identifier, so preserve leading zeros such as "0100".
budget_raw <- read_csv(
  data_file,
  col_types = cols(.default = col_character())
)

# 5. Inspect and make a working copy ---------------------------------------
dim(budget_raw)     # Rows, then columns: 156 and 6 in the October 10 download
nrow(budget_raw)
ncol(budget_raw)
names(budget_raw)
head(budget_raw)
glimpse(budget_raw)
# Run this interactively to open the RStudio viewer:
# View(budget_raw)

budget_raw$FUND_CODE[1:3]
class(budget_raw$ESTIMATED_REVENUE)
budget_raw$ESTIMATED_REVENUE[1:3]

# Convert this file's dollar strings into numeric amounts.
parse_number("$4,894,443")
budget <- budget_raw
budget$ESTIMATED_REVENUE <-
  parse_number(budget_raw$ESTIMATED_REVENUE)

# Check type, example values, and whether conversion introduced missingness.
class(budget$ESTIMATED_REVENUE)
budget$ESTIMATED_REVENUE[1:3]
sum(is.na(budget_raw$ESTIMATED_REVENUE))
sum(is.na(budget$ESTIMATED_REVENUE))

# Missing descriptions do not mean zero revenue. Keep these rows for now.
sum(is.na(budget$REVENUE_GROUP_TYPE))  # 101
sum(is.na(budget$REVENUE_CATEGORY))    # 101
length(unique(budget$FUND_CODE))       # 36
summary(budget$ESTIMATED_REVENUE)
# This is a summary of line items, not fund totals.

# 6. Inspect with dplyr ----------------------------------------------------
# select() chooses columns. Assignment saves the result.
budget_view <- select(
  budget, FUND_CODE, REVENUE_SOURCE, ESTIMATED_REVENUE
)
head(budget_view)

# filter() chooses rows. Character values need quotation marks.
corporate <- filter(budget_view, FUND_CODE == "0100")
head(corporate)
filter(budget_view,
       FUND_CODE == "0100" & ESTIMATED_REVENUE > 1e8)
filter(budget_view, FUND_CODE %in% c("0100", "0200"))

# arrange() sorts. desc() means largest first.
arrange(corporate, ESTIMATED_REVENUE)
arrange(corporate, desc(ESTIMATED_REVENUE))

# %>% means "and then". Run the entire pipeline together.
largest_items <- budget %>%
  filter(FUND_CODE == "0100") %>%
  select(REVENUE_SOURCE, ESTIMATED_REVENUE) %>%
  arrange(desc(ESTIMATED_REVENUE))
head(largest_items, 3)

# 7. Your turn -------------------------------------------------------------
# Create large_corporate using budget:
# - Keep Corporate Fund rows with revenue above 100,000,000.
# - Keep REVENUE_SOURCE and ESTIMATED_REVENUE.
# - Sort amounts from largest to smallest.
# - Count the retained rows with nrow().
# Explain what a row represents. Does this compare total revenue across funds?
# The solution is in the lecture appendix.

# 8. Optional Module 4 preview ---------------------------------------------
# if chooses a branch based on one logical result.
if (any(is.na(budget$ESTIMATED_REVENUE))) {
  print("Inspect the missing revenue amounts.")
} else {
  print("No missing revenue amounts.")
}

# ifelse chooses a value for each element. These are synthetic practice values.
ifelse(c(10, 20, NA) > 15, "Above 15", "15 or less")
x <- c(10, 20, NA)
case_when(
  is.na(x) ~ NA_character_,
  x >= 20 ~ "At least 20",
  x >= 15 ~ "15 to below 20",
  TRUE ~ "Below 15"
)

# Interpretation: this dataset describes estimates, not actual collections.
# Before calculating fund totals, review whether any rows are subtotals.
# Creating indicators and aggregation belong to a later lesson.
# Sources: Harris Coding Camp Standard Track (Summer 2026), Modules 3, 4, and 5.
# https://data.cityofchicago.org/Administration-Finance/Budget-2026-Budget-Ordinance-Revenue/nydj-5nax/about_data
# https://readr.tidyverse.org/reference/parse_number.html
# https://dplyr.tidyverse.org/reference/filter.html
