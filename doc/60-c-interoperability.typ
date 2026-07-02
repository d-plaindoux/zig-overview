#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = #box(image(zig-logo-light, height: 1em), baseline: 17%) et C
]

#default-slide[
    #title[Utiliser des librairies C]

    #sub-title[Importation Intuitive]

    #reveal-code(lines: (0, 3))[```zig
        const ncurses = @cImport({
            @cInclude("ncurses.h");
        });

        pub fn main() !void {
            _ = ncurses.initscr();
            defer _ = ncurses.endwin();
            ...
        }
        ```]
]

#default-slide[
    #title[Mise à disposition à C]

    #sub-title[Exportation avec les types C dans Zig]

    ```zig
    extern fn min(a: c_int, b: c_int) callconv(.C) c_int {
        return if (a < b) a else b;
    }
    ```

    #uncover(2)[#sub-title[Declaration externe en C (classique)]
    ```c
    extern int min(int a, int b);
    ```]
]
