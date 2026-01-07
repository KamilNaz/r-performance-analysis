#!/usr/bin/env Rscript
# R Performance Analysis - Demo Mode
# Author: Kamil Nazaruk
#
# Usage: Rscript run_demo.R

cat("\n")
cat("========================================================================\n")
cat("R PERFORMANCE ANALYSIS - DEMO MODE\n")
cat("========================================================================\n\n")

# Create directories if they don't exist
dir.create("data", showWarnings = FALSE)
dir.create("data/raw", showWarnings = FALSE, recursive = TRUE)
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
dir.create("output", showWarnings = FALSE)

# Generate sample performance data
cat("[*] Generating sample performance data...\n")

set.seed(42)
n_records <- 1000

# Generate operational performance metrics
performance_data <- data.frame(
  timestamp = seq(from = as.POSIXct("2024-01-01 00:00:00"),
                  by = "hour",
                  length.out = n_records),
  operation_id = paste0("OP", sprintf("%04d", 1:n_records)),
  response_time_ms = rlnorm(n_records, meanlog = 4.5, sdlog = 0.8),
  throughput_ops = rpois(n_records, lambda = 450),
  error_rate = rbeta(n_records, shape1 = 1, shape2 = 50),
  cpu_usage = rbeta(n_records, shape1 = 5, shape2 = 3),
  memory_usage_mb = rnorm(n_records, mean = 2048, sd = 512),
  success_rate = rbeta(n_records, shape1 = 95, shape2 = 5),
  latency_p95_ms = rlnorm(n_records, meanlog = 5.2, sdlog = 0.6),
  concurrent_users = rpois(n_records, lambda = 75)
)

# Add some anomalies (10% of data)
anomaly_indices <- sample(1:n_records, size = n_records * 0.10)
performance_data$response_time_ms[anomaly_indices] <-
  performance_data$response_time_ms[anomaly_indices] * runif(length(anomaly_indices), 3, 8)
performance_data$error_rate[anomaly_indices] <-
  performance_data$error_rate[anomaly_indices] + runif(length(anomaly_indices), 0.1, 0.3)

# Save generated data
write.csv(performance_data,
          "data/raw/sample_performance_data.csv",
          row.names = FALSE)

cat(sprintf("[+] Generated %d performance records\n", n_records))
cat(sprintf("    Average response time: %.1f ms\n", mean(performance_data$response_time_ms)))
cat(sprintf("    Average throughput: %.0f ops/sec\n", mean(performance_data$throughput_ops)))
cat(sprintf("    Average error rate: %.2f%%\n", mean(performance_data$error_rate) * 100))
cat("[+] Data saved to: data/raw/sample_performance_data.csv\n\n")

# Run exploratory analysis
cat("[*] Running exploratory data analysis...\n\n")

# Source the analysis script
if (file.exists("analysis/02_exploratory_analysis.R")) {
  source("analysis/02_exploratory_analysis.R")
  cat("\n[+] Exploratory analysis complete!\n")
} else {
  cat("[!] Warning: analysis/02_exploratory_analysis.R not found\n")
  cat("[*] Performing basic analysis instead...\n\n")

  # Basic summary statistics
  cat("=== PERFORMANCE SUMMARY STATISTICS ===\n\n")

  cat("Response Time (ms):\n")
  print(summary(performance_data$response_time_ms))
  cat("\n")

  cat("Throughput (ops/sec):\n")
  print(summary(performance_data$throughput_ops))
  cat("\n")

  cat("Error Rate (%):\n")
  print(summary(performance_data$error_rate * 100))
  cat("\n")

  cat("CPU Usage (%):\n")
  print(summary(performance_data$cpu_usage * 100))
  cat("\n")

  # Correlation analysis
  cat("=== CORRELATION MATRIX ===\n\n")
  numeric_cols <- c("response_time_ms", "throughput_ops", "error_rate",
                    "cpu_usage", "memory_usage_mb", "concurrent_users")
  cor_matrix <- cor(performance_data[, numeric_cols])
  print(round(cor_matrix, 3))
  cat("\n")

  # Identify high-latency operations
  high_latency <- performance_data[performance_data$response_time_ms >
                                    quantile(performance_data$response_time_ms, 0.95), ]
  cat(sprintf("=== HIGH LATENCY OPERATIONS (p95+) ===\n"))
  cat(sprintf("Found %d operations with response time > %.1f ms\n\n",
              nrow(high_latency),
              quantile(performance_data$response_time_ms, 0.95)))

  # Performance trends
  cat("=== PERFORMANCE TRENDS ===\n\n")

  # Calculate hourly averages
  performance_data$hour <- as.POSIXlt(performance_data$timestamp)$hour
  hourly_stats <- aggregate(cbind(response_time_ms, throughput_ops, error_rate) ~ hour,
                            data = performance_data,
                            FUN = mean)

  cat("Hourly Performance Averages:\n")
  cat(sprintf("Best Hour (lowest response time): %02d:00 (%.1f ms)\n",
              hourly_stats$hour[which.min(hourly_stats$response_time_ms)],
              min(hourly_stats$response_time_ms)))
  cat(sprintf("Worst Hour (highest response time): %02d:00 (%.1f ms)\n",
              hourly_stats$hour[which.max(hourly_stats$response_time_ms)],
              max(hourly_stats$response_time_ms)))
  cat("\n")

  # Save processed results
  write.csv(hourly_stats,
            "data/processed/hourly_performance_summary.csv",
            row.names = FALSE)

  cat("[+] Hourly summary saved to: data/processed/hourly_performance_summary.csv\n")
}

cat("\n========================================================================\n")
cat("DEMO COMPLETE!\n")
cat("========================================================================\n\n")

cat("Generated files:\n")
cat("  - data/raw/sample_performance_data.csv\n")
cat("  - data/processed/hourly_performance_summary.csv\n")
cat("\nYou can now explore the data with your own R analysis!\n\n")
