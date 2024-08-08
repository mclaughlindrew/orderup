#' Load Sandwich Builder Data (Multiple Files)
#'
#' Load multiple downloaded Sandwich Builder data files (i.e., the files in Gorilla's format) from the same directory. Directory should only contain the Sandwich Builder files (no other CSVs). Function will combine and organize the multiple files into one R-friendly file.
#' @param path The path to the location of the Gorilla files as a string. If unspecified, will search in current directory.
#' @return The combined and organized data file
#' @examples
#' sb_consolidated_data <- load_sb_data_multi(path = "/Users/drewjmclaughlin/Sandwich_Builder/Data/");
#' @export

# Required packages
require(dplyr)
require(tidyr)

# load_sb_data function
load_sb_data_multi <- function(path = getwd()){

  # Load and combine all files in this directory
  sb_raw_data <- list.files(path = path,
                        pattern = "*.csv", full.names = TRUE) %>%
    lapply(read.csv) %>%
    bind_rows()

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
