#import "@preview/polylux:0.4.0": *
#import "style.typ": *


#default-slide[
    #show link: underline

    #title[#box(
            clip: true,
            radius: 1cm,
            width: 2cm,
            height: 2cm,
            image("assets/MySelf.png", height: 2cm),
            baseline: 25%,
        )
        C'est qui ce gonze ?
    ]

    === Système Distribué et modèle Acteur (#link("https://www.kaptngo.com")[Akawan Kaptngo])

    #v(0.5em)

    === Système Expert en Prolog (#link("https://app.credifix.com")[Crédifix])

    #v(0.5em)

    === Fonctions et Calcul des Ambiants (#link("https://github.com/ephel-lang/ephel")[Ephel])

    #v(0.5em)

    === Libraries OCaml avec des amis (#link("https://github.com/cargocut")[CargoCut])
]


#default-slide[
    #show link: underline
    #set align(horizon)

    #title[Colophon]

    == Présentation élaborée avec l'aide de #link("https://typst.app")[Typst]
]

#title-slide[
    #set align(horizon)
    #text(40pt)[= C’est qui ce #box(image(zig-logo-dark, height:1.2em), baseline: 18%) ?]

    #set align(center)
    #box([
        #image("assets/git-repo.png", height: 8em)
        ==== Dépôt
    ])
    #h(3em)
    #box([
        #image("assets/feedback.png", height: 8em)
        ==== Feedback
    ])
]
