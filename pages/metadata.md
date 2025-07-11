---
layout: default
title: WGS metadata
nav_order: 5
---

Last update: 20240406

# WGS metadata

Meta data from sequencing assays are produced in the following format for WGS.

## Project summary

| Field                        | Details                                                                                |
|------------------------------|----------------------------------------------------------------------------------------|
| Project name                 | WGS_NDS_Project_date                                                                   |
| Customer name and contact details | Email: n.a.                                                                           |
| First sample reception       | Jan 01 2028                                                                            |
| Last sample reception        | Jan 01 2028                                                                            |
| Analysis ID                  | hg38                                                                                   |
| Sample type                  | DNA                                                                                    |
| Library protocol             | WGS_TruSeq DNA PCR-free (Whole genome sequencing library preparation using the Illumina TruSeq DNA PCR-free reagents) |
| Analysis type                | WGS                                                                                    |
| Reads                        | Read1: Read / 150; Read2: Index / 8; Read3: Index / 8; Read4: Read / 150               |
| Mapping reference            | GCA_000001405.15_GRCh38_no_alt_analysis_set.fna                                        |
| Sequencer model              | NovaSeq6000                                                                            |
| Demultiplexing pipeline version | 01.01.13                                                                              |

## Deliverable summary

| Field                                      | Details                                                                                   |
|--------------------------------------------|-------------------------------------------------------------------------------------------|
| Customer order ID                          | WNGS00000001                                                                              |
| Number of samples submitted by customer    | 100                                                                                       |
| Number of samples requested by customer for processing | 99                                                                                      |
| Number of samples sequenced                | 99                                                                                        |
| Contact person(s)                          | Names and emails                                                                          |
| Files delivered to                         | Data manager name and email                                                               |
| Delivered file types                       | FastQ                                                                                     |
| Requested average MEAN_COVERAGE across samples | 30x                                                                                     |
| Average MEAN_COVERAGE across samples       | 34.9 (lowest coverage is 10.0x for sample ABC001)                                         |
| QC analysis checksum                       | 78fds6fds56fds567567fds678fds                                                             |
| Timestamp                                  | Jan 01 2028 01:01:01 GMT / v0.9.0                                                          |
| Report approved by                         | Provider manager name                                                                     |
| Comments for customer                      | None                                                                                      |
| Note                                       | Sample 'ABC002' was not listed on order request                                           |

## Samples

| SAMPLE | BARCODE  | LIBRARY ID   | PF CLUSTERS | %PF DUPLICATES | %PF BASES ALIGNED | Q30  | REQUESTED COVERAGE | MEAN COVERAGE | %NEW VARIANTS | PRIMARY SAMPLE TYPE |
|--------|----------|--------------|-------------|----------------|-------------------|------|--------------------|---------------|---------------|---------------------|
| ABC001 | A0123456 | NGS000011336 | 390,500,001 | 10.01          | 96.01             | 91.41| 30x                | 30.5x         | 0.66          | Fibroblasts         |
| ABC003 | A0123457 | NGS000011337 | 320,001,002 | 9.99           | 98.09             | 91.21| 30x                | 30.5x         | n.a.          | Fibroblasts         |

## Run ID

Sequencing assay may not always reach the intended sequencing depth (e.g. 30x) from the library for a sample. 
Therefore, the same library might be run again.
The run ID will then be new but the data from both runs will be later merged to meet the intended sequencing depth. 
Each of the FASTQ files will be output to unique directories. 
The directory name will contain the run ID (e.g. ABC8182DHCBS901).
