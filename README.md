# typst-polylux-slides

My new setup to create slide decks with [Typst](https://github.com/typst/typst) and [Polylux](https://github.com/polylux-typ/polylux) that can then be presented with [`pdfpc`](https://pdfpc.github.io/). See also my [blog post](https://yohan.beugin.org/posts/2025_11_new_slides_setup.html).

## Workflow

- Install Typst
- `git clone --recurse-submodules git@github.com:yohhaan/typst-polylux-slides.git`
- Edit [`demo.typ`](demo.typ)
- Generate `.pdf` with `make demo.pdf`
- Generate `.pdfpc` file with `make demo.pdfpc`
- Present with `pdfpc demo.pdf`

Notes:
- watch and recompile on change with `make watch FILE=demo.typ`
- Polylux is great, but releases appear a bit sporadic, so in order to have the latest changes, I am using git submodule and link directly to it in the theme template.

