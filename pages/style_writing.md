---
layout: default
title: Style writing guide
nav_order: 5
---

Last update: 20250711

## Technical writing style guide

### Writing style

* Prefer active voice unless passive helps clarity.
* Write for global audiences. Avoid slang, idioms, and metaphors.
* Avoid contractions in formal documentation.
* Keep sentences short, ideally under 40 words.
* Use simple present tense where possible.
* Avoid redundant words or phrases.
* Never use an em-dash. Do not use it to create complex sentences. Instead, break long sentences into simpler ones or use alternative punctuation.

### Grammar and punctuation

* Ensure pronoun–antecedent and subject–verb agreement.
* Use “fewer” for countable nouns, “less” for uncountable nouns.
* Do not use possessives for product names or abbreviations.
* Prefer “who” for people and “that” or “which” for things.
* Avoid run-ons and sentence fragments.
* End sentences naturally. Do not force prepositions away from the end of the sentence if it sounds awkward.
* Avoid slashes. Use “or” instead of “and/or.”
* Use the Oxford comma in lists.
* Avoid exclamation marks except in command syntax (e.g. `!`).
* Use hyphens for compound adjectives when needed for clarity.
* Avoid title case in headings and titles. Always use sentence case, meaning only the first word and proper nouns are capitalised.

### Inclusive and clear language

* Use gender-neutral pronouns such as “they.”
* Prefer “you” instead of first-person references.
* Use precise terms. Avoid ambiguous words.
* Spell out acronyms and initialisms at first mention unless widely known (e.g. HTML).
* Avoid anthropomorphism. Do not write “the product allows…” unless referring to permissions.

### Document structure

* Titles:
  * Include the product name, version, and document type.
  * Prefer gerund forms like “Configuring…” for chapters and sections.
  * Avoid one-word titles.
* Headings:
  * Use sentence case.
  * Do not place headings back-to-back without explanatory text between them.
* Abstracts:
  * Briefly state what the document covers, how it is structured, and who it is for.

### Technical content

* Match UI element spelling and casing exactly as shown on screen.
* Prefer “go to” instead of “navigate to.”
* Do not include punctuation from UI elements unless it improves clarity.
* When documenting commands:
  * Show user prompt symbols appropriately (`$` for user, `#` for root).
  * Omit optional flags unless they are critical.
  * Use line continuation characters for long commands.
* Show only relevant command output. Use `...output omitted...` if skipping sections.
* Avoid naming specific text editors unless necessary.
* Use example domains like `example.com` and avoid real IP addresses.
* Use realistic and diverse fictional names.

### Formatting

* Avoid splitting product names across lines.
* Use non-breaking spaces:
  * Between words like “Red” and “Hat.”
  * Between product names and version numbers.
  * Between numbers and units of measure.
* Avoid including file names, commands, or markup in headings.

### Cross-references and citations

* Use “refer to” instead of “see.”
* Do not use “here” as anchor text. Link meaningful words or phrases instead.
* Format citations as:
  * Book: *Title* by Author; Publisher.
  * Website: Include a URL or footnote.

### Admonitions

* Use sparingly:
  * Note → Additional information.
  * Important → Key details the reader must not overlook.
  * Warning → Risk of damage, data loss, or critical errors.

### Lists

* Use bulleted lists when item order does not matter.
* Use numbered lists for ordered steps or when referencing list items elsewhere.
* Use variable lists for terms followed by definitions.
* Use procedures for required steps to complete a task. Always include a title.
* Keep nested lists to two levels or fewer.
* Avoid excessive use of bulleted lists. Consider whether information might be clearer and more pleasant to read as paragraphs instead, especially if lists become deeply nested.

#### Formatting lists for readability

* Add spacing between list items for readability, especially if items include:
  * Nested lists
  * Navigation instructions
  * Multiple sentences or paragraphs
* Avoid placing lists inside the middle of a sentence and then continuing the sentence after the list.
* Lead-in sentences for lists should be complete sentences.
* Ensure list items are grammatically parallel.
* Use consistent punctuation:
  * Complete sentences in a list end with periods.
  * Sentence fragments in a list have no ending punctuation unless followed by complete sentences.
* Avoid graphics in lists except in simple cases.

### Grammatical genders

* Avoid ambiguous pronouns such as “it” or “they” without a clear antecedent.
* Clarify references to terms that might differ in gender in other languages.
* For initialisms or acronyms that refer to multiple concepts, clarify with a noun instead of relying on a pronoun.

### Using markup correctly

* Mark up file names, commands, and technical terms properly in documentation.
* Avoid embedding unmarked literals into running text.
* Never embed technical terms into a sentence without correct markup formatting.
* Example:
  * Instead of: In /usr/local/bin/, grep for XYZ.
  * Use: In the `/usr/local/bin/` directory, use the `grep` command to search for `"XYZ"`.

### Code blocks

* Keep explanatory comments outside of code blocks unless they are part of the literal code syntax.
* Example of incorrect usage:
  ```
  # Display disk usage
  df -h
  ```
* Correct usage:
  Run the following command to display disk usage:
  ```
  df -h
  ```
* Do not include commentary lines that might confuse translation or readers.

### Entities

* Avoid using custom SGML or XML entities for translatable terms.
* Limit entities to those required for the build process, such as:
  * PRODUCT
  * BOOKID
  * YEAR
  * HOLDER
* Do not create entities for common terms (e.g. &VERSION;) or cultural references (e.g. &BIBLE;).
* Use built-in entities if your documentation tool provides them.

### Using cross-references effectively

* Cross-references should add value, not distract readers.
* Only link to additional background information. Do not link away from core task instructions.

Example:

Incorrect:
See Appendix B for file naming conventions.

Correct:
Use lowercase letters and hyphens for file names. For more details, refer to Appendix B.

* Avoid excessive links in a single paragraph. No more than two links per paragraph is recommended.
* Summarise references at the end of sections instead of scattering links throughout text.

### Repetition

* Repeating vital information is acceptable if it avoids forcing readers to navigate to another section.
* Repeat information if:
  * It is less than half a page.
  * It appears in multiple contexts where readers may not follow links.

### Resources

* Follow company-specific style guides first.
* When needed, refer to:
  * IBM Style
  * The Chicago Manual of Style
  * Merriam-Webster Dictionary
* These resources may conflict. Always align with your organisation’s style preferences.

Content types covered:
* Software manuals
* User guides
* Training courses
* White papers

Content excluded:
* Marketing content
* Corporate branding content

