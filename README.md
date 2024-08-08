# orderup

A mini R package to support Sandwich Builder data processing. See "Lettuce Entertain You" (McLaughlin & Samuel, under review) for more details.

<p align="center"><img src="https://github.com/mclaughlindrew/orderup/blob/master/SB_icon.png" height="200px" width="200px" />

# Installation Guide

``` r
# you'll need devtools (if you don't have it)
install.packages("devtools")
library(devtools)

# install orderup directly from GitHub
remotes::install_github("mclaughlindrew/orderup")
``` 

# Two Steps

``` r
#### STEP 1: Load your "raw" Gorilla files ####

# Option 1: Load a specific, single file
sb_consolidated_data <- load_sb_data(path = "/Users/drewjmclaughlin/SB",
                                     filename = "data_exp_181483-v11_task-5loo.csv")

# Option 2: Load an entire folder of files
# (for example, when you have two files from different "versions" of a Gorilla experiment)
sb_consolidated_data <- load_sb_data_multi(path = "/Users/drewjmclaughlin/SB")


#### STEP 2: Score your Sandwich Builder data ####

# This function calculates base and partial credit and sums them into a single final score
sb_scored_data <- score_sb_data(file = sb_consolidated_data)

```
