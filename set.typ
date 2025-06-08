#let font-size = 12pt
#let double-spacing = 1.5em

#show heading: set text(size: font-size)
#show heading: set block(spacing: double-spacing)

#show heading: it => emph(strong[#it.body.])
#show heading.where(level: 1): it => align(center, strong(it.body))
#show heading.where(level: 2): it => align(center, strong(it.body))

#show heading.where(level: 3): it => par(
  first-line-indent: 0in,
  strong(it.body),
)

#show heading.where(level: 4): it => strong[#it.body.]
#show heading.where(level: 5): it => emph(strong[#it.body.])

#show table.cell: set par(leading: 1em)

  #show figure: set block(breakable: true, sticky: true)

  #set figure(
    gap: double-spacing,
    placement: auto,
  )

  #set figure.caption(separator: parbreak(), position: top)
  #show figure.caption: set align(left)
  #show figure.caption: set par(first-line-indent: 0em)
  #show figure.caption: it => {
    strong[#it.supplement #context it.counter.display(it.numbering)]
    it.separator
    emph(it.body)
  }

  #set table(
    stroke: (x, y) => if y == 0 {
      (
        top: (thickness: 1pt, dash: "solid"),
        bottom: (thickness: 0.5pt, dash: "solid"),
      )
    },
  )

  #set list(
    marker: ([•], [◦]),
    indent: 0.5in - 1.75em,
    body-indent: 1.3em,
  )

  #set enum(
    indent: 0.5in - 1.5em,
    body-indent: 0.75em,
  )

  #set raw(
    tab-size: 4,
    block: true,
  )

  #show raw.where(block: true): block.with(
    fill: luma(250),
    stroke: (left: 3pt + rgb("#6272a4")),
    inset: (x: 10pt, y: 8pt),
    width: auto,
    breakable: true,
    outset: (y: 7pt),
    radius: (left: 0pt, right: 6pt),
  )

  #show raw: set text(
    font: "Cascadia Code",
    size: 10pt,
  )

  #show raw.where(block: true): set par(leading: 1em)
  #show figure.where(kind: raw): set block(breakable: true, sticky: false, width: 100%)

  #set math.equation(numbering: "(1)")

  #show quote.where(block: true): set block(spacing: double-spacing)

  #show quote: it => {
    let quote-text-words = to-string(it.body).split(regex("\\s+")).filter(word => word != "").len()

    if quote-text-words < 40 {
      ["#it.body" ]

      if (type(it.attribution) == label) {
        cite(it.attribution)
      } else if (
        type(it.attribution) == str or type(it.attribution) == content
      ) {
        it.attribution
      }
    } else {
      block(inset: (left: 0.5in))[
        #set par(first-line-indent: 0.5in)
        #it.body
        #if (type(it.attribution) == label) {
          cite(it.attribution)
        } else if (type(it.attribution) == str or type(it.attribution) == content) {
          it.attribution
        }
      ]
    }
  }

  #set bibliography(style: "apa")
  #show bibliography: set par(first-line-indent: 0in)