#import "@preview/polylux:0.4.0": *

#let zig-logo-dark = "assets/zig-logo-dark.svg"
#let zig-logo-light = "assets/zig-logo-light.svg"

#let slideNumber = state("slideNumber", 0)
#let slideNumberMax = 60

#let title(body) = {
    text(size: 28pt, fill: orange.darken(20%), font: "Rockwell")[
        = #body
    ]
}

#let sub-title(body) = {
    [
        == #body
        #v(0.5em)
    ]
}

#let small-text(body) = {
    text(size: 18pt, font: "Rockwell")[#body]
}

#let compiler-message(body) = {
    text(size: 22pt, fill: orange.darken(20%), font: "Rockwell")[#body]
}

#let title-slide(body) = {
    set page(
        paper: "presentation-16-9",
        margin: (
            top: 2cm,
            left: 2cm,
        ),
        fill: blue.lighten(75%),
    )
    set text(size: 25pt, fill: black, font: "Rockwell")

    slide[
        #body

        #place(
            bottom + right,
            dx: 2cm,
            dy: 2cm,
            image("assets/sunny-tech.svg", width: 15%),
        )
    ]
}

#let default-slide(body) = context {
    set page(
        paper: "presentation-16-9",
        margin: (
            top: 1cm,
            left: 2cm,
        ),
        fill: blue.lighten(75%),
    )
    set text(size: 25pt, fill: black, font: "Rockwell")
    slideNumber.update(x => x + 1)
    let percent = (100 * slideNumber.get()) / slideNumberMax

    slide[
        #place(
            top + left,
            dx: -2cm,
            dy: -2cm,
            stack(
                dir: ltr,
                rect(fill: orange.darken(20%), height: 1.2em, width: percent * 1%),
            )
        )

        #body

        #place(
            bottom + right,
            dx: 2cm,
            dy: 2cm,
            image("assets/sunny-tech.svg", width: 10%),
        )
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
    set text(size: 28pt, fill: white, font: "Rockwell")

    slide[
        #set align(horizon)
        #body
    ]
}
