#' Load Sandwich Builder Data
#'
#' Load the downloaded Sandwich Builder data file (i.e., the file in Gorilla's format) and organize it to be R-friendly
#' @param path The path to the location of the Gorilla file as a string. If unspecified, will search in current directory.
#' @param filename The name of the Gorilla file as a string. Include ".csv" at end.
#' @return The organized data file
#' @examples
#' sb_consolidated_data <- load_sb_data(path = "/Users/drewjmclaughlin/Sandwich_Builder/Data/", filename = "data_exp_181483-v11_task-5loo.csv");
#' @export

# Required packages
require(dplyr)
require(tidyr)

# load_sb_data function
load_sb_data <- function(path = getwd(), filename){

  # Basic loading
  setwd(path)
  sb_raw_data <- read.csv(file = filename, header = TRUE)

  # Clean-up
  sb_consolidated_data <- sb_raw_data %>%
    filter(Tag == "final_response") %>%
    separate(Current.Spreadsheet, into = c("Level", "Sheet"), sep = "_") %>%
    select(Participant.Private.ID, Level, Trial.Number, Response, Spreadsheet..answers, Correct)

  # Quick renaming of header
  names(sb_consolidated_data) <- c("Subject", "Level", "Trial", "Response", "Answer", "Correct")

  # Return basic
  return(sb_consolidated_data)
}
