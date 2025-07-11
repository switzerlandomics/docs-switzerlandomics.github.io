---
layout: default
math: mathjax
title: MathJax config
nav_order: 5
---

# MathJax Configuration

1.  Create or extend `_includes/head_custom.html` with:

    {% raw %}
    ```html
    {% assign math = page.math | default: layout.math | default: site.math %}

    {% case math %}
      {% when "mathjax" %}
        {% include mathjax.html %}
    {% endcase %}
    ```
    {% endraw %}

2.  Copy the following files to your website source repo:

- [`_includes/mathjax.html`]
- [`_layouts/mathjax.html`]
- [`assets/js/mathjax-script-type.js`]

{: .note }
For the source file `_includes/mathjax.html` from just-the-docs, we have updated the incorrectly set path from
`src="/just-the-docs/assets/js/mathjax-script-type.js"` to the repositry root `src="/assets/js/mathjax-script-type.js"`.

3.  To make MathJax available on *all* your web pages, add to `_config.yml`:

    ```yaml
    math: mathjax
    ```

    To restrict MathJax to pages that use it, add to the front matter either:

    ```yaml
    math: mathjax
    ```

    or:

    ```yaml
    layout: mathjax
    ```

    You can add a preamble of MathJax definitions of new commands and environments
    in [`_layouts/mathjax.html`]. It extends the `default` layout. 

## MathJax options

You can customise MathJax by adding further [options] in [`_includes/mathjax.html`].

[`_includes/mathjax.html`]: https://github.com/just-the-docs/just-the-docs-tests/blob/main/_includes/mathjax.html
[`_layouts/mathjax.html`]: https://github.com/just-the-docs/just-the-docs-tests/blob/main/_layouts/mathjax.html
[`assets/js/mathjax-script-type.js`]: https://github.com/just-the-docs/just-the-docs-tests/blob/main/assets/js/mathjax-script-type.js)
[options]: https://docs.mathjax.org/en/latest/web/configuration.html

You can customise Just the Docs sites to support [MathJax],
as explained in the [configuration suggestions]. 
Pages then render $$\mathrm{\LaTeX}$$ code in [kramdown math blocks] using MathJax.

For example:

$$
\begin{aligned}
  & \phi(x,y) = \phi \left(\sum_{i=1}^n x_ie_i, \sum_{j=1}^n y_je_j \right)
  = \sum_{i=1}^n \sum_{j=1}^n x_i y_j \phi(e_i, e_j) = \\
  & (x_1, \ldots, x_n) \left( \begin{array}{ccc}
      \phi(e_1, e_1) & \cdots & \phi(e_1, e_n) \\
      \vdots & \ddots & \vdots \\
      \phi(e_n, e_1) & \cdots & \phi(e_n, e_n)
    \end{array} \right)
  \left( \begin{array}{c}
      y_1 \\
      \vdots \\
      y_n
    \end{array} \right)
\end{aligned}
$$

To see the $$\mathrm{\LaTeX}$$ source of the formula, right-click anywhere on it.

[MathJax]: https://mathjax.org
[configuration suggestions]: https://just-the-docs.github.io/just-the-docs-tests/components/math/mathjax/config
[kramdown math blocks]: https://kramdown.gettalong.org/syntax.html#math-blocks
