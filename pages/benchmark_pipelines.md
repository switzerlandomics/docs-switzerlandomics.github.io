---
layout: default
title: Benchmarking pipeline output
nav_order: 5
---

Last update: 20240819

# Benchmarking pipeline output

To compare the output of  `GATK` and `DeepVariant`, we process the data to first look at a subset of known variants for which we have "ground truth" Sanger sequencing confirmatation of which subjectsare carriers and genotype.

## Script: `17_get_momic_known_subset.sh`

This script is designed to process VCF files by reading a list of variants at specific to genomic positions, known to carry disease-causing variants, using various command-line tools to extract and index the data.

- **Environment Setup and Loading Modules:** The script starts by setting up the environment to stop on errors (`set -e`) and loading necessary modules such as `vcftools`, `bcftools`, and `vcflib` for handling VCF files.
  
- **Defining Known Variant List:** A list of known variant positions is sourced, which is used to filter down and focus the analysis on specific genomic locations that are of interest. Format: No header and two columns for chromosome and position: `chr1	11790681`.

- **Copying and Indexing VCF Files:** The script copies VCF files from a shared directory and indexes them using `bcftools index`, allowing efficient querying of the VCF data.

- **Extracting Chromosome Numbers and Looping:** It extracts unique chromosome identifiers from the position list and processes each chromosome separately. This ensures that the analysis is streamlined and efficiently uses resources.

- **Defining Input Paths for Each Source:** Multiple input sources for VCF files are defined, including unfiltered `GATK`, `VQSR` processed files, and files processed using `BCFTOOL_QC` and `DeepVariant`. These represent different stages or types of quality control and variant calling.

- **Filtering VCF for Known Positions:** For each chromosome and each data source, the script uses `bcftools view` to filter VCF files to only include variants from the known positions list. The results are outputted in both VCF and TSV formats.

- **Indexing and Converting VCF to TSV:** The filtered VCF files are re-indexed and converted to TSV format using `vcf2tsv`, facilitating easier data manipulation in subsequent analyses, typically done in environments like R.

- **Logging and Error Handling:** Throughout the script, there are numerous `echo` statements used to log the process, which is useful for debugging and tracking the progress of the script execution.

## Script: `18_momic_known_subset_interpret.R`

The R script uses libraries such as `dplyr`, `ggplot2`, and `patchwork` to analyze the filtered data. The main focus of this script is on counting overlaps between datasets and visualizing these overlaps to understand how different variant calling methods compare.

- **Data Loading and Preparation:** The script loads data from TSV files, ensuring correct data types and selecting relevant columns. This preparation is crucial for accurate downstream analysis.

- **Combining Data:** Data from different sources are combined into a single dataframe, which is then used to identify shared and unique variants.

- **Analyzing Overlaps:** The script identifies variants that are shared across different data sources and those that are unique to each source. It summarizes these findings both in text and visually using histograms and Venn diagrams.

- **Visualizing Data:** Using `ggplot2` and `patchwork`, the script creates visual summaries of the overlaps and differences between the data sources, providing insights into the consistency and discrepancies of variant calling methods.

## Summary

The Bash script efficiently prepares and filters genomic data for analysis, focusing specifically on a subset of known disease-related variants across different sources and chromosome segments. The R script then takes this prepared data to perform a comparative analysis, visualizing overlaps and unique findings in an interpretable manner. This two-step approach allows for rigorous analysis of genomic data while focusing on specific areas of interest, such as disease-related genetic variants.

<!-- We are using [https://github.com/Illumina/hap.py](https://github.com/Illumina/hap.py) haplotype VCF comparison tools. -->
<!-- The steps include setting up the environment on an HPC system, preparing the reference genome, and executing the comparison. -->

<!-- ## Notes about hap.py -->

<!-- 1. Is made for a single-sample VCF rather than multi-sample (although accepts multi-sample). Therefore, if we have a particular region of interest, the particular sample selected may only have REF but no ALT at this site. If you want this site included in a VCF you must output base-pair resolution (BP_RESOLUTION) rather than GVCF (which we produce as the otherwise more efficient output). With GVCF, you get individual variant records for variant sites, but the non-variant sites are grouped together into non-variant block records that represent intervals of sites for which the genotype quality (GQ) is within a certain range or band. [Read about this on GATK pages](https://gatk.broadinstitute.org/hc/en-us/articles/360035531812-GVCF-Genomic-Variant-Call-Format). -->
<!-- 2. While the example data using reference genome hg19 work fine - when we test this with GRCh38 we get --> 
<!-- [this Spurious warning: too many AD fields](https://github.com/Illumina/hap.py/issues/129) which is fine for the input VCF but ultimately results in a fatal error for the reference genome. I have tried the bioconda version in the hopes of a fix but I cannot resolve the conda version error "ImportError: /lib64/libm.so.6: version `GLIBC_2.29' not found`". -->
<!-- 3. One would still need to rerun GATK in BP_RESOLUTION mode because running on a single-sample VCF with 1 extracted variant can cause this: -->
<!-- * WARNING  Blocksplit returned no blocks. This can happen when an input contains no valid variants. -->
<!-- * WARNING  No calls for location chr21 in query! -->
<!-- * ERROR    Input files/regions do not contain variants (0 haplotype blocks were processed). -->

<!-- It works on GATK output for variants n=1, 50, 1000, then at 10'000 I hit an error: -->
<!-- ``` -->
<!-- Hap.py -->
<!-- [W] overlapping records at chr22:10682031 for sample 0 -->
<!-- [W] Variants that overlap on the reference allele: 1 -->
<!-- [I] Total VCF records:         10001 -->
<!-- [I] Non-reference VCF records: 3181 -->
<!-- [I] Total VCF records:         10001 -->
<!-- [I] Non-reference VCF records: 3014 -->
<!-- 2024-07-19 16:53:16,565 ERROR    [W] too many AD fields at chr22:10510355 max_ad = 2 retrieved: 3 -->
<!-- ``` -->

<!-- Try to fix with <https://github.com/Illumina/hap.py/issues/32#issuecomment-357769326> -->

<!-- Let's try by keeping only the GT field -->

<!-- https://github.com/Illumina/hap.py/issues/86#issuecomment-501043612 -->
<!-- ``` -->
<!-- GitHubGitHub -->
<!-- Warning in log file ("Too many AD fields") for gatk-vcf only · Issue #86 · Illumina/hap.py -->
<!-- Hi Peter, I am using hap.py to compare vcf files against the GIAB reference in two separate runs for freebayes (freebayes.vcf) and GATK4 HaplotypeCaller (gatk.vcf), respectively. Both vcf files wer... -->
<!-- I suspect that decomposition somehow doesn't get the AD values quite right. I think the easiest way to fix this would be to drop the AD fields in advance using bcftools. They are not used by hap.py. -->
<!-- ``` -->


<!-- ## Usage steps -->

<!-- ### 0. **Download hap.py Repository** -->
<!-- The hap.py tool was obtained from its [GitHub repository](https://github.com/Illumina/hap.py) and transferred to the HPC system for installation. -->

<!-- ### 1. **Install hap.py with Python 2** -->
<!-- Due to specific compatibility requirements, hap.py is installed using Python 2. This installation includes transferring the necessary files to the HPC via SFTP. -->

<!-- ### 2. **Prepare the Reference Genome** -->
<!-- The tool requires a reference genome unzipped and in a single file. -->
<!-- The example data uses hg19 and provides a script to download the hg19.fa. -->
<!-- We adjust our reference genome accordingly, ensuring it's compatible with hap.py's expectations. -->

<!-- ### 3. **Index the Reference Genome** -->
<!-- Indexing is required for the modified reference genome. --> 
<!-- This is accomplished by indexing with -->
<!-- * `samtools faidx hg19.fa` -->
<!-- * `samtools faidx GCA_000001405.15_GRCh38_no_alt_analysis_set.fa` -->

<!-- ### 4. **Execute hap.py** -->
<!-- With the reference genome ready, the hap.py tool is used to perform a comparative analysis between two VCF files. This process involves configuring the tool with the paths to the input files, output directory, and the reference genome. -->


