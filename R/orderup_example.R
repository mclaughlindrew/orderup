# How to use the "orderup" package to process Sandwich Builder data
#
# Author: Drew J. McLaughlin
# Last updated: August 8, 2024
# Purpose: Example code for how to use orderup to load, score, and plot data downloaded from Gorilla

# Load orderup package
library(orderup)

# Other packages you will need:
library(dplyr)
library(tidyr)
library(devtools)
library(readr)
library(ggplot2)
library(Rmisc)
library(stringr)


#### STEP 1: Load your "raw" Gorilla files ####

# Option 1: Load a specific, single file
sb_consolidated_data <- load_sb_data(path = "/Users/drewjmclaughlin/Dropbox/2022_BCBL/Projects/Sandwich_Builder/Data/Session1/SB",
                                     filename = "data_exp_181483-v11_task-5loo.csv")

# Option 2: Load an entire folder of files
# (for example, when you have two files from different "versions" of a Gorilla experiment)
sb_consolidated_data <- load_sb_data_multi(path = "/Users/drewjmclaughlin/Dropbox/2022_BCBL/Projects/Sandwich_Builder/Data/Session1/SB")


#### STEP 2: Score your Sandwich Builder data ####

# This function calculates base and partial credit and sums them into a single final score
sb_scored_data <- score_sb_data(file = sb_consolidated_data)


#### OPTIONAL: Look at the distribution of data from McLaughlin & Samuel ####

# Load the original score distribution (from Session 1 of "Lettuce Entertain You")
sb_distribution_data <- load_sb_distribution()

# Get median for the plot
plot_median <- median(sb_distribution_data$SB_score)

# Quick plot of distribution
ggplot(sb_distribution_data, aes(x = SB_score)) +
  geom_histogram(color = "black", fill = "coral") +
  geom_vline(xintercept = plot_median, linetype = 2) +
  theme_classic(base_size = 12) +
  ggtitle("Distribution from McLaughlin & Samuel (N = 249)") +
  xlim(c(1, 10)) +
  scale_x_continuous(breaks = c(1, 2.5, 5, 7.5, 10)) +
  xlab("Sandwich Builder Score") +
  ylab("Number of subjects")


#### OPTIONAL: Get percentiles to compare against your data ####
# Note: I plan to update this in a few years with a bigger dataset. As of August 2024 this is a relatively small
#       amount of data to calculate percentiles from -- use with caution!

sb_percentiles <- data.frame("SB_score" = quantile(sb_distribution_data$SB_score, probs = seq(.01, 1.0, .01)),
                             "Percentile" = seq(.01, 1.0, .01))

# Consolidate with an estimate of range included
# Note: Not enough data here in particular -- it would be great to get CIs in the future...
sb_percentile_summary <- sb_percentiles %>%
  dplyr::group_by(SB_score) %>%
  dplyr::summarise(Percentile = mean(Percentile))

# Add percentiles to YOUR Sandwich Builder scored data
# i.e., determine each participant's percentile ranking
sb_scored_data <- left_join(sb_scored_data, sb_percentile_summary)
