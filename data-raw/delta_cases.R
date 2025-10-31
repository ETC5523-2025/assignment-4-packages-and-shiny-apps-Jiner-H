## data-raw/delta_cases.R
## This script reconstructs a synthetic dataset based on
## "COVID-19 in low-tolerance border quarantine systems: Impact of the Delta variant of SARS-CoV-2"
## PMC8993115. The data are simulated for teaching purposes, not original study data.

library(dplyr)
library(lubridate)

# 1. create a sequence of months (or weeks)
dates <- seq(as.Date("2020-11-01"), as.Date("2021-10-01"), by = "month")

# 2. define which months are Delta period (roughly mid-2021 onwards)
delta_start <- as.Date("2021-06-01")

delta_cases <- tibble(
  date = dates,
  period = if_else(date < delta_start, "pre-delta", "delta"),
  variant = if_else(date < delta_start, "pre-Delta-variant", "Delta"),
  arrivals = if_else(date < delta_start,
                     sample(1000:1500, length(dates), replace = TRUE),
                     sample(700:1100,  length(dates), replace = TRUE))
) %>%
  # detected cases in quarantine: higher when Delta is around
  mutate(
    detected_in_quarantine = if_else(
      period == "pre-delta",
      rpois(n(), lambda = 5),
      rpois(n(), lambda = 14)
    ),
    # leakage events: rare before Delta, a bit more during Delta
    leakage = if_else(
      period == "pre-delta",
      rbinom(n(), size = 1, prob = 0.15),
      rbinom(n(), size = 2, prob = 0.35)
    ),
    # local cases resulting from leakage: base + extra for Delta
    local_cases = if_else(
      period == "pre-delta",
      rpois(n(), lambda = 2 * leakage),
      rpois(n(), lambda = 10 * leakage + 5)
    )
  ) %>%
  # compute rates for easier plotting in Shiny
  mutate(
    leakage_per_1000_arrivals = round(leakage / arrivals * 1000, 3),
    detected_rate = round(detected_in_quarantine / arrivals * 1000, 3)
  )

# save to data/ as an .rda so package can load it
usethis::use_data(delta_cases, overwrite = TRUE)

