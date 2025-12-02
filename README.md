# Code Portfolio for Job Applications

This repository contains code samples from research projects I contributed to as a Research Assistant at Academia Sinica's Institute of Economics in Taiwan. These samples demonstrate my experience with large-scale data analysis, econometric methods, and computational workflows.

**Note on Data Confidentiality**: All projects use confidential datasets. The code samples provided here contain no data—only the analytical scripts. The actual data remain in secure research data centers and are not included in this repository.

---

## Projects Overview

### 1. GWAS Pipeline - Python Implementation
**File**: `plink_tidy_python.py`

**Project**: Instrumenting Education Using Genetic Data

**Description**: This Python script implements a complete genome-wide association study (GWAS) pipeline using Taiwan Biobank data (confidential genetic data covering thousands of individuals). The research examines genetic variants associated with educational attainment to create instrumental variables for studying the causal effect of education on wealth.

**What the code does**:
- Quality control (QC) procedures for genetic data:
  - Filters variants by minor allele frequency (MAF > 0.01)
  - Removes SNPs and individuals with high missingness rates
  - Filters for biallelic SNPs only
  - Checks sex concordance between reported and genetic data
  - Removes non-autosomal chromosomes
  - Filters variants deviating from Hardy-Weinberg equilibrium
  - Identifies and removes outliers based on heterozygosity rates
- Performs kinship-based pruning to remove related individuals
- Calculates principal components for population stratification control
- Executes GWAS with linear regression controlling for birth year, sex, and principal components
- Calculates polygenic risk scores (PRS)
- Recodes genotype data for downstream analysis

**Skills demonstrated**: Python (pandas, numpy), PLINK integration, GWAS methodology, data pipeline automation, handling confidential genetic data

**Tools**: Python, PLINK

---

### 2. GWAS Pipeline - Stata Implementation
**File**: `plink_tidy_stata.py`

**Project**: Instrumenting Education Using Genetic Data (same project as #1)

**Description**: This Stata script performs the identical GWAS workflow as the Python version, demonstrating multi-language implementation of the same analytical pipeline. It integrates PLINK commands within Stata to manage genetic data preprocessing and analysis.

**What the code does**:
- Identical QC steps as Python version
- Principal component calculation for ancestry adjustment
- Survey data integration with genetic data
- GWAS execution with covariate adjustment
- Clumping and PRS calculation
- Comprehensive logging and error handling throughout the pipeline

**Skills demonstrated**: Stata programming, PLINK integration, reproducible research workflows, multi-tool coordination

**Tools**: Stata, PLINK

---

### 3. Incinerator Health Effects Analysis
**File**: `incinerator_regressions.do`

**Project**: Health Effects of Proximity to Waste Incinerators

**Description**: This Stata script analyzes the health impacts of living near waste incinerators using Taiwan's National Health Insurance (NHI) database, which covers over 99% of Taiwan's 23 million residents. The study employs a difference-in-differences design, comparing health outcomes before and after incinerator operations began.

**What the code does**:
- Defines treatment and control groups based on proximity to 18-19 incinerators (10km and 15km radius definitions)
- Constructs individual-level panel data with health outcomes from administrative records:
  - Respiratory diseases (asthma, COPD, pneumonia)
  - Cardiovascular diseases (hypertension, heart disease, stroke)
  - Mental health conditions (depression, anxiety)
  - Cancer diagnoses
  - Eye diseases and other health indicators
- Implements fixed effects regression models comparing health outcomes before/after incinerator startup dates
- Stratifies analysis by age groups (0-2, 3-5, 60-64, 65-69, 70+) and sex
- Generates summary statistics including disease frequency and means by treatment status
- Exports results to Excel for multiple outcome variables and demographic subgroups
- Handles multiple comparison townships as controls

**Skills demonstrated**: Stata programming, panel data econometrics, difference-in-differences methodology, fixed effects models, large-scale administrative health data, multiple outcome analysis, results automation

**Tools**: Stata, Excel integration (putexcel)

---

### 4. Automated Geocoding with Web Scraping
**File**: `geocoding_automation.py`

**Project**: Geographic Data Collection for Spatial Analysis

**Description**: This Python script automates the geocoding of Taiwanese addresses using the TGOS (Taiwan Geospatial One Stop) platform. It demonstrates web automation, API interaction, and robust error handling for large-scale data collection.

**What the code does**:
- Automates browser interaction using Selenium WebDriver
- Manages multiple user accounts to parallelize geocoding requests and avoid rate limits
- Implements batch upload of address lists (handling 30,000+ addresses)
- Downloads and processes geocoding results (latitude, longitude, address standardization)
- Includes comprehensive error handling:
  - Retry logic for failed requests
  - Logging system to track progress and errors
  - Checkpoint/resume functionality to handle interruptions
  - File management (moving processed files, detecting duplicates)
- Rotates through multiple accounts to maximize throughput
- Uses timed execution with automatic shutdown

**Skills demonstrated**: Python automation, web scraping (Selenium), API interaction, error handling, logging, process scheduling, workflow optimization

**Tools**: Python, Selenium

---

### 5. Air Pollution and Health - Toll Booth Removal Analysis
**File**: `pollution_visualization.do`

**Project**: Health Effects of Air Pollution Reduction from Toll Booth Removal

**Description**: This Stata script analyzes the health effects of air pollution reduction following the removal of highway toll booths in Taiwan (which occurred around date 17439, approximately October 2017). The removal reduced traffic congestion and local air pollution, creating a natural experiment.

**What the code does**:
- Processes daily pollution data (2003-2016) for 8 pollutants: SO₂, PM2.5, PM10, CO, O₃, NO, NO₂, NOₓ
- Analyzes data at multiple aggregation levels (log average, log maximum, average, maximum)
- Merges 1km grid-level pollution predictions with township administrative boundaries
- Defines treatment groups at different distance thresholds (60km, 90km) and creates control groups
- Generates trend visualizations comparing treated vs control areas before/after toll booth removal:
  - Uses local polynomial smoothing (lpoly) to show pollution trends
  - Creates separate trend lines for pre/post treatment periods
  - Distinguishes treatment and control groups with different colors and line styles
- Produces 32 comparative graphics (8 pollutants × 4 aggregation levels) for each distance threshold
- Exports publication-quality PNG graphics for reporting

**Skills demonstrated**: Stata programming, data visualization, spatial data analysis, panel data handling, natural experiment research design, loop automation, graphics customization

**Tools**: Stata, spatial data processing, data visualization


## Data Sources (Confidential)

All analyses use restricted-access data:
- **Taiwan Biobank**: Genetic data with health surveys
- **National Health Insurance Database**: Complete medical records for 23M individuals
- **National tax and wealth records**: Accessed only in secure data center

---

## Contact

For questions about these code samples or the underlying research, please contact me through my application materials.
