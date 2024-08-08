#' Load Sandwich Builder Distribution
#'
#' Load the distribution of participants scores from the validation paper of Sandwich Builder (the "Lettuce Entertain You" paper; McLaughlin & Samuel).
#' @return The organized data file
#' @export

# Required packages
require(devtools)
require(readr)
require(ggplot2)

# load_sb_distribution function
load_sb_distribution <- function(){

  # Download data from GitHub
  sb_distribution_data <- read_csv(url("https://raw.githubusercontent.com/mclaughlindrew/orderup/master/sb_distribution.csv"))

  # Return dataframe
  return(sb_distribution_data)
}
