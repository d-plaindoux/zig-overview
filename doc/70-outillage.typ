#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Outillage #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Production de binaires]

    == Une seule commande sans dépendance

    == Remplacement de C/C++

    == Traduction C vers Zig

    == Cross-Compilation native (inclus WASM)

    == Linker Réécrit de zéro (pas de `ld` ou `lld`)

]

#default-slide[
    #title[Le Système de Build]

    == Tout en Zig via un fichier `build.zig`

    == Gestionnaire de paquets via `build.zig.zon`

    == API riche

    === #h(1cm) - Générer du code
    === #h(1cm) - Exécuter des tests
]
