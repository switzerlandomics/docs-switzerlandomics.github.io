---
layout: default
title: Structural variation detection
nav_order: 5
---

# Structural variation detection
Last update: 20240820

## Understanding Structural Variation Detection with smoove, lumpy, and duphold

Structural variations (SVs) such as deletions, duplications, inversions, and translocations play a critical role in genomic diversity and disease. Detecting these variations accurately in whole-genome sequencing data requires sophisticated bioinformatics tools. Here, we discuss how Smoove, Lumpy, and Duphold work together to detect and interpret SVs, focusing on their methodologies rather than specific commands or installation procedures.

* smoove - <https://github.com/brentp/smoove>
* lumpy-sv - <https://github.com/arq5x/lumpy-sv>
* duphold - <https://github.com/brentp/duphold>

Example results quoted from "https://github.com/brentp/duphold":

> A clear deletion will have rapid drop in depth at the left and increase in depth at the right and a lower mean coverage. Duphold annotated this with: DHBFC: 0.6. These indicate that both break-points are consistent with a deletion and that the coverage is ~60% of expected. So this is a clear deletion.

<img src="{{ "https://user-images.githubusercontent.com/1739/45895721-2dbaf400-bd8f-11e8-88b3-9fd5a90ef39e.png" | relative_url }}" width="100%">

> BND - when lumpy decides that a cluster of evidence does not match a DUP or DEL or INV, it creates a BND with 2 lines in the VCF. Sometimes these are actual deletions. For example this shows where a deletion is bounded by 2 BND calls. duphold annotates this with: DHBFC: 0.01 indicating a homozygous deletion with clear break-points.

<img src="{{ "https://user-images.githubusercontent.com/1739/45906495-987d2700-bdb1-11e8-8ba5-eacdf8221f68.png" | relative_url }}" width="100%">

### Smoove: Streamlining Lumpy's Process
Smoove is a software that enhances Lumpy's SV calling capabilities. It wraps around Lumpy and other tools to simplify and speed up the process, especially for large-scale genomic studies. Here’s how Smoove enhances the detection of structural variations:

1. **Read Filtering:**
   - Smoove employs `lumpy_filter` to extract split reads and discordant reads, which are critical for identifying potential SVs.
   - It filters out low-quality signals such as reads with excessive soft-clipping or multiple mismatches, and those aligned to multiple locations.
   - Reads in specified exclude regions or those contributing to regions of abnormally high coverage (suggestive of repetitive sequences) are also discarded.

2. **Parallel Processing:**
   - Smoove streams Lumpy’s output directly into `svtyper`, facilitating simultaneous genotyping across different genomic regions. This significantly reduces the computational time and memory requirements.

3. **Population-Level Calling:**
   - For larger datasets, Smoove enables joint calling by first calling variants in smaller groups (e.g., by family) and then merging these calls. This is followed by re-genotyping at these combined sites, further refined by integrating all findings into a comprehensive VCF using tools like `svtools` and `bcftools`.

### Lumpy: A Probabilistic Framework for SV Discovery
Lumpy serves as the foundational tool for SV detection used by Smoove. It offers a flexible and highly sensitive approach to detect SVs across different types and sizes by analyzing the signatures of split reads and discordant read pairs:

- **Probabilistic Modeling:**
  - Lumpy uses a probabilistic model to integrate evidence from various read types, including paired-end and split reads, to predict SVs.
  - This method allows for the detection of complex SVs that might not be identified through traditional read-mapping approaches.

### Duphold: Enhancing SV Calls with Depth Information
Duphold complements Smoove and Lumpy by adding depth-based annotations to SV calls, which helps in assessing the confidence of these variants:

- **Depth Annotations:**
  - **DHFC:** Compares the depth of coverage within the SV to the chromosome average.
  - **DHBFC:** Compares the depth within the SV to genomic regions with similar GC content, which helps control for sequencing biases.
  - **DHFFC:** Compares the depth within the SV to its immediate flanking regions, providing a localized assessment of depth changes.

- **Annotation Against SNP/Indel VCFs:**
  - Duphold can use existing SNP/Indel data to annotate SVs, helping to identify unlikely deletions that contain multiple heterozygous SNP calls, for example.

### Practical Application in Cohort Studies
In practice, these tools enable researchers to effectively identify and validate structural variations across large cohorts. By integrating read-based and depth-based evidence, researchers can filter out spurious calls and focus on variants that are most likely to be true positives. Visualisations such as histograms of depth changes and variant allele frequencies, along with comparative plots across samples or groups, provide intuitive insights into the data, aiding further in the interpretation of results.

### Conclusion
The combination of Smoove, Lumpy, and Duphold offers a robust framework for the detection and interpretation of structural variations in genomic datasets. By leveraging their individual strengths in read processing, probabilistic modeling, and depth annotation, researchers can achieve a high level of accuracy and efficiency in SV detection, essential for advancing our understanding of genomic structure and its impact on health and disease.


## Running Smoove using Singularity

Singularity provides an effective way to utilize Docker containers in environments where Docker itself may not be suitable, such as shared HPC systems. Here's a generalized example of how you can deploy and run `smoove` using a Singularity container, which is useful for calling and genotyping structural variants in genomic data.

### Step-by-Step Guide:

1. **Obtaining the Smoove Singularity Image:**
   - First, pull the `smoove` Docker image from Docker Hub and convert it into a Singularity image file (.sif). This step typically requires admin privileges or may be handled by your system administrator:
     ```bash
     singularity pull docker://brentp/smoove
     ```
   - This command creates a `.sif` file that can be used directly on any system where Singularity is installed.

2. **Preparing the Environment:**
   - Load necessary modules, if applicable, such as `samtools`. Ensure all dependencies like reference genome files and exclude region BED files are accessible.

3. **Running Smoove:**
   - Use the Singularity `exec` command to run `smoove` within the Singularity container. It's analogous to using `docker run` but tailored for Singularity environments. Here’s an example command structure based on a SLURM script for batch processing:
     ```bash
     singularity exec smoove_latest.sif smoove call --outdir results-smoove/ \
       --exclude exclude_regions.bed \
       --name sample_name \
       --fasta reference.fasta \
       -p 1 \
       --genotype sample.bam
     ```
   - This command runs `smoove` to call structural variants for a single sample. It specifies an output directory, an exclusion BED file for problematic regions, the sample name, the reference genome, and the input BAM file.

4. **Handling Multiple Samples:**
   - If processing multiple samples, consider using SLURM's array job feature to parallelize the process. Each job can process a different sample, effectively distributing the workload across multiple compute nodes or cores.

5. **Post-Processing:**
   - After generating VCF files for individual samples, you may need to merge these using `smoove merge` to create a combined VCF file that includes variants from all samples:
     ```bash
     singularity exec smoove_latest.sif smoove merge --name merged -f reference.fasta --outdir ./ results-smoove/*.genotyped.vcf.gz
     ```
   - Subsequently, genotype each sample at the merged sites and optionally run `duphold` to add depth annotations, enhancing the interpretability of the SV calls.

6. **Output and Validation:**
   - The final output will typically be a set of VCF files containing the called and genotyped structural variants for your cohort. These can be further analyzed or visualized using additional tools to assess the quality and implications of the detected variants.
