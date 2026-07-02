#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Méta-programmation en #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Comptime vs. Runtime]

    #uncover("2-")[
        #sub-title[Code exécuté à la compilation]

        Système de type strict, duck typing avec ```zig anytype```
    ]

    #uncover("3")[
        #v(0.5em)
        #sub-title[Code exécuté au runtime]

        Système de type strict uniquement
    ]
]

#default-slide[
    #title[Type comme Valeur]

    #uncover("2-")[#sub-title[Citoyen de 1ère classe à la compilation]]
    #uncover("3-")[#sub-title[Évaluation à la compilation via *`comptime`*]]
    #uncover("4-")[#sub-title[Fonction génératrice de type]]
]

#default-slide[
    #title[Type comme valeur]

    #v(0.5em)
    ```zig
    const Nat: type = union(enum) {
        Zero, Succ: *const @This(),

        fn toInt(self: *const @This()) u32 {
            return switch(self) {
                .Zero => 0,
                .Succ => |p| 1 + p.toInt(),
            };
        }
    }
    ```
]
#default-slide[
    #title[Type comme valeur]

    #sub-title[Type évalué à la compilation]

    #v(0.5em)
    #reveal-code(lines:(0,1,6))[```zig
    fn Integer(comptime unsigned: bool) type {
        if (b) {
            return u64;
        } else {
            return f64;
        }
    }
    ```]
]

#default-slide[
    #title[Type paramètrique ou Universel]

    #sub-title[Type évalué à la compilation]

    #v(0.5em)
    #reveal-code(lines:(0,1,3))[```zig
    fn Optionel(comptime T: type) type {
        return union(enum) {
            None, Some: T,

            fn pure(t:T) @This() {
                return .{ .Some = t };
            }
        };
    }
    ```]
]

#default-slide[
    #title[Déclaration et Génération de types]

    #v(0.5em)
    AddU32 = (u32, u32) → u32
    ```zig
    const AddU32: type = fn(u32, u32) u32;
    ```
    #v(0.5em)
    Optional : $∀A:*.A → ?A$
    ```zig
    const Optionel: type = fn(comptime A: type) ?A;
    ```
    #v(0.5em)
    #uncover("2-")[#compiler-message[
    ```zig
    error: use of undeclared identifier 'A'
    const Optionel: type = fn(comptime A: type) ?A
                                                 ^
    ```
    ]]
    #uncover(3)[
    ```zig
    fn Optionel(comptime A: type) type { return ?A; }
    ```]
]

#default-slide[
    #title[Type abstrait ou Existential]

    #uncover("2-")[
        #sub-title[Encodage via une continuation et des ∀]
    ]

    #uncover(3)[
    #set align(center)
    = $∃x.T(x) ≝ ∀y. (∀x.T(x) → y) → y$
    ]
]

#default-slide[
    #title[$∃x.T(x) ≝ ∀y. (∀x.T(x) → y) → y$]

    #v(0.5em)
    #reveal-code(lines: (0, 1, 3, 9))[```zig
        pub fn Exists(T:fn (type) type) type {
            return struct {
                pub fn pack(X:type, value:T(X)) type {
                    return struct {
                        // anytype at comptime capture ∀x.T(x) → y
                        pub fn unpack(Y:type, cont:anytype) Y {
                            return cont(X, value);
                        }
                    };
                }
            };
        }
        ```]
]


#default-slide[
    #title[$∃x.T(x)  ≝ ∀y. (∀x. T(x) → y) → y$]

    #sub-title[Passage à la pratique]

    #v(0.5em)
    #reveal-code(lines: (0, 1, 2, 5, 6))[```zig
    fn Optionel(comptime X:type) type { return ?X; }
    fn run(comptime X:type, value: Optionel(X)) void { ... }

    fn main() void {
        const existential = Exists(Optionel).pack(i32, null);
        existential.unpack(void, run);
    }
    ```]

    #uncover(7)[=== Applicable uniquement à la compilation !]
]
