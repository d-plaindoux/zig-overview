#import "@preview/polylux:0.4.0": *
#import "style.typ": *
#import emoji : *

#chapter-slide[
    = Survol du langage #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Types natifs]

    #uncover("2-")[== Nombres (entier et flottant)

    i8, u8, i16, u16, i32, u32, i64, u64, isize, usize

    f16, f32, f64, f80, f128
    ]
    #uncover("3-")[== Compatibilité ABI avec C

    c_char, c_short, c_ushort, c_int, c_uint, c_long etc.
    ]
    #uncover("4-")[== Autres ...

    bool, void, anyopaque, noreturn, type, anyerror ...
    ]
]

#default-slide[
    #title[Fonction]

    #v(0.5em)
    ```zig
    fn nom(p1: t1, ..., p1: tn) r {
        ...
    }
    ```
    #v(0.5em)

    == Les paramètres sont passés par valeur:
    #uncover("2-")[=== - les primitives sont copiées et]
    #uncover(3)[=== - pour les données complexes c'est variable]

]

#default-slide[
    #title[Erreur]


]

#default-slide[
    #title[Optional]


]

#default-slide[
    #title[Tableaux]

    ```zig
    const hello : [5]u8 = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    ```

]

#default-slide[
    #title[Contrôle]

    == If conditional selection

    ```zig
    if (condition) true_branch [else false_branch]
    ```
]

#default-slide[
    #title[Contrôle]

    == For loop

    #v(0.5em)
    ```zig
    const items = [_]i32{ 4, 5, 3, 4, 0 };

    for(items) |item| { ... }

    for(items) |item, index| { ... }

    for(items,items) |item1, item2| { ... }

    for(items) |item| { ... } else { ... }
    ```
]

#default-slide[
    #title[Contrôle]

    == While loop

    #v(0.5em)
    ```zig
    var i : usize = 0;

    while(i < 10) { ... }

    while (i < 10) : (i += 1) {}

    while (eventuallyNullSequence()) |value| { ... }


    ```
]
#default-slide[
    #title[Tout est expression]

]

#default-slide[
    #title[Enumération]
]

#default-slide[
    #title[Structure]

    == Type produit hérité du langage C

    #v(0.5em)
    #reveal-code(lines: (0, 4, 8))[```zig
    const Point = struct {
        x: i32,
        y: i32,
    };

    fn init(x: i32, y: i32) Point {
        return Point { .x = x, .y = y};
    }
    ```]
]

#default-slide[
    #title[Structure]

    == Type produit hérité du langage C

    #v(0.5em)
    ```zig
    const Point = struct {
        x: i32,
        y: i32,
    };

    fn init(x: i32, y: i32) Point {
        return .{ .x = x, .y = y};
    }
    ```
]

#default-slide[
    #title[Structure]

    == Colocaliser représentation et comportements

    #v(0.5em)
    ```zig
    const Point = struct {
        x: i32,
        y: i32,

        fn init(x: i32, y: i32) Point {
            return .{ .x = x, .y = y};
        }
    };
    ```
]

#default-slide[
    #title[Structure]

    == Typage et référence au type courant

    #v(0.5em)
    ```zig
    const Point = struct {
        x: i32,
        y: i32,

        fn init(x: i32, y: i32) @This() {
            return .{ .x = x, .y = y};
        }
    };
    ```
]

#default-slide[
    #title[Structure]

    #uncover("2-")[== Tout fichier source est une Structure]

    #v(0.5em)
    #reveal-code(lines: (0, 0, 1, 4, 8))[```zig
    x: i32,
    y: i32,

    fn init(x: i32, y: i32) @This() {
        return .{ .x = x, .y = y};
    }
    ```]

]

#default-slide[
    #title[Union]

    == Type somme hérité du langage C

    #v(0.5em)
    ```zig
    const Number = union {
        integer: i64,
        float: f64,
    };
    ```
    #v(0.5em)

    Soit un ```zig integer``` soit un ```zig float```
]

#default-slide[
    #title[Union]

    == Accès sécurisé à la compilation

    #v(0.5em)
    ```zig
    const Number = union { integer: i64, float: f64, };

    test "Qui ne compile pas :)" {
        const n = NumberSimple{ .integer = 42 };
        try std.testing.expectEqual(42, n.float);
    }
    ```
    #v(0.5em)

    #compiler-message[error: access of union field 'float' while field 'integer' is active]

]

#default-slide[
    #title[Union]

    == Accès sécurisé à l'exécution

    #v(0.5em)
    ```zig
    const Number = union { integer: i64, float: f64, };

    fn integer(n: Number) i64 {
        return n.integer;
    }
    ```
    #v(2em)

    #compiler-message[panic: access of union field 'integer' while field 'float' is active]
]


#default-slide[
    #title[Union Étiquetée]

    #uncover("2-")[== Inspirée des langages fonctionnels]

    #uncover("3-")[=== - Etiquetage Implicite]
    #uncover("4-")[=== - Etiquetage Explicite]
    #uncover("5-")[=== - Introduction du Filtrage de Motif]
]

#default-slide[
    #title[Union]

    == Étiquetage implicite

    #v(0.5em)
    ```zig
    const Number = union(enum) { integer: i64, float: f64, };

    fn zeroInteger() Number {
       return .{ .integer = 0 };
    }

    fn zeroFloat() Number {
       return .{ .float = 0 };
    }
    ```
]

#default-slide[
    #title[Union]

    == Étiquetage explicite

    #v(0.5em)
    ```zig
    const Label = enum { entier, flottant };

    const Number = union(Label) { entier: i64, flottant: f64, };

    fn zero(label: Label) Number {
        return if (label == .entier) .{ .entier = 0 }
               else .{ .flottant = 0 };
    }
    ```
]

#default-slide[
    #title[Union]

    == Introduction du Filtrage de Motif

    #v(0.5em)
    ```zig
    const Number = union(enum) { entier: i64, flottant: f64, };

    fn increment(number: Number) Number {
        return switch (number) {
            .entier => |n| .{ .entier = n + 1 },
            .flottant => |f| .{ .flottant = f + 1 },
        };
    }
    ```
]

#default-slide[
    #title[Union]

    == Colocaliser représentation et comportements

    #v(0.5em)
    ```zig
    const Number = union(enum) {
        entier: i64,
        flottant: f64,

        fn increment(number: Number) Number {
            return ...
        }
    };
    ```
]

#default-slide[
    #title[Union]

    == Typage et référence au type courant

    #v(0.5em)
    ```zig
    const Number = union(enum) {
        entier: i64,
        flottant: f64,

        fn increment(self:  @This) @This {
            return ...
        }
    };
    ```
]

#default-slide[
    #title[Union]

    == Cas des types récursifs

    #v(0.5em)
    ```zig
    const Naturel = union(enum) {
        Zero,
        Succ: Naturel,
    };
    ```
    #v(0.5em)

    #compiler-message[
    ```
    error: type 'Naturel' depends on itself for field declared here
        Succ: Naturel,
              ^~~~~~~
    ```
    ]
    #v(0.5em)

    Il faut passer par les pointeurs ... comme en Rust !
]

#default-slide[
    #show link: underline
    #title[Pointeur #uncover("3-")[et opération implicite]]

    #v(0.5em)
    ```zig
    fn zero() u32 {
        return 0;
    }

    ```
    #only(2)[```zig
        export fn main() void {
            _ = (&zero).*();

        }
        ```]
    #only("3")[```zig
        export fn main() void {
            _ = (&zero).*();
            //         ^^ peut être omis (parfois)
        }
        ```]
    #only("4")[```zig
        export fn main() void {
            _ = (&zero)();

        }
        ```]
    #v(0.5em)

    #uncover(4)[
        #link("https://zig.godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:zig,selection:(endColumn:6,endLineNumber:9,positionColumn:6,positionLineNumber:9,selectionStartColumn:6,selectionStartLineNumber:9,startColumn:6,startLineNumber:9),source:'++++fn+zero()+u32+%7B%0A++++++++return+0%3B%0A++++%7D%0A%0A++++export+fn+main()+void+%7B%0A++++++++_+%3D+(%26zero).*()%3B%0A++++++++_+%3D+(%26zero)()%3B%0A++++++++return%3B%0A++++%7D'),l:'5',n:'0',o:'Zig+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:compiler,i:(compiler:ztrunk,filters:(b:'0',binary: '1',binaryObject:'1',commentOnly: '0',debugCalls:'1',demangle:'0',directives:'0',execute:'1',intel:'0',libraryCode:'0',trim:'1',verboseDemangling:'0'),flagsViewOpen:'1',fontScale:14,fontUsePx:'0',j:1,lang:zig,libs:!(),options:'',overrides:!(),selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:1),l:'5',n:'0',o:'+zig+trunk+(Editor+%231)',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")[
            Que donne le code assembleur ?
        ]
    ]
]
