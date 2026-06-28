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
    #title[#box(image(zig-logo-dark, height: 1em), baseline: 16%)]

    #uncover("2-")[Langage de programmation système, moderne et robuste
        qui propose de la méta-programmation via l'exécution de code à la compilation !]

    #uncover("3-")[=== Langage sans flux de contrôle caché]
    #uncover("4-")[=== Langage sans allocations mémoire cachées]
    #uncover("5-")[=== Langage sans préprocesseur, ni macros]

]

