# Luis E. Santos Burgoa

# GitHub username: suchomlinow

# Repository SSH: git@github.com:suchomlinow/coding-lab-project.git

## Description

Policy question: Which local funds have the largest estimated revenue in Chicago's 2026 budget ordinance?

I want to compare estimated revenue across the local funds listed in Chicago's 2026 budget ordinance. My article will use a simple comparison of estimated revenue by fund to describe the scale of the resources expected to support city activities. This will describe budget estimates; it will not measure actual revenue collected or spending outcomes.

## Data Sources

### Data Source 1: Budget - 2026 Budget Ordinance - Revenue

URL: https://data.cityofchicago.org/Administration-Finance/Budget-2026-Budget-Ordinance-Revenue/nydj-5nax/about_data

Downloaded: 2026-10-10

Local file: data/Budget_-_2026_Budget_Ordinance_-_Revenue_20261010.csv

Size: 156 rows, 6 columns.

Planned use: 156 rows and 4 columns: FUND_CODE, FUND_NAME, REVENUE_SOURCE, ESTIMATED_REVENUE.

Unit of observation: One revenue line item for a local fund in the 2026 budget ordinance. A fund can appear in multiple rows because it has multiple revenue sources.

Subset or filters: None; using the full downloaded 2026 file.

The City of Chicago Data Portal publishes estimated revenue for local funds, with fund codes, fund names, revenue groups, revenue categories, revenue sources, and estimated dollar amounts. I downloaded the CSV into data/, opened it, checked its dimensions and headers, and inspected the first records. The file contains 36 distinct fund codes and no completely duplicated rows. The four columns I plan to use have no blank values.

I will use FUND_CODE and FUND_NAME to identify each fund, REVENUE_SOURCE to understand its revenue line items, and ESTIMATED_REVENUE to compare amounts after grouping the line items by fund. Before adding amounts, I will review the line items to make sure I am not counting subtotals along with their components.

Initial data checks and limitations:

- ESTIMATED_REVENUE contains dollar signs and commas, such as $4,894,443. I will need to convert these values to numbers before calculating totals.
- FUND_CODE is an identifier, so I will preserve leading zeros, such as 0100, by reading it as text.
- REVENUE_GROUP_TYPE and REVENUE_CATEGORY are each blank in 101 rows. These blanks should not be interpreted as zero revenue; I will not rely on those two columns for the initial comparison.
- These are estimates for one budget year, not actual collections. This file alone cannot show trends over time or whether public services are adequately funded.

## Questions

None at this time.
