---
layout: default
math: mathjax
title: Exomiser
nav_order: 5
---

Last update: 20250809

# Exomiser Scoring and Ranking

* TOC
{:toc}

---

See [exomiser phenodigm](exomiser_phenodigm) for the phenotype similarity algorithm in context.

## 1. Overview

Exomiser assigns each **surviving variant** a **variant score**. 
Those that passes pre-scoring filters for genotype–mode of inheritance compatibility, quality, population frequency, and consequence. 
Each gene containing one or more surviving variants also receives a **phenotype score**. 
The highest variant score per gene and its phenotype score are then combined using a logistic regression model, pre-trained by the authors on 10 000 pathogenic and 10 000 benign variants with 10-fold cross-validation. 
The model coefficients are fixed in Exomiser and are applied directly to the user’s data to produce the final **Exomiser score** in the range $$[0,1]$$, which determines the ranking of candidate variants.

---

## 2. Algorithm

### 2.1 Notation

Let:

- $$f$$ = maximum MAF across selected frequency datasets (gnomAD, TOPMed, UK10K, 1000 Genomes, ExAC, ESP, plus any in-house set)  
- $$V$$ = variant-level score  
- $$P$$ = phenotype score for a gene  
- $$S$$ = final Exomiser score for a gene

All scores lie in $$[0,1]$$.

---

### 2.2 Filtering (no equations)

A variant is “surviving” if it passes:

- MOI compatibility for at least one selected inheritance mode (AD, AR, XD, XR, MT)  
- Quality thresholds  
- Population allele frequency limits  
- Allowed predicted consequence types

---

### 2.3 Variant score

**Frequency score** (**reported** in Cipriani et al.):

$$
\text{freqScore}(f) =
\begin{cases}
1, & f=0 \\[4pt]
1.13533 - 0.13533\, e^{100f}, & 0 < f \le 0.02 \\[4pt]
0, & f > 0.02
\end{cases}
$$

> The constants $$1.13533$$ and $$0.13533$$ in the frequency score equation are fixed values calibrated once by the Exomiser authors using their reference dataset. They define the shape of the exponential decay from rare to common variants and are not recalculated for user runs. The only run-specific input is $$f$$, the maximum MAF across the frequency datasets selected for that analysis, which is plugged into the fixed equation to yield the frequency score.

**Pathogenicity score** (**reported**):  
Let $$\text{normPred}_k \in [0,1]$$ be the normalised score from predictor $$k$$ (PolyPhen-2, SIFT, MutationTaster, CADD, REVEL, M-CAP, MPC, MVP, PrimateAI, etc.).  
High-impact consequences (frameshift, nonsense, canonical splice acceptor/donor, start-loss, stop-loss) are fixed at $$1.0$$, splice-region at $$0.8$$.  
If no predictor data exist, use a preset by consequence.

$$
\text{pathScore} = \max_k \,\text{normPred}_k
$$

**Variant score** (**reported**):

$$
V = \text{freqScore}(f) \cdot \text{pathScore}
$$

**Compound heterozygote averaging for AR** (**reported**):  
If $$V_1, V_2$$ are the two alleles:

$$
V_{\text{AR}} = \frac{V_1 + V_2}{2}
$$

> The frequency score equation is applied identically to homozygous and heterozygous variants. In autosomal recessive mode, Exomiser averages the two variant scores for a compound heterozygote. If trio data are available, it uses inheritance patterns to confirm the variants are in trans; otherwise, it assumes potential compound heterozygosity when a gene contains two or more rare, surviving variants, which can produce false positives in unphased singleton data.

---

### 2.4 Phenotype score

Computed per gene using [PhenoDigm](exomiser_phenodigm) semantic similarity (**reported**).  
The patient’s HPO terms are compared against annotations from:

- Human diseases (OMIM, Orphanet)  
- Mouse models (MGI, IMPC)  
- Zebrafish models (ZFIN)  
- Protein–protein interaction neighbours (STRING)

Because PhenoDigm uses ontology expansion, each HPO term is expanded to include all parent terms.

Let $$P \in [0,1]$$ be the best phenotype match for the gene from any source.

**MOI consistency penalty** (**reported**):

$$
P' =
\begin{cases}
\tfrac{1}{2}P, & \text{OMIM MOI conflict and omimPrioritiser enabled} \\
P, & \text{otherwise}
\end{cases}
$$

---

### 2.5 Gene-level aggregation

For gene $$g$$ with surviving variants $$\{v\}$$ and their scores $$V_v$$:

$$
V_g^\ast = \max_{v \in g} V_v
$$
(**reported**)

---

### 2.6 Final Exomiser score

**Logistic combination**: form **inferred**, training setup **reported**.
Model trained once on reference data; coefficients $$\beta_0,\beta_1,\beta_2$$ are fixed per Exomiser release.

$$
S_g = \sigma\!\big( \beta_0 + \beta_1 V_g^\ast + \beta_2 P'_g \big)
\qquad\text{with}\qquad
\sigma(x) = \frac{1}{1 + e^{-x}}
$$

This step combines the variant score $$V_g^\ast$$ and phenotype score $$P'_g$$ into a single probability-like value using a logistic regression model. 
The logistic function $$\sigma(x)$$ maps any real value to the range $$0 \le S_g \le 1$$.
The coefficients $$\beta_0, \beta_1, \beta_2$$ set the relative weight of the two scores.

$$\beta_0$$ is the intercept, $$\beta_1$$ is the weight for the variant score $$V_g^\ast$$, and $$\beta_2$$ is the weight for the phenotype score $$P'_g$$.

The logistic regression uses these three parameters together to balance baseline probability with the contributions of variant and phenotype evidence.

The model was trained once on 10 000 pathogenic and 10 000 benign variants with 10-fold cross-validation. 
The resulting coefficients are fixed in each release and applied directly to user data. 
Variants not in the training set are scored in the same way as those that were, so novel variants are fully supported.

---

### 2.7 Ranking

Genes are ranked in descending $$S_g$$ (**reported**).

---

## 3. Summary

Exomiser integrates variant rarity, predicted functional impact, ontology-aware phenotype–gene similarity across multiple species and sources, and MOI compatibility into a single ranking metric. Even minimal phenotype input (e.g. one HPO term) can influence ranking due to ontology expansion, though richer descriptions yield stronger matches.

---

## 4. References

> An Improved Phenotype-Driven Tool for Rare Mendelian Variant Prioritization: Benchmarking Exomiser on Real Patient Whole-Exome Data. Cipriani V, Pontikos N, Arno G, Sergouniotis PI, Lenassi E, Thawong P, Danis D, Michaelides M, Webster AR, Moore AT, Robinson PN, Jacobsen JOB, Smedley D. Genes (Basel). 2020 Apr 23;11(4):460  
PMID:32340307 DOI:<https://doi.org/10.3390/genes11040460>

> 100,000 Genomes Pilot on Rare-Disease Diagnosis in Health Care – Preliminary Report. 100,000 Genomes Project Pilot Investigators; Smedley D, … Caulfield M. N Engl J Med. 2021 Nov 11;385(20):1868-1880. PMID:34758253 DOI:<https://doi.org/10.1056/NEJMoa2035790>

See [exomiser phenodigm](exomiser_phenodigm) for the phenotype similarity algorithm in context.

> Damian Smedley, Anika Oellrich, Sebastian Köhler, Barbara Ruef, Sanger Mouse Genetics Project, Monte Westerfield, Peter Robinson, Suzanna Lewis, Christopher Mungall, PhenoDigm: analyzing curated annotations to associate animal models with human diseases, Database, Volume 2013, 2013, bat025, <https://doi.org/10.1093/database/bat025>


##  Appendix. YAML to equation mapping

Example config:

```yaml
inheritanceModes: [AUTOSOMAL_DOMINANT, AUTOSOMAL_RECESSIVE, X_LINKED_RECESSIVE, X_LINKED_DOMINANT, MITOCHONDRIAL]

frequencySources: [GNOMAD, TOPMED, UK10K, THOUSAND_GENOMES, EXAC, ESP, LOCAL]
frequencyFilter:
  maxFreq:
    AD: 0.001
    AR: 0.01
    XR: 0.01
    XD: 0.001
    MT: 0.01

pathogenicitySources: [CADD, REVEL, SIFT, POLYPHEN, MUTATION_TASTER, MVP, PRIMATE_AI, M_CAP, MPC]

hiPhivePrioritiser: {}
omimPrioritiser: true

qualityFilter: 20
variantEffectFilter:
  keep:
    - frameshift_variant
    - stop_gained
    - splice_acceptor_variant
    - splice_donor_variant
    - start_lost
    - stop_lost
    - missense_variant
    - splice_region_variant

whitelist: clinvar_path_lpath.tsv.gz
```

| YAML key                    | Symbol in text            | How it is used                                                                                                                                                                                                                   |
| --------------------------- | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `frequencySources`          | $$f$$                       | $$f = \max_{\text{sources}} \mathrm{MAF}$$ for the variant in the selected datasets. Feeds $$\text{freqScore}(f)$$.                                                                                                                  |
| `frequencyFilter.maxFreq.*` | survival gate on $$f$$      | Pre-filter by MOI. If variant fails, it is not scored. Also aligns with piecewise caps in $$\text{freqScore}(f)$$.                                                                                                                 |
| `pathogenicitySources`      | $$\text{normPred}_k$$       | Predictors whose normalised scores enter $$\text{pathScore} = \max_k \text{normPred}_k$$.                                                                                                                                          |
| `variantEffectFilter.keep`  | consequence policy        | Determines which consequences survive filtering. High-impact consequences map to fixed scores inside $$\text{pathScore}$$: frameshift, nonsense, canonical splice, start-loss, stop-loss set to $$1.0$$; splice-region set to $$0.8$$. |
| `qualityFilter`             | survival gate             | Variants must meet quality to be considered surviving before any scoring.                                                                                                                                                        |
| `inheritanceModes`          | MOI filter and AR combine | Controls survival and whether compound heterozygote averaging $$V_{\mathrm{AR}} = \frac{V_1 + V_2}{2}$$ applies.                                                                                                                   |
| `hiPhivePrioritiser`        | $$P$$                       | Enables PhenoDigm to compute the phenotype score $$P \in [0,1]$$ for each gene.                                                                                                                                                    |
| `omimPrioritiser`           | $$P'$$                      | When true and OMIM MOI conflicts, apply $$P' = \frac{1}{2} P$$, else $$P' = P$.                                                                                                                                                     |
| `whitelist`                 | survival bypass           | Listed variants bypass frequency and consequence filters and thus can contribute to $$V_g^\ast$.                                                                                                                                  |

Referenced equations:

$$
\text{freqScore}(f) =
\begin{cases}
1, & f=0\\
1.13533 - 0.13533\, e^{100f}, & 0 < f \le 0.02\\
0, & f>0.02
\end{cases}
$$

$$
\text{pathScore}=\max_k \text{normPred}_k
\qquad
V=\text{freqScore}(f)\cdot \text{pathScore}
$$

$$
V_{\text{AR}}=\frac{V_1+V_2}{2}
\qquad
V_g^\ast=\max_{v\in g} V_v
\qquad
P'=\begin{cases}
\tfrac{1}{2}P,& \text{OMIM MOI conflict}\\
P,& \text{otherwise}
\end{cases}
$$

$$
S_g=\sigma\!\big(\beta_0+\beta_1 V_g^\ast+\beta_2 P'_g\big)
\qquad
\sigma(x)=\frac{1}{1+e^{-x}}
$$

Provenance: frequency formula, high-impact fixed scores, AR averaging, MOI penalty, use of a fixed pre-trained logistic model are **reported**. The explicit logistic form with symbolic coefficients is **inferred**.

