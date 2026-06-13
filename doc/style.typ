#import "@preview/polylux:0.4.0": *

#let zig-logo-dark = "assets/zig-logo-dark.svg"
#let zig-logo-light = "assets/zig-logo-light.svg"

#let title(body) = {
    text(size: 28pt, fill: orange.darken(20%), font: "Rockwell")[= #body]
}

#let small-text(body) = {
    text(size: 18pt, font: "Rockwell")[#body]
}


#let compiler-message(body) = {
    text(size: 22pt, fill: orange, font: "Rockwell")[#body]
}

#let title-slide(body) = {
    set page(
        paper: "presentation-16-9",
        margin: (
            top: 2cm,
            bottom: 2cm,
            left: 2cm,
            right: 2cm,
        ),
        fill: blue.lighten(90%),
        footer: align(
            right,
            toolbox.full-width-block(
                inset: (
                    top: 0pt,
                    bottom: 0pt,
                    left: 0pt,
                    right: -3.9cm,
                ),
            )[ #image("assets/sunny-tech.svg", width: 5%) ],
        ),
    )
    set text(size: 25pt, fill: black, font: "Rockwell")

    slide[#body]
}

#let default-slide(body) = {
    set page(
        paper: "presentation-16-9",
        margin: (
            top: 1cm,
            bottom: 2cm,
            left: 2cm,
            right: 2cm,
        ),
        fill: blue.lighten(90%),
        footer: align(
            right,
            toolbox.full-width-block(
                inset: (
                    top: 0pt,
                    bottom: 0pt,
                    left: 0pt,
                    right: -4cm,
                ),
            )[ #image("assets/sunny-tech.svg", width: 5%) ],
        ),
    )
    set text(size: 25pt, fill: black, font: "Rockwell")

    slide[
        #body
    ]
}

#let chapter-slide(body) = {
    set page(
        paper: "presentation-16-9",
        fill: orange.darken(50%),
        margin: (
            top: 5cm,
            bottom: 5cm,
            left: 2cm,
            right: 0cm,
        ),
        footer: align(
            right,
            toolbox.full-width-block(
                inset: (
                    top: 0pt,
                    bottom: 0pt,
                    left: 0pt,
                    right: -1.5cm,
                ),
            )[ #image("assets/zero.svg", width: 10%) ],
        ),
    )
    set text(size: 25pt, fill: white, font: "Rockwell")

    slide[
        #set align(horizon)
        #body
    ]
}
