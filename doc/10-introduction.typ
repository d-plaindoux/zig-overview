#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#title-slide[
    #set align(horizon)
    #text(40pt)[= C’est qui ce #box(image(zig-logo-dark, height:1.2em), baseline: 18%) ?]

    #v(2em)

    Didier Plaindoux

    #small-text[
        #box(image("assets/mastodon.svg", height: 2em), baseline: 35%) \@dplaindoux\@functional.cafe
    ]
]

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
        C'est qui ce zigue ?
    ]

    #v(0.5em)

    Système Distribué et modèle Acteur
    (#link("https://www.kaptngo.com")[Akawan Kaptngo])

    #v(0.5em)

    Système Expert en Prolog
    (#link("https://app.credifix.com")[Crédifix])

    #v(0.5em)

    Fonctions et Calcul des Ambiants
    (#link("https://github.com/ephel-lang/ephel")[Ephel])

    #v(0.5em)

    Libraries OCaml avec des amis
    (#link("https://github.com/cargocut")[CargoCut])
]

#default-slide[
    #title[#box(image(zig-logo-dark, height: 1em), baseline: 16%)]

    #uncover("2-")[Langage de programmation système, moderne et robuste
        qui propose de la méta-programmation via l'exécution de code à la compilation !]

    #uncover("3-")[=== Langage sans flux de contrôle caché]
    #uncover("4-")[=== Langage sans allocations mémoire cachées]
    #uncover("5-")[=== Langage sans préprocesseur, ni macros]
]
