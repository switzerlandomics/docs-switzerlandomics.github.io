---
layout: default
title: Filter VCF with bcftools
nav_order: 5
---

<!-- date: 2024-08-27 00:00:01 -->

# Filtering VCF files using bcftools for gnomAD_AF INFO column

Last update: 20240826

## Background

After annotating VCF files with variant effect prediction tools like VEP (Variant Effect Predictor) or SnpEff, and databases like dbnsfp, additional information such as global allele frequencies from databases like gnomAD becomes available.
One such key annotation is the "gnomAD_AF" field, representing the allele frequency across diverse populations.
Accurate filtering on this field is crucial for various genetic studies, especially when prioritising variants with low population frequency for rare disease investigations.

## Check your tool version

{: .warning }
The sciCORE HPC provides `bcftools v1.11` with `enable-modules`. This version (pre-v1.12) contains a bug which will cause an error and fail to run filtering.

- **Current module limitation**: Currently, the latest version of bcftools available with "enable-modules" on sciCORE is bcftools version 1.11, as of September 22, 2020. This version information is documented [here](https://github.com/samtools/bcftools/releases/tag/1.11).
- **Bug present before version 1.12**: There is a notable bug in bcftools pre-v1.12 that prevents import for filtering. This bug can cause format fields to drop unexpectedly, leading to broken VCF records where the number of columns does not match the number of samples, as described in this example error:
  ```
  [E::bcf_write] Broken VCF record, the number of columns at chr1:817186 does not match the number of samples (0 vs 1)
  ```
- **Bug Fix in Version 1.12**: This bug was addressed and corrected in the subsequent release, bcftools v1.12, on November 20, 2020. For detailed information on the bug and its resolution, refer to the issue tracker on GitHub [here](https://github.com/samtools/bcftools/issues/1349).

## Recommended action: updating bcftools

To address the limitations of the outdated bcftools version in some environments and ensure that you have the correct version for accurate VCF file manipulation, follow these steps to set up a Conda environment specifically for bcftools with a version that includes the necessary bug fixes.

#### Create and configure a new conda environment

Here's a script that sets up a new Conda environment, installs bcftools, and verifies the installation. Save the script as `bcftools_conda.sh` and execute it in your terminal:

```bash
#!/bin/bash
# Create a new Conda environment named bcftools
mamba create -n bcftools -y
conda init
mamba activate bcftools
mamba install -c bioconda bcftools -y
conda install -c conda-forge gsl -y
bcftools --version
# mamba deactivate
```

## Example of filtering

Filtering based on the "gnomAD_AF" involves extracting this subfield from the VEP-annotated VCF and applying a numeric threshold. For instance, to filter out all variants with a gnomAD allele frequency greater than 0.001 (to focus on rare variants), you can use the following command pattern with bcftools:

```bash
bcftools +split-vep -c gnomAD_AF:Float ${INPUT_DIR}/input_file.vcf.gz \
    -i "gnomAD_AF<0.001" \
    | bgzip -c > ${OUTPUT_DIR}/filtered_output.vcf.gz
```

## Conclusion

When performing genetic analyses where population frequency data impacts the study outcome, ensuring the accuracy of the tools and their versions is as crucial as the biological data. Users must ensure that their computational environment is properly configured to handle these nuances, especially with frequently updated tools like bcftools.

For more detailed instructions and updates on bcftools, refer to the [official GitHub repository of bcftools](https://github.com/samtools/bcftools).

## References

- [bcftools GitHub Releases](https://github.com/samtools/bcftools/releases)
- [bcftools Issue Tracker for Bug Reports](https://github.com/samtools/bcftools/issues)
- [dbnsfp Database](https://sites.google.com/site/jpopgen/dbNSFP)
- [VEP - Variant Effect Predictor](https://www.ensembl.org/info/docs/tools/vep/index.html)
- [SnpEff](http://pcingola.github.io/SnpEff/)
