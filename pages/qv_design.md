---
layout: default
title: QV design principles
nav_order: 5
---

Last update: 20250825

# QV design principles

---

A short guide for writing portable, reusable qualifying variant (QV) sets.

QV sets are written to be tool agnostic, using standard field names and simple logic
(field, operator, value). This minimises custom or pipeline specific content and makes
each set portable across tools and studies. Tool specific flags, for example PLINK or Hail,
are optional in a separate section, while the main definitions describe only the
biological or statistical criteria. This design keeps QV files reusable, easy to review,
and consistent across projects.

## Purpose

- Describe what qualifies, not how a specific tool implements the rule
- Enable sharing, review, reuse, and exact reproduction across pipelines

## Scope

- Applicable to research and clinical genomics
- Covers variant filtering, classification criteria, and analysis thresholds

## Core principles

- Tool agnostic: express biology or statistics, not flags
- Atomic rules: one concept per rule
- Composable: combine rules with explicit logic
- Clear metadata: every set is self describing
- Stable IDs and versions

## Minimal schema

```yaml
qv_set_id: string
version: string
title: string
description: string
metadata:
  created: YYYY-MM-DD
  authors: [ "Name One", "Name Two" ]
  tags: [ "GWAS", "QC" ]

filters:
  rule_key:
    description: string
    logic: keep_if | drop_if
    field: string            # optional if a single field applies
    threshold_min: number | null
    threshold_max: number | null
    notes: string            # optional

criteria:
  label_key:
    description: string
    logic: and | or
    conditions:
      - field: string | null
        operator: "==" | "!=" | "<" | "<=" | ">" | ">=" | "in" | "not_in" | "exists"
        value: scalar | null
        values: [ scalar, ... ]     # for in or not_in
        group_by: [ field, ... ]    # optional grouping
        count: ">=2"                # comparator for grouped counts
        additional_criteria:        # optional nested condition
          field: string
          operator: string
          value: scalar

dependencies: [ "other_label_key" ]   # optional cross references
implementations: {}                   # optional tool hints
notes: []                             # optional free text

```

## Dev notes


```
here is a developer note for the minimal qv yaml builder

purpose

* Single line entry to build valid QV YAML from a tiny DSL
* No dropdowns, no multi-field forms
* Immediate YAML preview and removable line chips

scope

* Supports meta, filters, criteria, notes
* Users type one statement per line
* Lines can be added and removed
* YAML exported with stable ordering

ui

* One text input for a single statement
* Buttons: add, reset, copy, download
* Chips list of added statements grouped by type
* YAML preview panel
* Lightweight examples shown as text under the input
* No menus, no wizards

input syntax

* One line per statement
* Keywords: meta, filter, criteria, note
* Tokens are key=value pairs where relevant
* Values can be numbers, booleans, null, quoted strings, or comma lists

grammar

* meta
  `meta <key> <value>`
  or `meta <key>=<value>`
  Examples
  `meta qv_set_id qv_gwas_common_v1_20250827`
  `meta version 1.0.0`
  `meta title="GWAS common QC"`
  `meta created 2025-08-27`
  `meta authors=["Alice","Bob"]`
  `meta tags=GWAS,QC,PCA`

* filter
  `filter <label> field=<name> operator<op> value=<val> [logic=<keep_if|drop_if>] [desc="text"]`
  Examples
  `filter maf_minimum field=MAF operator>= value=0.01 desc="Minimum MAF"`
  `filter hwe field=HWE_P operator>= value=1e-6 logic=keep_if`

* criteria
  Aggregates by repeating the same label. One condition per line.
  `criteria <label> [field=<name> operator<op> [value=<val>]] [group_by=a,b,...] [count="<cmp>"] [logic=<and|or>] [desc="text"] [add.field=<f> add.operator<op> add.value=<v>]`
  Examples
  `criteria ps5 field=IMPACT operator== value=HIGH desc="Comp het with HIGH"`
  `criteria ps5 group_by=sample,SYMBOL count=">=2"`
  `criteria ps3 field=genotype operator== value=1 add.field=Inheritance add.operator=in add.value=AD,AD/AR logic=or`

* note
  `note "free text"`

operators

* `== != < <= > >= in not_in exists`
* For `in` and `not_in` use comma lists, eg `A,B,C`
* For `exists` omit value

parsing rules

* Numbers: `0.01`, `1e-6` parsed as numbers
* Booleans: `true`, `false`
* Null: `null`
* Quoted strings preserved
* Comma lists become arrays
* `authors=["A","B"]` is allowed, also `authors=A,B`
* For `group_by`, split comma list to array and trim
* For `count`, store the comparator string as entered, eg `>=2`
* `add.field`, `add.operator`, `add.value` create `additional_criteria` for that condition

aggregation

* Repeated `criteria <label>` lines append to `criteria.<label>.conditions`
* `desc=` on the first criteria line sets `criteria.<label>.description`
  If given again, last one wins
* `logic=` on any criteria line sets `criteria.<label>.logic`
* Repeated `filter <label>` updates the same filter block

yaml assembly order

* Top level: `qv_set_id`, `version`, `title`, `description`, `metadata`, `run`, `filters`, `criteria`, `ld_pruning`, `pca`, `covariates`, `association`, `implementations`, `notes`
* `metadata`: `created`, `authors`, `tags`
* Emit filters and criteria in entry order
* Inside filter: `description`, `logic`, then other keys
* Inside criteria label: `description`, `logic`, `dependencies` if supported later, then `conditions`
* Inside each condition: `field`, `operator`, `value`, `group_by`, `count`, `additional_criteria`
* Do not quote numeric or boolean scalars unnecessarily

error handling

* If a line cannot be parsed, show a small inline error and do not add
* Minimal validation messages, eg unknown keyword, missing label, missing operator
* Preserve user line in the input for correction

chips behaviour

* Each added line appears as a chip showing the original text
* Click a chip to remove that exact line and rebuild YAML
* Chips grouped by type with tiny headings for readability

non goals

* No background fetching, no schema discovery
* No automatic inference of complex tool implementation flags

testing checklist

* Add basic meta fields and confirm YAML order
* Add two filters and confirm threshold\_min and threshold\_max mapping via operators
* Build multi condition criteria ps5 as in corpus
* Build criteria with additional\_criteria for ps3
* Add note lines and confirm list output
* Try `exists` operator
* Try numbers, booleans, arrays, and quoted strings
* Remove chips and confirm YAML updates deterministically

future extensions (optional)

* `dependencies=` on criteria lines
* Export and import of the one line script
* Simple undo of last add

this aligns the UI with a single line input model, avoids menus, and preserves a stable YAML layout for human review and version control.
```
