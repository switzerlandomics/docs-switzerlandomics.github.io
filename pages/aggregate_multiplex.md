---
layout: default
title: Aggregate multiplexed data
nav_order: 5
---

# Aggregate multiplexed data

Last update: 20240611

The following content is modified from:
> How should I pre-process data from multiplexed sequencing and multi-library designs?

<https://gatk.broadinstitute.org/hc/en-us/articles/360035889471-How-should-I-pre-process-data-from-multiplexed-sequencing-and-multi-library-designs>

We use `05_rmdup_merge.sh` to process bam files for data aggregation and deduplication.

**Script Summary: `05_rmdup_merge.sh`**

**Purpose**: This script is tailored for efficiently merging and deduplicating sequencing data from multiple libraries and lanes per individual subject. It addresses complex setups where subjects are represented across numerous sequencing files.

**Process Description**:
- **Data Preparation**: Each subject's sequencing data, potentially spanning multiple libraries and lanes, is initially processed separately to ensure accurate [read group](read_group.html) assignment and preliminary sorting.
- **Aggregation and Deduplication**:
  - **File Aggregation**: BAM files from the same subject, but different lanes or libraries, are combined into a single dataset. This step merges these various inputs into one unified file.
  - **Deduplication**: Implements GATK’s `MarkDuplicatesSpark` to simultaneously mark and remove both PCR and optical duplicates from the merged files, improving data accuracy and quality.
- **Output Generation**: Outputs a single, consolidated, and deduplicated BAM file for each subject, ready for further analysis like Base Recalibration.

**Example of File Processing**:

- **Input Files**:
  - For subject `sampleA`, files from two different lanes:
    - `sampleA_lane1_R1.fq`
    - `sampleA_lane1_R2.fq`
    - `sampleA_lane2_R1.fq`
    - `sampleA_lane2_R2.fq`
  - For subject `sampleB`, files from two different lanes:
    - `sampleB_lane1_R1.fq`
    - `sampleB_lane1_R2.fq`
    - `sampleB_lane2_R1.fq`
    - `sampleB_lane2_R2.fq`

- **Processing**:
  - These paired FASTQ files are first individually processed to assign [read group](read_group.html)s and generate initial BAM files:
    - From `sampleA_lane1_R1.fq` and `sampleA_lane1_R2.fq` → `sampleA_rgA1.bam`
    - From `sampleA_lane2_R1.fq` and `sampleA_lane2_R2.fq` → `sampleA_rgA2.bam`
    - From `sampleB_lane1_R1.fq` and `sampleB_lane1_R2.fq` → `sampleB_rgB1.bam`
    - From `sampleB_lane2_R1.fq` and `sampleB_lane2_R2.fq` → `sampleB_rgB2.bam`
  - **Aggregation and Deduplication**: The script then aggregates and deduplicates [read group](read_group.html) BAMs for each subject:
    - `sampleA` [read group](read_group.html)s (`sampleA_rgA1.bam` and `sampleA_rgA2.bam`) are merged and deduplicated to produce `sampleA.merged.dedup.bam`.
    - Similarly, `sampleB` [read group](read_group.html)s (`sampleB_rgB1.bam` and `sampleB_rgB2.bam`) are merged and deduplicated to produce `sampleB.merged.dedup.bam`.

- **Output**:
  - The final outputs are deduplicated BAM files for each subject, such as `sampleA.merged.dedup.bam` and `sampleB.merged.dedup.bam`. These files integrate all sequencing data from different lanes or libraries for each subject and are now ready for subsequent quality control steps like Base Recalibration.

