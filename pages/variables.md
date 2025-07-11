---
layout: default
title: Variables
nav_order: 5
---

# Centralised environment variables

Last update: 20240820

<!-- {: .no_toc } -->
<!-- <details open markdown="block"> -->
<!--   <summary> -->
<!--     Table of contents -->
<!--   </summary> -->
<!--   {: .text-delta } -->
<!-- - TOC -->
<!-- {:toc} -->
<!-- </details> -->



## Overview

To facilitate consistent paths and settings across multiple scripts, we use a single source file, `variables.sh`, which contains all the necessary environment variables. This method ensures that changes to paths or settings need to be updated in only one place, reducing errors and simplifying script maintenance.

* For each script, shared variables will be sourced from the variables file.
* Each pipeline can have its own custom variables file which will be sourced in its entirety or selectively from the master.
* The variables file contains entries such as:

```
DATABASE="./sph/database/"
REF_GRCh38="${DATABASE}/ref/grch38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz"
```

* For all new permanent datasets, tools, etc. we add it to the index table.
* We will assign the locations for all shared datasets, tools, etc.
* See [annotation table](annotation_table) for the list of datasets. (This will be updated to include variables.)

{: .note }
We will automatically generate the master variables file from the index table which contains meta data about dates, versions, application, etc. for each of the tools, databases, etc. Therefore, the only manual curation required is for the index table, rather than individual variables file/files. To be integrated on [annotation table](annotation_table).

```
+-- ..
|-- (sph)
|
|-- database
|   |-- ref
|   |   |-- grch37
|   |   |-- grch38
|   |   +-- ..
|   |
|   |-- vep
|   |   |-- ..
|   |   |-- ..
|   |   +-- ..
|   |
|   |-- gnomad
|   |   |-- ..
|   |   |-- ..
|   |   +-- ..
|   |
|   |-- (other files, pages with no children)
|   +-- ..
|
|-- tools
|   |-- gatk
|   |
|   |-- vep
|   |   |-- ..
|   |   +-- ..
|   |
|   |-- vt
|   |
|   +-- ..
|
|-- (sph)
+-- ..
```

## Usage

This script is intended to be sourced, not executed directly. To use the variables defined in this script, you should source it at the beginning of your scripts:

```bash
source /path/to/variables.sh
```

## Variables defined

### Raw data

Variables related to the location and structure of raw data:

- **`PROD`**: Root directory for production-level data.
- **`TRANSFER`**: Subdirectory for transferred data.
- **`BATCH`**: Specific batch identifier for datasets.
- **`RAWDATA`**: Full path to the raw data.
- **`CHECKSUM`**: Path to the checksum file for verifying data integrity.

```bash
PROD="/project/data/prod"
TRANSFER="h2030gc04072023/downloads"
BATCH="WGS_NDS_SwissPedHealth_Oct22"
RAWDATA="${PROD}/${TRANSFER}/${BATCH}"
CHECKSUM="${RAWDATA}/..._deliverables_final.md5"
```

### Processed data

Variables associated with directories for processed data:

- **`HOME`**: Home directory for project-specific data.
- **`DATA`**: Root directory for all genomic data.
- **`FASTP_DIR`**: Directory for FASTP outputs.
- **`FASTP_METRICS_DIR`**: Directory for FASTP metrics.
- **`BAM_DIR`**: Directory for BAM files.
- **`SAMSORT_DIR`**: Directory for sorted SAM files.
- **`RMDUP_DIR`**: Directory for duplicate-removed data.
- **`RMDUP_MERGE_DIR`**: Directory for merged BAM files post-duplication removal.
- **`BQSR_DIR`**: Directory for Base Quality Score Recalibration (BQSR) outputs.
- **`BQSR_DIR_HOLD`**: Temporary holding directory for BQSR data.

```bash
HOME="/project/home/lawless"
DATA="${HOME}/data/wgs"
FASTP_DIR="${DATA}/fastp"
FASTP_METRICS_DIR="${DATA}/fastp_reports"
BAM_DIR="${DATA}/bam"
SAMSORT_DIR="${DATA}/samsort"
RMDUP_DIR="${DATA}/rmdup"
RMDUP_MERGE_DIR="${DATA}/rmdup_merge"
BQSR_DIR="${DATA}/bqsr"
BQSR_DIR_HOLD="${DATA}/bqsr_hold"
```

## Best practices

- **Source Reliability**: Always ensure the `variables.sh` script is sourced at the start of each script to maintain consistency across the workflow.
- **Path Validation**: After sourcing, it is good practice to check that critical paths exist or are accessible to prevent runtime errors:
  
  ```bash
  if [ ! -d "$BQSR_DIR" ]; then
    echo "Error: BQSR directory does not exist."
    exit 1
  fi
  ```

- **Security and Permissions**: Regularly check that permissions and ownerships are correctly set on directories to prevent unauthorized access or data loss.

## Conclusion

Using a centralized script for environment variables helps streamline configuration management in large projects, especially those involving multiple stages of data processing in genomic research.
