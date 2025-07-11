---
layout: default
title: Style guide
nav_order: 5
---

Last update: 20230828
# Page style guide for documentation

1. Meta data: 
    - short title for navigation and sidebar.
    - `nav_order` set to 5 so that all pages are alphabetically sorted expect highly important ones which can be order 1, 2, etc. 
2. Last update: written in plane text before title. We do not add to metadata.
3. If required, use a table of contents (TOC) after the title. 
4. Images can be stored in `assets/images`.
5. For LaTeX format equations see MathJax config

Here is the style guideline for .md page layout in these documents. 

```md
---
layout: default
title: Page styles (short heading for sidebar/nav)
nav_order: 5
---

Last update: 20230828
# Title long format for page heading

* TOC
{:toc}

## Heading 2

Include images
<img src="{{ "assets/images/acat/p_acat.png" | relative_url }}" width="80%">
```
