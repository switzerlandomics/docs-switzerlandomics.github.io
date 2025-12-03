---
layout: default
title: Project design Quant ES 
math: mathjax
parent: Design documents
has_children: false
nav_order: 7
---

Last update: 20251130


# Quant Evidence Standard model (Quant ES)

**TLDR:** This method takes the evidence used in clinical genetics, such as genotype and gnomad frequency, and measures how much verifiable information is available for each variant. It uses a universal registered checklist and returns a clear score with a credible interval.
The same technique is suitable for making AI blackbox results verifiable.
Although the paper/method stands on its own, the approach can already be applied directly within the national-scale framework we are developing through the public non-profit Swiss Genomics Association. [The third pillar](https://www.swissgenomicsassociation.ch/pages/three_pillars/) focuses on separating verifiable evidence from the final clinical or commercial result, and the model provides an open and transparent evidential layer that hospitals, research groups, and external providers can use without changing their internal systems.


## Stage 1. What the model tries to measure

For every genetic variant, the evidence standard asks a checklist of questions. Examples include:

- Is the gene known to cause the disease?
- Is the inheritance pattern consistent?
- Is the variant supported by population data?
- Is the protein domain known to be important?

Each question is answered with yes or no. For variant *i*, suppose there are *m* such questions in total. The result is a row of answers like:

yes, no, yes, yes, no, ...

We convert these into numbers:

- yes becomes 1  
- no becomes 0

This creates an evidence vector  
$$X_{i1}, X_{i2}, \ldots, X_{im}$$

The total number of yes answers is called $$k_i$$.  
It is just the count of 1s.

Purpose: we want to estimate how complete the evidence is for this variant. Not whether it is causal, but how much solid scientific information exists to support interpretation.

---

## Stage 2. The key quantity: evidence sufficiency

Think of a variant as having an underlying evidence strength. Call this $$\theta_i$$.

Interpretation: $$\theta_i$$ is the true proportion of items in the checklist that the variant genuinely satisfies. If you looked at one item chosen at random, $$\theta_i$$ is the chance the answer would be yes. This does not assume any hidden evidence outside the checklist and simply summarises the completeness of what is available today.

If $$\theta_i$$ is high, most evidence domains are present. If it is low, most are missing.

We do not know $$\theta_i$$, even if we observe something like 8 out of 10. The observed proportion is only an estimate of the underlying proportion. Even 10 out of 10 still gives a distribution with uncertainty. It is a very narrow distribution, but not a single fixed value. Given these 10 yes answers, what is the plausible underlying proportion of evidence domains this variant would satisfy if we could check many more similar items?

Equation introduced with plain explanation:

- $$\theta_i$$: the underlying proportion of evidence domains satisfied for variant *i*.

---

## Stage 3. How the observed answers relate to the hidden evidence sufficiency

We see $$k_i$$ yes answers out of *m*. The model treats these as repeated trials with success probability $$\theta_i$$.

In plain text:

- You observe $$k_i$$ successes (yes) out of *m* attempts (questions).  
- You want to infer the underlying success probability $$\theta_i$$.

Mathematically:

- $$k_i \mid \theta_i$$ follows a binomial distribution.  
- A binomial distribution describes counts of successes out of a fixed number of tries.

Written:

$$k_i \mid \theta_i \sim \text{Binomial}(m, \theta_i)$$

Meaning: if the true evidence strength were $$\theta_i$$, you would expect $$k_i$$ out of the *m* questions to be yes.

---

## Stage 4. What we assume before seeing any data

Before looking at the variant, we treat all values of $$\theta_i$$ between 0 and 1 as equally plausible.

This is called a uniform prior, which in Bayesian maths is written as:

$$\theta_i \sim \text{Beta}(1, 1)$$

The Beta distribution is just a way to describe probabilities that must lie between 0 and 1.

---

## Stage 5. After seeing the data: computing the updated evidence strength

The observed count $$k_i$$ updates our belief about $$\theta_i$$.  
The result is a posterior distribution.

With a Beta prior and binomial data, the posterior also takes a Beta form. This update has a simple formula:

$$\theta_i \mid k_i \sim \text{Beta}(1 + k_i,\; 1 + m - k_i)$$

Explanation:

- The first number, $$1 + k_i$$, says how many yes answers strengthen the estimate.  
- The second number, $$1 + m - k_i$$, says how many no answers weaken it.

This distribution gives:

- a posterior mean (the central tendency)  
- a credible interval (the uncertainty)  
- the full range of plausible values of $$\theta_i$$

Interpretation: this is your best estimate of how complete the evidence is for this variant.

---

## Stage 6. Looking beyond one variant: the global evidence landscape

A genome contains millions of variants. Each has its own posterior distribution of $$\theta_i$$.

By taking random samples from all these posteriors across the genome, we get a global picture of how much evidence is usually available. Many variants lie in regions with little scientific information, so the background distribution is often skewed towards lower values.

This global mixture provides context.

---

## Stage 7. Comparing a variant to all alternatives

A clinician needs to know not only how complete the evidence is for the chosen variant, but also whether other variants in the genome might have as much or more evidence.

We compute a percentile:

$$\text{percentile}(i) = P(\theta_j \le \theta_i)$$

Interpretation:

- If the percentile is 99, the variant has more supporting evidence than 99 percent of all variants evaluated in that genome.  
- If the percentile is 20, there are many alternatives with stronger or comparable support.

---

## Stage 8. What this achieves

By structuring evidence as:

1. a yes or no matrix  
2. a latent evidence strength $$\theta_i$$  
3. a Beta–Binomial updating rule  
4. a global comparison through percentiles  

the system provides a transparent, quantitative assessment of how much known scientific information exists for each variant.

This does not claim causality. It simply measures completeness and reliability of the evidence that is available today.


