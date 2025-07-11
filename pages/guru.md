---
layout: default
title: Guru variant interpretation
nav_order: 5
---

Last update: 20240827

{: .no_toc }
<details open markdown="block">
<summary>Table of contents</summary>
{: .text-delta }
- TOC
{:toc}
</details>

---

# Guru variant interpretation

Guru is an R package designed to facilitate the interpretation of genetic determinants of disease in genomic data. It employs extensive annotation and filtering based on the ACMG (American College of Medical Genetics and Genomics) and AMP (Association for Molecular Pathology) guideline standards.

![guru logo image](https://raw.githubusercontent.com/DylanLawless/ACMGuru/main/images/DALLE_guru.jpg)

## Features

- **Automatic Annotation and Filtering**: Applies extensive annotation and filtering based on ACMG/AMP guideline standards.
- **Customisation Options**: Provides various settings for filtering and annotation criteria to suit different study requirements.
- **Comprehensive Visualization Tools**: Generates a range of plots and visual aids to help interpret the filtering and annotation results effectively.

## Installation

```bash
# To install the latest development version from GitHub:
devtools::install_github("DylanLawless/Guru")
```

## Usage

Here is a basic guide on how to use Guru to process genomic data:

```R
library(Guru)

# Load your genomic data
genomic_data <- guru_read("path_to_data/cohort.vcf.gz")

# Apply Guru annotation and filtering
result <- Guru::acmg_filter(genomic_data)

# Visualize results
Guru::plot_result(result)
```

## Detailed Description

### Variant Interpretation

#### Guru Variant Classification

- **Gene Annotation**: Utilizes custom and default VEP plugins for comprehensive gene annotation.
- **Scoring and Interpretation**: Implements scoring based on ACMG/AMP guidelines to evaluate annotation evidence.
- **Visualization**: Includes plots showing the distribution of variants within genes and pathways, and other metrics.

#### Guru Gene-Illustrate

- **Data Integration**: Leverages UniProt data to provide detailed insights into gene and protein structures.
- **Visual Representation**: Generates vertical bars at amino acid positions to illustrate significant variant impacts visually.

#### Guru uniprotR

- **Seamless Data Retrieval**: Automatically fetches data from UniProt using the UniprotR package to enrich the annotation process.

#### Guru Get-Discussion

- **Reporting**: Produces a CSV or TSV format table summarizing the genetic analysis, providing context around technical descriptions.

#### AutoDestructR

- **Structure Visualisation**: Deconstructs sets of PDB structures for detailed structural analysis and visualisation.

## Documentation

For more detailed information on using Guru, please refer to [https://github.com/DylanLawless/ACMGuru](https://github.com/DylanLawless/ACMGuru) or the [reference manual](https://github.com/DylanLawless/ACMGuru/blob/main/inst/doc/ACMGuru_0.0.0.9000.pdf).

## Contributing

Contributions are welcome! Please see the [Contributing Guide](link_to_contributing_guide) for more details.

