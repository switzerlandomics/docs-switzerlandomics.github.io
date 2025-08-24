---
layout: default
title: WGS metadata users
nav_order: 5
---

Last update: 2025-08-24

# What is your genome metadata?

Genome metadata is the information stored alongside your genome files.  
It includes file names, sizes, checksums, sample identifiers, and quality metrics.  

Not every record will have the same fields. Raw data may contain only FASTQ files, while processed genomes often include VCF files, sample information, and quality control summaries. As your genome moves through analysis, more metadata may be added.

---

## Overview

- **Genome ID:** `GV-TEST1234`  
- **Status:** stored  
- **Created:** 03.08.2025, 22:07  

---

## Files

Your genome may be stored in different file formats, depending on the analysis stage. Each file has a size and a checksum (MD5) that helps verify integrity.

- **FASTQ:** `vault/genomes/gv-test1234.fastq.gz` (10.2 GB)  
  - MD5: `abc123def456...`  
- **VCF:** `vault/genomes/gv-test1234.vcf.gz` (160.5 MB)  
  - MD5: `789ghi012jkl...`  

Other formats such as BAM or CRAM may also be available for efficient storage and access.

---

## Shares

When you request that your genome (or part of it) be shared, each event is recorded. This log shows what was shared, when, and with whom.

- **2025-08-07** — Type: `QV_ACMG` — Recipient: Dr. Jones `<dr.jones@hospital.ch>`  
- **2025-08-07** — Type: `FULL_GENOME` — Recipient: Dr. request `<dr.request@hospital.ch>`  
  - FTP: `ftp://example/path`  

---

## Sample details

After sequencing, technical metrics are available. These values help confirm the quality of the data. For example, **mean coverage** and **Q30** indicate how complete and reliable your genome is. A requested coverage of 30x or higher is considered excellent in most analyses.

- Sample ID: `ABC001`  
- Library ID: `NGS000012135`  
- Barcode: `A0123456`  
- Primary sample type: Fibroblasts  
- Requested coverage: 30x  
- Mean coverage: 30.5x  
- Q30: 91.41%  
- PF clusters: 390,500,001  
- PF duplicates: 10.01%  
- PF bases aligned: 96.01%  
- New variants: 0.66  

---

## Quality control summary

Quality control (QC) summaries may be added after expert review. These provide additional checks on completeness and accuracy.

- Timestamp: `2028-01-01T01:01:01Z`  
- Approved by: Dr. Smith  
- QC checksum: `76fds4fds56fds567567fds678fds`  
- Requested coverage: 30x  
- Mean coverage: 34.9x  
- Lowest coverage: 10.0x  

---

## Delivered file types

The types of files you may see include:

- **FASTQ** — raw sequencing reads  
- **VCF** — list of genetic variants  
- **BAM / CRAM** — processed formats for storage and quick access  

Different providers may deliver different formats, depending on the service requested.

---

## Notes

- Raw data may only include FASTQ files and checksums.  
- Processed genomes usually include VCFs, QC metrics, and sample details.  
- All fields are optional; availability depends on your analysis stage.  

