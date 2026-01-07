# R Performance Analysis

![R](https://img.shields.io/badge/R-4.0%2B-blue)
![tidyverse](https://img.shields.io/badge/tidyverse-ggplot2-orange)
![Analysis](https://img.shields.io/badge/Analysis-Statistical-green)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

Statistical performance analysis system using R with ggplot2, dplyr, and advanced data visualization techniques for operational metrics. This project demonstrates R programming, statistical analysis, and data visualization skills for performance monitoring and optimization.

## Challenge

Analyze large-scale operational performance data to identify patterns, anomalies, and optimization opportunities. Provide actionable insights through statistical analysis and compelling visualizations.

## Solution

Developed a comprehensive R-based analysis pipeline using:
- **ggplot2**: Advanced data visualization
- **dplyr & tidyr**: Data manipulation and transformation
- **Statistical Methods**: Correlation analysis, trend detection, anomaly identification
- **Automated Reporting**: Reproducible analysis pipeline

## Key Features

- ✅ **Exploratory Data Analysis**: Comprehensive statistical profiling
- ✅ **Advanced Visualizations**: Time series, distributions, correlations
- ✅ **Trend Analysis**: Hourly, daily, and weekly pattern detection
- ✅ **Anomaly Detection**: Statistical outlier identification
- ✅ **Sample Data Generator**: Built-in synthetic data for testing
- ✅ **Automated Reporting**: Reproducible analysis workflow

## Technologies Used

- R 4.0+
- ggplot2 (visualization)
- dplyr, tidyr (data manipulation)

## Project Structure

```
r-performance-analysis/
├── analysis/
│   └── 02_exploratory_analysis.R  # Main analysis script
├── data/                          # Created when running demo
│   ├── raw/                       # Sample data (gitignored)
│   └── processed/                 # Analysis results (gitignored)
├── output/                        # Visualization outputs (gitignored)
├── run_demo.R                     # Demo mode - START HERE!
└── README.md
```

## Installation

```bash
git clone https://github.com/KamilNaz/r-performance-analysis.git
cd r-performance-analysis
```

**Install R dependencies:**
```R
install.packages(c("ggplot2", "dplyr", "tidyr", "lubridate"))
```

**Supported R versions:** 4.0, 4.1, 4.2, 4.3, 4.4

## Quick Start

### Run Demo with Sample Data

```bash
Rscript run_demo.R
```

This will:
1. Generate 1,000 synthetic performance records
2. Calculate summary statistics
3. Perform correlation analysis
4. Identify high-latency operations
5. Analyze hourly performance trends
6. Save results to CSV

**Expected output:**
```
========================================================================
R PERFORMANCE ANALYSIS - DEMO MODE
========================================================================

[*] Generating sample performance data...
[+] Generated 1000 performance records
    Average response time: 142.3 ms
    Average throughput: 449 ops/sec
    Average error rate: 1.95%
[+] Data saved to: data/raw/sample_performance_data.csv

[*] Running exploratory data analysis...

=== PERFORMANCE SUMMARY STATISTICS ===

Response Time (ms):
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
  18.45   78.23  125.40  142.30  185.70 1243.50

Throughput (ops/sec):
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
    410     425     448     449     472     521

=== CORRELATION MATRIX ===

                   response_time_ms throughput_ops error_rate cpu_usage
response_time_ms              1.000         -0.145      0.234     0.087
throughput_ops               -0.145          1.000     -0.056    -0.023
error_rate                    0.234         -0.056      1.000     0.112
cpu_usage                     0.087         -0.023      0.112     1.000

=== HIGH LATENCY OPERATIONS (p95+) ===
Found 50 operations with response time > 285.7 ms

=== PERFORMANCE TRENDS ===

Hourly Performance Averages:
Best Hour (lowest response time): 14:00 (98.4 ms)
Worst Hour (highest response time): 03:00 (189.2 ms)

[+] Hourly summary saved to: data/processed/hourly_performance_summary.csv

========================================================================
DEMO COMPLETE!
========================================================================

Generated files:
  - data/raw/sample_performance_data.csv
  - data/processed/hourly_performance_summary.csv
```

### Analyze Your Own Data

1. Place your CSV file in `data/raw/`
2. Modify `analysis/02_exploratory_analysis.R` to load your data
3. Run: `Rscript analysis/02_exploratory_analysis.R`

**Required CSV columns:**
- `timestamp` - Date/time of measurement
- Numeric metrics: `response_time_ms`, `throughput_ops`, `error_rate`, etc.

**Example format:**
```csv
timestamp,response_time_ms,throughput_ops,error_rate,cpu_usage
2024-01-01 00:00:00,125.4,450,0.015,0.65
2024-01-01 01:00:00,98.3,475,0.008,0.52
```

### R Console Usage

```R
# Load the data
performance_data <- read.csv("data/raw/sample_performance_data.csv")

# Load required libraries
library(ggplot2)
library(dplyr)

# Quick summary
summary(performance_data)

# Visualize response time distribution
ggplot(performance_data, aes(x = response_time_ms)) +
  geom_histogram(bins = 50, fill = "steelblue") +
  labs(title = "Response Time Distribution",
       x = "Response Time (ms)",
       y = "Frequency")

# Time series plot
ggplot(performance_data, aes(x = as.POSIXct(timestamp), y = response_time_ms)) +
  geom_line(color = "darkblue") +
  labs(title = "Response Time Over Time",
       x = "Time",
       y = "Response Time (ms)")
```

## Analysis Features

The `analysis/02_exploratory_analysis.R` script includes:

- **Summary Statistics**: Mean, median, quartiles, min/max
- **Distribution Analysis**: Histograms, density plots, box plots
- **Time Series Analysis**: Trend lines, moving averages
- **Correlation Analysis**: Correlation matrices, scatter plots
- **Anomaly Detection**: Statistical outlier identification (p95, p99)
- **Comparative Analysis**: Performance across different dimensions

## Impact & Results

Performance on demo dataset (1,000 operations):

| Metric | Value |
|--------|-------|
| **Avg Response Time** | 142.3 ms |
| **Avg Throughput** | 449 ops/sec |
| **Avg Error Rate** | 1.95% |
| **High-Latency Ops (p95+)** | 50 (5.0%) |
| **Best Hour** | 14:00 (98.4 ms) |
| **Worst Hour** | 03:00 (189.2 ms) |

## Roadmap / Planned Features

- [ ] Interactive Shiny dashboards
- [ ] Automated anomaly alerts
- [ ] Predictive modeling (ARIMA, Prophet)
- [ ] Advanced clustering analysis
- [ ] Integration with monitoring systems
- [ ] RMarkdown automated reports

## Author

**Kamil Nazaruk**
Data Analyst & Statistical Analysis Specialist

- 🔗 LinkedIn: [kamil-nazaruk](https://www.linkedin.com/in/kamil-nazaruk-56531736a)
- 🌐 Portfolio: [kamilnaz.github.io](https://kamilnaz.github.io)

## License

MIT License - This project is open source and available for learning, portfolio, and commercial use.

---

**Note:** This is a demonstration project showcasing R programming and statistical analysis skills. For production performance monitoring, consider enterprise APM solutions with real-time dashboards and alerting.
