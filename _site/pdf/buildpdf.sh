#!/bin/bash

# can not read frontmatter or embedded content liquid
pandoc ../docs/index.md --output=index.pdf

# can not read embedded content liquid
pandoc ../docs/_site/index.html --output=indexhtml.pdf

# consider doing jekyll-offline script, then pandoc from html, then pdfunite.
