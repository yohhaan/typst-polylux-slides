#import "../polylux/src/polylux.typ": *

#let fontHeader = "Roboto"
#let primaryColor = rgb("#C5050C")
#let headerSize = 32pt
#let subheaderSize = 24pt
#let textSize = 20pt
#let footerSize = 9pt

#let outerMargin = 3mm
#let innerMargin = 11mm
#let topMargin = 10mm
#let bottomMargin = 11mm

#let green = rgb(0, 150, 130)
#let blue = rgb(70, 100, 170)
#let gray = rgb(64, 64, 64)
#let brown = rgb(167, 130, 46)
#let purple = rgb(163, 16, 124)
#let cyan = rgb(35, 161, 224)
#let lime = rgb(140, 182, 60)
#let yellow = rgb(252, 229, 0)
#let orange = rgb(223, 155, 27)
#let red = rgb("#C5050C")

#let slidesTitle = state("slidesTitle", [])
#let slidesSubtitle = state("slidesSubtitle", [])
#let slidesShortTitle = state("slidesShortTitle", none)
#let slidesAuthor = state("slidesAuthor", [])
#let slidesShortAuthor = state("slidesShortAuthor", none)
#let slidesVenue = state("slidesVenue", [])
#let slidesDate = state("slidesDate", none)
#let slidesShowPageCount = state("slidesShowPageCount", false)

// Generate the .pdfpc file directly from a typst query command, see https://github.com/polylux-typ/polylux/pull/123
#let pdfpc-file = {
  context {
    let arr = query(<pdfpc>).map(it => it.value)
    let (config, ..slides) = arr.split((t: "NewSlide"))
    let pdfpc = (
      pdfpcFormat: 2,
      disableMarkdown: false,
    )
    for item in config {
      pdfpc.insert(lower(item.t.at(0)) + item.t.slice(1), item.v)
    }
    let pages = ()
    for slide in slides {
      let page = (
        idx: 0,
        label: 1,
        overlay: 0,
        forcedOverlay: false,
        hidden: false,
      )
      for item in slide {
        if item.t == "Idx" {
          page.idx = item.v
        } else if item.t == "LogicalSlide" {
          page.label = item.v
        } else if item.t == "Overlay" {
          page.overlay = item.v
          page.forcedOverlay = item.v > 0
        } else if item.t == "HiddenSlide" {
          page.hidden = true
        } else if item.t == "SaveSlide" {
          if "savedSlide" not in pdfpc {
            pdfpc.savedSlide = page.label - 1
          }
        } else if item.t == "EndSlide" {
          if "endSlide" not in pdfpc {
            pdfpc.endSlide = page.label - 1
          }
        } else if item.t == "Note" {
          page.note = item.v
        } else {
          pdfpc.insert(lower(item.t.at(0)) + item.t.slice(1), item.v)
        }
      }
      pages.push(page)
    }
    pdfpc.insert("pages", pages)
    [#metadata(pdfpc)<pdfpc-file>]
  }
}

#let roundedBlock(radius: 3mm, body) = {
  block(
    radius: (
      top: radius,
      bottom: radius,
    ),
    clip: true,
    body,
  )
}

#let colorBlock(title: [], color: [], body) = {
  let title-color = if luma(color).components().at(0) >= 80% {
    black
  } else {
    white
  }
  roundedBlock()[
    #block(
      width: 100%,
      inset: (x: 0.5em, top: 0.3em, bottom: 0.4em),
      fill: gradient.linear(
        (color, 0%),
        (color, 87%),
        (color.lighten(85%), 100%),
        dir: ttb,
      ),
      text(fill: title-color, title),
    )
    #set text(size: 15pt)
    #block(
      inset: 0.5em,
      above: 0pt,
      fill: color.lighten(85%),
      width: 100%,
      body,
    )
  ]
}

#let infoBlock(title: [], body) = {
  colorBlock(title: title, color: green, body)
}

#let exampleBlock(title: [], body) = {
  colorBlock(title: title, color: blue, body)
}

#let alertBlock(title: [], body) = {
  colorBlock(title: title, color: red, body)
}


#let citeBlock(color: [], body) = {
  roundedBlock()[
    #set text(size: 15pt)
    #block(
      inset: 0.5em,
      above: 0pt,
      fill: color.lighten(85%),
      width: 100%,
      body,
    )
  ]
}

#let slides(
  title: none,
  subtitle: none,
  shortTitle: none,
  author: none,
  shortAuthor: none,
  venue: none,
  date: none,
  showPageCount: false,
  body,
) = {
  set page(
    paper: "presentation-16-9",
    margin: 0pt,
    header-ascent: 0pt,
    footer-descent: 5pt,
  )

  set text(font: ("Source Sans 3", "Roboto"), size: textSize)
  show heading: set text(fill: primaryColor)
  show link: set text(fill: blue)

  slidesTitle.update(title)
  slidesSubtitle.update(subtitle)
  if shortTitle == none {
    slidesShortTitle.update(title)
  } else {
    slidesShortTitle.update(shortTitle)
  }
  slidesAuthor.update(author)
  if shortAuthor == none {
    slidesShortAuthor.update(author)
  } else {
    slidesShortAuthor.update(shortAuthor)
  }
  slidesVenue.update(venue)
  slidesDate.update(date)
  slidesShowPageCount.update(showPageCount)

  set list(marker: text(fill: primaryColor, sym.circle.filled))

  body
  pdfpc-file
}

#let titleSlide(body) = {
  show: slide
  set page(
    margin: 0pt,
    header: none,
    footer: none,
    background: align(top, image("uw.svg", width: 100%)),
  )
  pad(left: innerMargin, right: 6mm, top: topMargin)[
    // Title
    #place(dy: 42mm, text(
      font: fontHeader,
      fill: primaryColor,
      weight: "bold",
      size: headerSize,
      context slidesTitle.get(),
    ))
    // Subtitle
    #place(dy: 54mm)[
      #set text(font: fontHeader, fill: primaryColor, weight: "regular", size: subheaderSize)
      #context slidesSubtitle.get()
    ]
    // Author
    #place(dy: 70mm)[
      #set text(font: fontHeader, weight: "medium", size: 18pt)
      #context slidesAuthor.get()
    ]
    // Author
    #place(dy: 78mm)[
      #set text(font: fontHeader, weight: "thin", size: 18pt)
      #context slidesDate.get() • #context slidesVenue.get()
    ]
    // Body
    #place(dy: 88mm, [
      #set text(size: textSize)
      #set block(above: 1.2em)
      #body
    ])
  ]
  //logos
  align(
    bottom,
    pad(x: outerMargin, y: outerMargin)[
      #grid(
        columns: (1.5fr, outerMargin, 1.5fr, 2fr),
        [#link("https://cdis.wisc.edu/")[#image("cdis.svg")]],
        [],
        [#link("https://madsp.cs.wisc.edu/")[#image("madsnp.svg")]],
        [],
      )
    ],
  )
}

#let sectionSlide(title: none, register: none, body) = {
  if register != none {
    toolbox.register-section(register)
  }
  show: slide
  set page(
    margin: 0pt,
    header: none,
    footer: none,
    background: align(top, image("uw.svg", width: 100%)),
  )
  pad(left: innerMargin, right: 6mm, top: topMargin)[
    // Title
    #place(dy: 54mm, text(font: fontHeader, fill: primaryColor, weight: "bold", size: 32pt, title))
    //Body
    #place(dy: 70mm, [
      #set text(textSize)
      #set block(above: 1.2em)
      #body
    ])
  ]
}


#let newSlide(title: [], body) = {
  // Header
  let header = block(width: 100%, height: 100%, inset: (x: innerMargin))[
    #grid(
      columns: (auto, 1fr),
      [
        #set text(font: fontHeader, fill: primaryColor, size: headerSize, weight: "bold")
        #block(height: 100%)[
          #align(left + horizon, title)
        ]
      ],
      [
        #align(right + horizon)[
          #image("uw-crest.svg", height: 15mm)
        ]
      ],
    )
  ]
  // Content block
  let wrapped-body = block(
    width: 100%,
    height: 100%,
    inset: (x: innerMargin),
  )[
    #set text(textSize)
    #set block(above: 1.2em)
    #body
  ]
  // Footer
  let sections-band = toolbox.all-sections((sections, current) => {
    set text(fill: gray, size: footerSize)
    sections.map(s => if s == current { strong(s) } else { s }).join([ • ])
  })
  let footer = block(width: 100%, inset: (x: outerMargin))[
    #set block(above: 0pt)
    #set text(fill: gray, size: footerSize)
    #line(stroke: rgb("#d8d8d8"), length: 100%)
    #block(width: 100%, height: 100%)[
      #align(horizon)[
        #grid(
          columns: (30mm, 5mm, 1fr, auto),
          link("https://madsp.cs.wisc.edu/")[#image("madsnp.svg")],
          [],
          [#context slidesShortAuthor.get() • #context slidesShortTitle.get() • #context slidesDate.get()],
          align(right, context if slidesShowPageCount.get() [
            #sections-band #h(5mm) #toolbox.slide-number/#strong([#counter("logical-slide").at(<unnumbered>).at(0)])
          ] else [
            #sections-band #h(5mm) #toolbox.slide-number
          ]),
        )
      ]
    ]
  ]

  set page(
    header: header,
    footer: footer,
    margin: (top: 22.5mm, bottom: bottomMargin),
  )
  slide(wrapped-body)
}

