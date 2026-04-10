#import "themes/uw-theme/slides-template.typ": *

#show: slides.with(
  title: [Title],
  subtitle: [Subtitle],
  shortTitle: [Footer Title],
  author: [Author Name],
  shortAuthor: [Footer Author],
  venue: [Venue],
  date: datetime.today().display("[month repr:long] [day], [year]"),
  showPageCount: true,
)

#toolbox.pdfpc.config(
  duration-minutes: 10,
  last-minutes: 2,
  note-font-size: 12,
  disable-markdown: false,
)

//To add an Abstract Slide
#abstractSlide(
  // title: [#context slidesSubtitle.get()],
  // picture: [#image("path.jpg", width: 80%)],
  // author: [Author],
  // role: [Position],
  // url: "https://example.com",
)[
  #set text(size: 15pt)

  #lorem(200)
]

#titleSlide()[
  //Some text on title slide
]

#newSlide(title: [Outline])[
  #toolbox.all-sections((sections, current) => enum(tight: false, ..sections))
]

#toolbox.register-section("Introduction")
#newSlide(title: [Introduction])[

  - Just some text with a #link("https://github.com/yohhaan/typst-polylux-slides")[link]
  - A custom cite [1]
  - and the image below appearing later, see polylux guide for more on animations

  #context [
    #show: later
    #image("themes/uw-theme/uw-crest.svg")
  ]

  #set align(bottom)
  #citeBlock(color: gray)[
    #set text(size: 10pt)
    [1] Paper Title - Author et al. - #link("https://doi.org/")[Venue], YYYY
  ]

  #toolbox.pdfpc.speaker-note("Speaker notes go here")
]

#toolbox.register-section("Columns Demo")
#newSlide(title: [Columns Demo])[
  #toolbox.side-by-side(columns: (1.5fr, 1fr))[
    #align(center)[=== Column 1]
    #alertBlock(title: [Alert Block demo])[
      Description block demo
    ]
    #exampleBlock(title: [Example Block demo])[
      Description block demo
    ]
  ][
    #align(center)[=== Column 2]
    #infoBlock(title: [Info Block demo])[
      Description block demo
    ]
    #colorBlock(title: [Any Color Block demo], color: purple)[
      Description block demo
    ]
  ]

  #toolbox.pdfpc.speaker-note(
    ```md
    # My notes
    Did you know that pdfpc supports Markdown notes? _So cool!_
    ```,
  )
]

#blackSlide(title: [Result or finding])[
]

#toolbox.register-section("Conclusion")
#newSlide(title: [Conclusion])[
  #toolbox.pdfpc.end-slide

  #align(center + horizon)[
    #toolbox.side-by-side[
      //custom fig
      #fig(
        image("themes/uw-theme/cdis.svg"),
        [CDIS logo],
      )
    ][
      #fig(
        table(
          columns: (auto, auto),
          align: horizon,
          table.header([*Stat*], [*Value*]),
          [stat 1], [entry 1],
          [stat 2], [entry 2],
        ),
        [Table caption],
      )
    ]
  ]
  In bottom right footer, is a (clickable) outline overview of where we are at in the presentation.
]

// This tells the template to not consider following slides in total number of slides
#metadata("Additional unnumbered slides") <unnumbered>

//Additional slides can be commented out if none
#sectionSlide(title: [Additional Slides])[
]

#newSlide(title: [Backup 1])[
  Observe how page numbering increases but not total, thanks to the following placed before additional slides:
  #raw("#metadata(\"Additional unnumbered slides\") <unnumbered>", lang: "typst", block: false)
]

#newSlide(title: [Backup 2])[
  #lorem(100)
]

