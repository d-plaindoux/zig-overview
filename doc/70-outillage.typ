#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Outillage #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Production de binaires]

    #uncover("2-")[== Une seule commande sans dépendance]

    #uncover("3-")[== Embarque les compilateurs C et C++]

    #uncover("4-")[== Traduction C vers Zig gratuite]

    #uncover("5-")[== Cross-Compilation native (incluant WASM)]

    #uncover("6-")[== Réécriture du Linker (ni de `ld` ni de `lld`)]

    #uncover("6-")[== Réécriture et enrobage de la Libc]

]

#default-slide[
    #title[Le Système de Build]

    #uncover("2-")[== Tout en Zig via un fichier `build.zig`]

    #uncover("3-")[== Gestionnaire de paquets via `build.zig.zon`]

    #uncover("4-")[== API riche
        === #h(1cm) - Générer du code
        === #h(1cm) - Exécuter des tests
    ]
]
