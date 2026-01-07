#!/usr/bin/env Rscript
# Render Performance Report to HTML
# Author: Kamil Nazaruk
#
# Usage: Rscript render_report.R

cat("\n")
cat("========================================================================\n")
cat("R PERFORMANCE ANALYSIS - RENDERING INTERACTIVE REPORT\n")
cat("========================================================================\n\n")

# Check if rmarkdown is installed
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  cat("[!] rmarkdown package not installed. Installing now...\n")
  install.packages("rmarkdown", repos = "https://cloud.r-project.org/")
}

# Check for required packages
required_packages <- c("ggplot2", "dplyr", "plotly", "DT", "knitr", "scales")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat(paste0("[!] Missing packages: ", paste(missing_packages, collapse = ", "), "\n"))
  cat("[*] Installing missing packages...\n")
  install.packages(missing_packages, repos = "https://cloud.r-project.org/")
}

cat("[*] Rendering performance_report.Rmd to HTML...\n\n")

# Render the report
rmarkdown::render(
  input = "performance_report.Rmd",
  output_file = "index.html",
  output_dir = "docs",
  envir = new.env()
)

cat("\n========================================================================\n")
cat("REPORT RENDERING COMPLETE!\n")
cat("========================================================================\n\n")
cat("Output: docs/index.html\n")
cat("To view locally: open docs/index.html in your web browser\n")
cat("For GitHub Pages: Enable Pages in repo settings, source = /docs\n\n")
