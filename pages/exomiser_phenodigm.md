---
layout: default
math: mathjax
title: Exomiser phenodigm
nav_order: 5
---

Last update: 20250809

# PhenoDigm algorithm

* TOC
{:toc}

---

See [exomiser](exomiser) for the use of this algorithm in context.

## Overview

PhenoDigm provides a cross-species phenotype similarity measure used by Exomiser to score gene–phenotype relevance. 
It integrates HPO, MP, and ZP annotations via OWLSim, plus bridging ontologies such as UBERON and PATO to align terms across species. 
Each disease or model is represented as a set of ontology concepts with inferred attributes up the ontology graph, so matches consider ancestor terms automatically. 
This section focuses on the equations and scoring steps. 
Where the paper gives an explicit formulation this is marked **reported**. 
Where a precise formula is not printed in the paper but follows directly from its description this is marked **inferred**.

## Pairwise concept similarity

Two ontology concepts $$p$$ and $$q$$ are compared using OWLSim. The paper evaluates Jaccard, information content, and their combination, and selects the geometric mean for the final concept-level score.

1. Jaccard similarity (**reported**):

$$
\text{simJ}(p,q)=\frac{\lvert A(p)\cap A(q)\rvert}{\lvert A(p)\cup A(q)\rvert}
$$

where $$A(\cdot)$$ is the set of inferred attributes for a phenotype concept, typically including ancestors in the ontology.

2. Information content of the least common subsumer (**reported**):

$$
\text{IC}(c)=-\log\frac{N(c)}{N_{\mathrm{all}}}
$$

where $$N(c)$$ is the number of annotations to concept $$c$$ and $$N_{\mathrm{all}}$$ is the total number of annotations in the corpus. For a concept pair, OWLSim uses $$c=\text{LCS}(p,q)$$.

3. Concept-pair score as geometric mean (**reported choice**, **inferred normalisation**):

$$
\tilde{\text{IC}}(p,q)=\frac{\text{IC}(\text{LCS}(p,q))}{\text{IC}_{\max}}
$$

$$
s(p,q)=\sqrt{\text{simJ}(p,q)\cdot \tilde{\text{IC}}(p,q)}
$$

The paper states that the geometric mean of IC and simJ is used and performs best, but does not print the exact rescaling step; the $$\text{IC}_{\max}$$ normalisation above is a minimal assumption to place IC on $$[0,1]$$ before taking a geometric mean.

## Set to set similarity

Let disease $$a$$ have concepts $$P=\{p_i\}_{i=1}^{m}$$ and model $$b$$ have concepts $$Q=\{q_j\}_{j=1}^{n}$$. 
Define the best match for each disease term as $$bsm_i=\max_j s(p_i,q_j)$$. 
Two overall raw scores are then computed:

* Maximum match (**reported**):

$$
\text{maxScore}(a,b)=\max_{1\le i\le m}\ bsm_i
$$

* Mean best match (**reported**):

$$
\text{avgScore}(a,b)=\frac{1}{m}\sum_{i=1}^{m} bsm_i
$$

## Scaling to a percentage of a hypothetical perfect match

Raw scores are not on an absolute scale. PhenoDigm therefore expresses them relative to a best possible score for the disease by choosing, for each $$p_i$$, the model concept that maximises the pairwise score.

Let $$\mathcal{O}$$ be the ontology’s concept space. Define disease-specific upper bounds (**inferred from description**):

$$
\text{maxScore}_{\max}(a)=\max_{1\le i\le m}\ \max_{q\in\mathcal{O}} s(p_i,q)
$$

$$
\text{avgScore}_{\max}(a)=\frac{1}{m}\sum_{i=1}^{m}\ \max_{q\in\mathcal{O}} s(p_i,q)
$$

Scale to percentages (\*\*reported as step, formulas **inferred**):

$$
\text{maxPct}(a,b)=100\cdot\frac{\text{maxScore}(a,b)}{\text{maxScore}_{\max}(a)}
$$

$$
\text{avgPct}(a,b)=100\cdot\frac{\text{avgScore}(a,b)}{\text{avgScore}_{\max}(a)}
$$

## Combined percentage score

PhenoDigm uses the average of the two percentage measures as the final score presented to users (**reported choice**, formula **inferred**):

$$
\text{combinedPct}(a,b)=\frac{\text{maxPct}(a,b)+\text{avgPct}(a,b)}{2}
$$

This score is used to rank animal models for a disease and, when projected to genes, to rank genes by phenotype similarity.

## Relation to Exomiser’s phenotype score

Exomiser queries human disease annotations, mouse and zebrafish models, and protein interaction neighbours, then takes the best available semantic similarity for each candidate gene as its phenotype score. In practice, PhenoDigm’s concept- and set-level similarities are the basis of this value. HPO terms provided for a proband propagate up the ontology, so even a single term can yield non-exact but ontologically related matches. Mode of inheritance checks in Exomiser do not alter PhenoDigm’s similarity itself but can down-weight Exomiser’s gene phenotype score when an OMIM MOI conflict is detected.

## References

See [exomiser](exomiser) for the use of this algorithm in context.

> Damian Smedley, Anika Oellrich, Sebastian Köhler, Barbara Ruef, Sanger Mouse Genetics Project, Monte Westerfield, Peter Robinson, Suzanna Lewis, Christopher Mungall, PhenoDigm: analyzing curated annotations to associate animal models with human diseases, Database, Volume 2013, 2013, bat025, <https://doi.org/10.1093/database/bat025>

