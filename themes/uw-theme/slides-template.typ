#import "../polylux/src/polylux.typ": *

#let fontHeader = "Roboto"
#let primaryColor = rgb("#C5050C")
#let headerSize = 28pt
#let subheaderSize = 24pt
#let textSize = 18pt
#let footerSize = 12pt

#let outerMargin = 3mm
#let innerMargin = 11mm
#let topMargin = 16mm
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

#let publicationBlock(color: [], award: false, body) = {
  let text-color = if luma(color).components().at(0) >= 70% {
    black
  } else {
    white
  }
  block(
    radius: (
      top: 3mm,
      bottom: 3mm,
    ),
    clip: true,
    inset: 0.3em,
    above: 5pt,
    below: 5pt,
    spacing: 0.3em,
    fill: color,
    width: 80%,
    stroke: if award { (paint: black, thickness: 2pt, dash: "dashed") },
  )[
    #set align(center)
    #set text(fill: text-color, size: 15pt)
    #show link: set text(fill: text-color)
    #body]
}

#let fig(block1, caption) = {
  [
    #set align(center)
    #block1
    #v(-15pt)
    #text(size: 16pt, fill: gray)[#caption]]
}


#let roundedBlock(radius: 3mm, body) = {
  block(
    width: auto,
    radius: (
      top: radius,
      bottom: radius,
    ),
    clip: true,
    body,
  )
}

#let colorBlock(title: none, color: [], width: 100%, body) = {
  let title-color = if luma(color).components().at(0) >= 80% {
    black
  } else {
    white
  }
  roundedBlock()[
    #if title != none [
      #block(
        radius: (
          top: 3mm,
          // bottom: 3mm,
        ),
        clip: true,
        width: width,
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
        width: width,
        body,
      )
    ] else [
      #set text(size: 15pt)
      #block(
        radius: (
          top-right: 3mm,
          // bottom: 3mm,
        ),
        inset: 0.5em,
        above: 0pt,
        fill: color.lighten(85%),
        width: width,
        body,
      )
    ]
  ]
}

#let infoBlock(title: none, width: 100%, body) = {
  colorBlock(title: title, color: green, width: width, body)
}

#let exampleBlock(title: none, width: 100%, body) = {
  colorBlock(title: title, color: blue, width: width, body)
}

#let alertBlock(title: none, width: 100%, body) = {
  colorBlock(title: title, color: red, width: width, body)
}


#let citeBlock(color: [], body) = {
  roundedBlock()[
    #set text(size: footerSize)
    #block(
      inset: 0.5em,
      above: 0pt,
      fill: color.lighten(85%),
      width: 100%,
      body,
    )
  ]
}

#let focus(body) = text(fill: primaryColor, body)

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
    // fill: white.darken(2%),
    margin: 0pt,
    header-ascent: 5pt,
    footer-descent: 10pt,
  )

  //styling edits
  set text(font: ("Source Sans 3", "Roboto"), size: textSize)
  show heading: set text(fill: primaryColor, weight: "regular")
  show link: set text(fill: blue)
  set list(marker: (text(primaryColor, [•]), text(primaryColor, [•]), text(gray, [-])))


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


  body
  pdfpc-file
}


#let abstractSlide(
  title: [#context slidesTitle.get()],
  picture: [#image("avatar.jpg", width: 80%)],
  author: [#context slidesAuthor.get()],
  role: [Position],
  url: "https://example.com/",
  body,
) = {
  show: slide
  set page(
    margin: outerMargin,
    header: none,
    footer: none,
    background: none,
  )
  align(center + horizon)[
    #text(
      font: fontHeader,
      fill: primaryColor,
      weight: "regular",
      size: headerSize,
    )[#title]]


  toolbox.side-by-side(columns: (.25fr, .75fr))[
    // Speaker pic + name + affiliation
    #set align(center + horizon)
    #link(url)[#picture]
    #text(font: fontHeader, weight: "medium", size: subheaderSize)[#context slidesAuthor.get()]\
    #text(font: fontHeader, weight: "thin", size: textSize)[#role]\
    #text(size: textSize)[#link(url)]
    #link("https://cdis.wisc.edu/")[#image("uw-madison.svg")]

  ][
    #set text(size: textSize)
    #set align(horizon)
    // Abstract
    #body
  ]
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
    #place(dy: 42mm)[
      // Title
      #text(
        font: fontHeader,
        fill: primaryColor,
        weight: "regular",
        size: headerSize,
        context slidesTitle.get(),
      )\
      //Subtitle
      #text(font: fontHeader, fill: primaryColor, weight: "thin", size: subheaderSize, context slidesSubtitle.get())\
      // Author
      #text(font: fontHeader, weight: "medium", size: textSize, context slidesAuthor.get())\
      // Date - Venue
      #text(font: fontHeader, weight: "thin", size: textSize)[#context slidesDate.get() • #context slidesVenue.get()]\
      // Body
      #set text(size: textSize)
      #set block(above: 1.2em)
      #body
    ]
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


// #let titleSlide(body) = {
//   show: slide
//   set page(
//     margin: 0pt,
//     header: none,
//     footer: none,
//     background: align(top, image("uw.svg", width: 100%)),
//   )
//   pad(left: innerMargin, right: 6mm, top: topMargin)[
//     // Title
//     #place(dy: 42mm, text(
//       font: fontHeader,
//       fill: primaryColor,
//       weight: "regular",
//       size: headerSize,
//       context slidesTitle.get(),
//     ))
//     // Subtitle
//     #place(dy: 54mm)[
//       #set text(font: fontHeader, fill: primaryColor, weight: "thin", size: subheaderSize)
//       #context slidesSubtitle.get()
//     ]
//     // Author
//     #place(dy: 78mm)[
//       #set text(font: fontHeader, weight: "medium", size: textSize)
//       #context slidesAuthor.get()
//     ]
//     // Date - Venue
//     #place(dy: 86mm)[
//       #set text(font: fontHeader, weight: "thin", size: textSize)
//       #context slidesDate.get() • #context slidesVenue.get()
//     ]
//     // Body
//     #place(dy: 96mm, [
//       #set text(size: textSize)
//       #set block(above: 1.2em)
//       #body
//     ])
//   ]
//   //logos
//   align(
//     bottom,
//     pad(x: outerMargin, y: outerMargin)[
//       #grid(
//         columns: (1.5fr, outerMargin, 1.5fr, 2fr),
//         [#link("https://cdis.wisc.edu/")[#image("cdis.svg")]],
//         [],
//         [#link("https://madsp.cs.wisc.edu/")[#image("madsnp.svg")]],
//         [],
//       )
//     ],
//   )
// }

#let sectionSlide(title: none, register: none, body) = {
  if register == true {
    toolbox.register-section(title)
  } else if register != none {
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
    #place(dy: 54mm, text(font: fontHeader, fill: primaryColor, weight: "regular", size: headerSize, title))
    //Body
    #place(dy: 70mm, [
      #set text(textSize)
      #set block(above: 1.2em)
      #body
    ])
  ]
}

#let blackSlide(title: none, register: none, body) = {
  if register == true {
    toolbox.register-section(title)
  } else if register != none {
    toolbox.register-section(register)
  }
  show: slide
  set page(
    margin: 0pt,
    header: none,
    footer: none,
    fill: gray,
  )
  pad(left: innerMargin, right: 6mm, top: 0pt)[
    #set text(fill: white, size: textSize)
    #align(center + horizon)[#text(size: headerSize)[#title]]
    //Body
    #body
  ]
}


#let newSlide(title: [], body) = {
  // Header
  let header = table(
    align: (left + horizon, right + horizon),
    columns: (auto, 1fr),
    inset: innerMargin,
    rows: 1fr,
    stroke: (bottom: rgb("#d8d8d8") + 1pt, left: 0pt, right: 0pt, top: 0pt),
    //TITLE
    block(
      width: 100%,
      height: 100%,
    )[
      #set text(font: fontHeader, fill: primaryColor, size: headerSize, weight: "regular")
      #title
    ],
    //RIGHT
    table.cell(
      inset: (right: 80pt),
    )[
      #image("uw-crest.svg", height: 35pt)
    ],
  )
  // Content block
  let wrapped-body = block(
    width: 100%,
    height: 100%,
    inset: (x: innerMargin),
  )[
    #set align(horizon)
    #set text(textSize)
    // #set block(above: 1.2em)
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
    margin: (top: topMargin, bottom: bottomMargin),
  )
  slide(wrapped-body)
}

