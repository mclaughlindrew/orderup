#' Score Sandwich Builder Data
#'
#' Takes dataframe from load_sb_data (or load_sb_data_multi) function and returns scored dataframe. Also excludes any "bad" subjects (those who fail to pass Level 1).
#' @param file The dataframe of Sandwich Builder data (from load_sb_data/load_sb_data_multi).
#' @return The scored data file
#' @examples
#' sb_scored_data <- score_sb_data(file = sb_consolidated_data);
#' @export

# Required packages
require(dplyr)
require(tidyr)

# load_sb_data function
score_sb_data <- function(file){

  # Remove practice trial
  file <- file %>% filter(Trial != 1)

  # Create a "tally" spreadsheet (how many times each level was passed)
  sb_tally <- file %>%
    dplyr::group_by(Subject, Level) %>%
    dplyr::summarise(Tally = sum(Correct), Attempts = length(Correct)) %>%
    mutate(Level_N = str_remove(Level, "Level"))

  # Make Level_N a numeric...
  sb_tally$Level_N <- as.numeric(sb_tally$Level_N)

  # Get the level they passed the most often...
  max_tally <- sb_tally %>%
    dplyr::group_by(Subject) %>%
    dplyr::filter(Tally == max(Tally))

  # CHECK FOR BAD PARTICIPANTS
  # If their best tally is 0, then they should be excluded...
  bad_subjects <- max_tally %>%
    filter(Tally == 0)
  bad_subjects <- unique(bad_subjects$Subject)

  if(length(bad_subjects) != 0) {
    # Messages to alert the researcher to any dropped subjects...
    message(paste("Failed to pass Level 1, thus excluded from dataset:"))
    for(each in bad_subjects){
      message(each)
    }

    # REMOVE BAD PARTICIPANTS
    for(each in bad_subjects) {
      sb_tally <- sb_tally %>%
        filter(Subject != each)
    }
  }

  # SANDWICH BUILDER SCORING
  # For each subject, we'll determine their base score and resolve any ties
  # Tie-breaking rule: If there's a tie, the higher level wins!

  # Base score = highest level passed 2 or more times
  base_scores <- sb_tally %>%
    dplyr::group_by(Subject) %>%
    dplyr::filter(Tally >= 2) %>%
    dplyr::group_by(Subject) %>%
    dplyr::filter(Level_N == max(Level_N))

  # DETERMINE PARTIAL CREDIT SCORE
  # Initialize a vector of the Subject IDs
  subject_vector <- unique(base_scores$Subject)

  # Loop through iteratively by subject ID
  for(this_subject in subject_vector){

    # Get this subject's data separated
    subject_base_scores_df <- base_scores %>% filter(Subject == this_subject)
    subject_tally_scores_df <- sb_tally %>% filter(Subject == this_subject)

    # Get their base score level number
    base_level_n <- subject_base_scores_df$Level_N[1]

    # Subset their tally df to include all tallies above the base score
    above_base_df <- subject_tally_scores_df %>% filter(Level_N > base_level_n)

    # Sum any passes to count toward partial credit
    subject_partial_tally <- sum(above_base_df$Tally)

    # Make a lil dataframe
    this_subject_base_and_partial_df <- data.frame("Subject" = this_subject, "Base_score" = base_level_n, "Partial_tally" = subject_partial_tally)

    # Append dataframes together
    if(this_subject == subject_vector[1]){
      base_and_partial_scores_df <- this_subject_base_and_partial_df
    } else {
      base_and_partial_scores_df <- rbind(base_and_partial_scores_df, this_subject_base_and_partial_df)
    }
  }

  # PARTIAL CREDIT: For every tally, 0.5 credits added to base score
  sb_final_scores <- base_and_partial_scores_df %>%
    mutate(SB_score = Base_score + Partial_tally*0.5) %>%
    select(Subject, SB_score)

  # Return the final dataframe
  return(sb_final_scores)

}
