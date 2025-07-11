---
layout: default
math: mathjax
title: VSAT with SKAT
nav_order: 5
---

Last update: 20230425

# Variant Set Association Testing (VSAT) with burden testing, SKAT, and SKAT-O

## Introduction

Variant Set Association Testing (VSAT) involves statistical methods like burden testing, SKAT (Sequence Kernel Association Test), and SKAT-O (Optimal Unified SKAT), which help identify associations between groups of genetic variants and phenotypic traits. These methods are crucial for understanding the genetic basis of diseases, particularly when analyzing rare variants.

Methods for variant collapse
[^povysil2019rare],
<https://www.nature.com/articles/s41576-019-0177-4/>.
One of the most important starting positions in our analysis is determined on variant collapse.
Each project and biological system has unique features that determine how variants should be grouped for joint analysis.
Some more context is available in this blogpost
<https://lawlessgenomics.com/2021/05/28/pathway_analysis.html>.

## Historical context and evolution

VSAT has evolved from simpler burden tests to more sophisticated models that can handle complex variant interactions and incorporate various data types. Key publications have shaped the field:

### Main papers in order

* Methods for detecting associations with rare variants for common diseases: application to analysis of sequence data[^li2008methods].
* A groupwise association test for rare mutations using a weighted sum statistic[^madsen2009groupwise].
  - Introduced a weighted sum statistic to improve the power of groupwise association tests for rare mutations.
* An evaluation of statistical approaches to rare variant analysis in genetic association studies[^morris2010evaluation].
* Pooled association tests for rare variants in exon-resequencing studies[^price2010pooled].
* Testing for an unusual distribution of rare variants[^neale2011testing].
* Rare-Variant Association Testing for Sequencing Data with the Sequence Kernel Association Test[^Wu2011Rare].
  - Proposed SKAT, which uses a kernel-based approach to account for both common and rare variants in association tests.
* Optimal tests for rare variant effects in sequencing association studies[^Lee2012Optimal].
  - Developed SKAT-O, an optimal approach that blends SKAT and burden testing methods to maximize statistical power across different genetic architectures.
* Optimal Unified Approach for Rare-Variant Association Testing with Application to Small-Sample Case-Control Whole-Exome Sequencing Studies[^Lee2012Optimalunified].
* Sequence Kernel Association Tests for the Combined Effect of Rare and Common Variants[^IonitaLaza2013Sequence].




### Major classes of tests

* Burden/Collapsing tests
* Supervised/Adaptive Burden/Collapsing tests
* Variance component (similarity) based tests
* Omnibus tests: hedge against difference scenarios

These methods address the challenge of detecting the collective effect of multiple genetic variants, acknowledging that these effects might vary in direction and magnitude.

## Burden testing

Burden tests aggregate the effects of multiple variants within a genomic region into a single score, which is then tested for association with the phenotype. These tests are powerful when most variants in the region contribute to the phenotype in a similar manner.

## SKAT and SKAT-O

Sequence Kernel Association Test (SKAT) and SKAT-Optimal (SKAT-O) are advanced statistical methods used for identifying associations between sets of genetic variants and a phenotype. They are particularly useful for complex genetic traits influenced by multiple rare variants.

### Data Notation and Setup

- **Subjects:** Let $$ n $$ be the number of subjects.
- **Variants:** Assume $$ p $$ variant sites are observed within a region.
- **Phenotype:** Denote $$ y_i $$ as the phenotype for subject $$ i $$.
- **Genotypes:** $$ G_i = (G_{i1}, G_{i2}, \ldots, G_{ip}) $$ represents the genotypes for the $$ p $$ variants, where $$ G_{ij} $$ can be 0, 1, or 2 (copies of the minor allele).
- **Covariates:** $$ X_i $$ includes covariates such as age, gender, and principal components to adjust for population stratification.

### SKAT Model

The SKAT model assesses the impact of multiple genetic variants simultaneously by considering the variants' collective effect on the phenotype. It is based on a regression model:

$$ y_i = \beta_0 + X_i'\beta_X + G_i'\beta_G + \epsilon_i, $$

where:
- $$ \beta_0 $$ is the intercept.
- $$ \beta_X $$ are the coefficients for the covariates.
- $$ \beta_G $$ are the effects of the genetic variants.
- $$ \epsilon_i $$ is the error term.

### Kernel function

SKAT uses a kernel function to measure the genetic similarity between subjects based on their genotypes. This function is crucial as it allows SKAT to model the correlation structure among genetic variants. The kernel $$ K $$ is defined as:

$$ K = G W G^T, $$

where $$ W $$ is a diagonal matrix of weights for the genetic variants. These weights can be based on variant properties such as minor allele frequency or predicted functional impact.

### Variance component test

SKAT performs a variance component test using the kernel matrix to test the null hypothesis $$ H_0: \beta_G = 0 $$ against the alternative $$ H_a: \beta_G \neq 0 $$. Under the null hypothesis, there is no effect of the genetic variants on the phenotype.

### Implementation steps

1. **Compute the Kernel Matrix:** Calculate $$ K $$ using the genotypes and variant weights.
2. **Fit the Null Model:** Estimate the coefficients for the covariates without including genetic effects.
3. **Compute the SKAT Statistic:** Use the kernel matrix to calculate the SKAT statistic, which follows a chi-squared distribution under the null hypothesis.

### SKAT-O

SKAT-Optimal (SKAT-O) combines the burden test and SKAT to maximize power. It computes a weighted sum of the burden test statistic and the SKAT statistic:

$$ Q_{SKAT-O} = \omega Q_{Burden} + (1 - \omega) Q_{SKAT}, $$

where $$ \omega $$ is a weight factor that is optimally chosen based on the data to maximize the test's power.

## Practical implementation

- **Data Preparation:** Requires a genotype matrix, phenotypic data, and potentially other covariates. Typical plink format is best.
- **Statistical Testing:** Uses regression-based methods to associate genetic variability with phenotypes while adjusting for covariates.
- **Result Interpretation:** Involves understanding p-values in the context of multiple testing, requiring adjustments such as Bonferroni (usually this) or false discovery rate (FDR) corrections.

## Challenges and considerations

- **Rare Variants:** Both SKAT and burden tests are particularly useful for analyzing rare variants, which may be overlooked by traditional GWAS.
- **Direction of Effects:** Unlike burden tests, SKAT and SKAT-O can handle variants that have both protective and deleterious effects.
- **Computational Complexity:** The choice of kernel functions in SKAT and the integration of multiple tests in SKAT-O can increase computational demands.

## Conclusion

The development of VSAT methods like SKAT and SKAT-O represents a significant advancement in the field of genetic epidemiology, offering tools that can detect subtle and complex genetic influences on phenotypes. These tools are crucial for uncovering the genetic architecture of complex traits, especially in the context of rare genetic variants.


## References

[^povysil2019rare]: Povysil, G. et al., 2019. Rare-variant collapsing analyses for complex traits: guidelines and applications. _Nature Reviews Genetics_, 20(12), pp.747-759. DOI: [10.1038/s41576-019-0177-4](https://doi.org/10.1038/s41576-019-0177-4).
[^li2008methods]: Li, B. and Leal, S.M., 2008. Methods for detecting associations with rare variants for common diseases: application to analysis of sequence data. _The American Journal of Human Genetics_, 83(3), pp.311-321.
[^madsen2009groupwise]: Madsen, B.E. and Browning, S.R., 2009. A groupwise association test for rare mutations using a weighted sum statistic. _PLoS Genet_, 5(2), e1000384.
[^morris2010evaluation]: Morris, A.P. and Zeggini, E., 2010. An evaluation of statistical approaches to rare variant analysis in genetic association studies. _Genetic epidemiology_, 34(2), pp.188-193.
[^price2010pooled]: Price, A.L. et al., 2010. Pooled association tests for rare variants in exon-resequencing studies. _The American Journal of Human Genetics_, 86(6), pp.832-838.
[^neale2011testing]: Neale, B.M. et al., 2011. Testing for an unusual distribution of rare variants. _PLoS genetics_, 7(3), e1001322.
[^Wu2011Rare]: Wu, M.C. et al., 2011. Rare-Variant Association Testing for Sequencing Data with the Sequence Kernel Association Test. _The American Journal of Human Genetics_, 89(1), pp.82-93.
[^Lee2012Optimal]: Lee, S., Wu, M.C., and Lin, X., 2012. Optimal tests for rare variant effects in sequencing association studies. _Biostatistics_, 13(4), pp.762-775.
[^Lee2012Optimalunified]: Lee, S. et al., 2012. Optimal Unified Approach for Rare-Variant Association Testing with Application to Small-Sample Case-Control Whole-Exome Sequencing Studies. _The American Journal of Human Genetics_, 91(2), pp.224-237.
[^IonitaLaza2013Sequence]: Ionita-Laza, I. et al., 2013. Sequence Kernel Association Tests for the Combined Effect of Rare and Common Variants. _The American Journal of Human Genetics_, 92(6), pp.841-853.
