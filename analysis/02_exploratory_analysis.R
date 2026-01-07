# Personnel Performance Analysis - Exploratory Data Analysis
# Author: Kamil Nazaruk
# Description: Statistical analysis of training effectiveness and performance metrics

# Load required libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape2)
library(scales)

# Set theme for consistent visualizations
theme_set(theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom"
  ))

# Function to load and prepare data
load_performance_data <- function(filepath) {
  cat("Loading performance data...\n")
  data <- read.csv(filepath)
  cat(sprintf("Loaded %d records with %d variables\n", nrow(data), ncol(data)))
  return(data)
}

# Function to generate summary statistics
summarize_performance <- function(data) {
  cat("\n=== PERFORMANCE SUMMARY STATISTICS ===\n")

  summary_stats <- data %>%
    group_by(training_program) %>%
    summarise(
      n = n(),
      mean_score = mean(performance_score, na.rm = TRUE),
      sd_score = sd(performance_score, na.rm = TRUE),
      median_score = median(performance_score, na.rm = TRUE),
      min_score = min(performance_score, na.rm = TRUE),
      max_score = max(performance_score, na.rm = TRUE)
    ) %>%
    arrange(desc(mean_score))

  print(summary_stats)
  return(summary_stats)
}

# Function to plot performance distribution
plot_performance_distribution <- function(data) {
  p <- ggplot(data, aes(x = performance_score, fill = training_program)) +
    geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
    geom_vline(aes(xintercept = mean(performance_score)),
               color = "red", linetype = "dashed", size = 1) +
    labs(
      title = "Performance Score Distribution by Training Program",
      subtitle = "Red line indicates overall mean performance",
      x = "Performance Score",
      y = "Frequency",
      fill = "Training Program"
    ) +
    scale_fill_brewer(palette = "Set2") +
    theme(legend.position = "bottom")

  print(p)
  ggsave("visualizations/performance_distribution.png", width = 10, height = 6, dpi = 300)
  return(p)
}

# Function to compare training program effectiveness
plot_training_effectiveness <- function(data) {
  p <- ggplot(data, aes(x = reorder(training_program, performance_score, FUN = median),
                        y = performance_score, fill = training_program)) +
    geom_boxplot(alpha = 0.7, outlier.shape = 21, outlier.size = 2) +
    geom_jitter(width = 0.2, alpha = 0.3, size = 1) +
    coord_flip() +
    labs(
      title = "Training Program Effectiveness Comparison",
      subtitle = "Box plots show median, quartiles, and outliers",
      x = "Training Program",
      y = "Performance Score",
      fill = "Program"
    ) +
    scale_fill_brewer(palette = "Set3") +
    theme(legend.position = "none")

  print(p)
  ggsave("visualizations/training_effectiveness.png", width = 10, height = 6, dpi = 300)
  return(p)
}

# Function to analyze correlation between variables
plot_correlation_heatmap <- function(data) {
  # Select numeric variables
  numeric_vars <- data %>%
    select_if(is.numeric) %>%
    select(-c(id))  # Remove ID column if exists

  # Calculate correlation matrix
  cor_matrix <- cor(numeric_vars, use = "complete.obs")

  # Melt for ggplot
  cor_melted <- melt(cor_matrix)

  p <- ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile(color = "white") +
    geom_text(aes(label = sprintf("%.2f", value)), size = 3) +
    scale_fill_gradient2(low = "#e74c3c", mid = "white", high = "#3498db",
                         midpoint = 0, limit = c(-1, 1),
                         name = "Correlation") +
    labs(
      title = "Performance Metrics Correlation Heatmap",
      subtitle = "Identifying key performance drivers",
      x = "", y = ""
    ) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  print(p)
  ggsave("visualizations/correlation_heatmap.png", width = 10, height = 8, dpi = 300)
  return(cor_matrix)
}

# Function to analyze performance trends over time
plot_performance_trends <- function(data) {
  if (!"date" %in% colnames(data)) {
    cat("Warning: 'date' column not found. Skipping trend analysis.\n")
    return(NULL)
  }

  trend_data <- data %>%
    mutate(month = format(as.Date(date), "%Y-%m")) %>%
    group_by(month, training_program) %>%
    summarise(
      avg_performance = mean(performance_score, na.rm = TRUE),
      n = n()
    )

  p <- ggplot(trend_data, aes(x = month, y = avg_performance,
                              group = training_program, color = training_program)) +
    geom_line(size = 1.2) +
    geom_point(size = 3) +
    labs(
      title = "Performance Trends Over Time",
      subtitle = "Monthly average performance by training program",
      x = "Month",
      y = "Average Performance Score",
      color = "Training Program"
    ) +
    scale_color_brewer(palette = "Set1") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  print(p)
  ggsave("visualizations/performance_trends.png", width = 12, height = 6, dpi = 300)
  return(p)
}

# Function to perform statistical hypothesis testing
analyze_training_programs <- function(data) {
  cat("\n=== STATISTICAL HYPOTHESIS TESTING ===\n")

  # ANOVA: Test if there are significant differences between training programs
  anova_result <- aov(performance_score ~ training_program, data = data)
  cat("\nANOVA Results (Training Program Effect):\n")
  print(summary(anova_result))

  # Post-hoc pairwise t-tests
  pairwise_result <- pairwise.t.test(data$performance_score,
                                     data$training_program,
                                     p.adjust.method = "bonferroni")
  cat("\nPairwise Comparisons (Bonferroni corrected):\n")
  print(pairwise_result)

  # Effect size (eta-squared)
  ss_total <- sum((data$performance_score - mean(data$performance_score))^2)
  ss_between <- sum(anova_result$fitted.values - mean(data$performance_score))^2
  eta_squared <- ss_between / ss_total

  cat(sprintf("\nEffect Size (η²): %.4f\n", eta_squared))

  if (eta_squared < 0.01) {
    cat("Small effect\n")
  } else if (eta_squared < 0.06) {
    cat("Medium effect\n")
  } else {
    cat("Large effect\n")
  }

  return(list(anova = anova_result, pairwise = pairwise_result, eta_squared = eta_squared))
}

# Generate comprehensive report
generate_analysis_report <- function(data) {
  cat("\n" , rep("=", 60), "\n", sep = "")
  cat("PERSONNEL PERFORMANCE ANALYSIS REPORT\n")
  cat(rep("=", 60), "\n\n", sep = "")

  cat("Dataset Overview:\n")
  cat(sprintf("  Total Records: %d\n", nrow(data)))
  cat(sprintf("  Variables: %d\n", ncol(data)))
  cat(sprintf("  Training Programs: %d\n", length(unique(data$training_program))))
  cat(sprintf("\nOverall Performance:\n"))
  cat(sprintf("  Mean Score: %.2f\n", mean(data$performance_score, na.rm = TRUE)))
  cat(sprintf("  Std Dev: %.2f\n", sd(data$performance_score, na.rm = TRUE)))
  cat(sprintf("  Range: %.2f - %.2f\n",
              min(data$performance_score, na.rm = TRUE),
              max(data$performance_score, na.rm = TRUE)))

  # Generate all visualizations
  cat("\nGenerating visualizations...\n")
  plot_performance_distribution(data)
  plot_training_effectiveness(data)
  plot_correlation_heatmap(data)

  # Statistical tests
  results <- analyze_training_programs(data)

  cat("\n", rep("=", 60), "\n", sep = "")
  cat("Report generation complete!\n")
  cat("Visualizations saved to: visualizations/\n")
  cat(rep("=", 60), "\n\n", sep = "")

  return(results)
}

# Example usage (when running script directly)
if (!interactive()) {
  # Generate sample data for demonstration
  set.seed(42)
  n <- 500

  sample_data <- data.frame(
    id = 1:n,
    training_program = sample(c("Advanced Tactical", "Leadership", "Technical Skills", "Basic Training"),
                              n, replace = TRUE),
    performance_score = rnorm(n, mean = 75, sd = 15),
    training_hours = rnorm(n, mean = 120, sd = 30),
    experience_years = rpois(n, lambda = 3),
    practical_hours = rnorm(n, mean = 60, sd = 20)
  )

  # Add program-specific effects
  sample_data <- sample_data %>%
    mutate(
      performance_score = case_when(
        training_program == "Advanced Tactical" ~ performance_score + 10,
        training_program == "Leadership" ~ performance_score + 8,
        training_program == "Technical Skills" ~ performance_score + 5,
        TRUE ~ performance_score
      )
    )

  write.csv(sample_data, "data/processed/performance_data.csv", row.names = FALSE)
  cat("Sample data generated and saved.\n")

  # Run analysis
  generate_analysis_report(sample_data)
}
