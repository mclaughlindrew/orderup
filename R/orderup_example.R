# Example script using the orderup package

sb_consolidated_data <- load_sb_data(path = "/Users/drewjmclaughlin/Dropbox/2022_BCBL/Projects/Sandwich_Builder/Data/Session1/SB",
                                     filename = "data_exp_181483-v11_task-5loo.csv")


# Get median for the plot
plot_median <- median(sb_distribution_data$SB_score)

# Quick plot of distribution
quick_plot <- ggplot(sb_distribution_data, aes(x = SB_score)) +
  geom_histogram(color = "black", fill = "coral") +
  geom_vline(xintercept = plot_median, linetype = 2) +
  theme_classic(base_size = 12) +
  ggtitle("Distribution from McLaughlin & Samuel (N = 249)") +
  xlim(c(1, 10)) +
  scale_x_continuous(breaks = c(1, 2.5, 5, 7.5, 10)) +
  xlab("Sandwich Builder Score") +
  ylab("Number of subjects")
