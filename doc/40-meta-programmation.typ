#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Méta-programmation en #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Comptime vs. Runtime]

    #sub-title[Code exécuté à la compilation]

    Système de type strict et duck typing avec ```zig anytype```

    #v(0.5em)
    #sub-title[Code exécuté au runtime]

    Système de type strict uniquement
]

#default-slide[
    #title[Type comme valeur]

    #sub-title[Citoyen de 1ère classe à la compilation]
    #sub-title[Évaluation à la compilation via *`comptime`*]
    #sub-title[Fonction génératrice de type]
]

#default-slide[
    #title[Type comme valeur]

    #v(0.5em)
    ```zig
    const Nat : type = union(enum) {
        Zero, Succ: *const Nat,

        fn toInt(self: @This()) u32 {
            return switch(self) {
                .Zero => 0,
                .Succ => |p| 1 + p.toInt(), // ≣ 1 + p.*.toInt()
            };
        }
    }
    ```
]

#default-slide[
    #title[Quantification universel $∀ x. T$]

    #sub-title[Pas de quantification universel au runtime]
    #sub-title[Évaluation à la compilation via *`comptime`*]
    #sub-title[Fonction génératrice de type]
]

#default-slide[
    #title[Type générique]

    #sub-title[Type générique évalué à la compilation]

    ```zig
    fn Maybe(comptime T: type) type {
        return union(enum) {
            None,
            Some: T,

            fn pure(t:T) @This() {
                return .{ .Some = t };
            }
        };
    }
    ```
]

#default-slide[
    #title[Génération de types]

    #v(0.5em)
    Pure : $∀M:*→*.∀A:*.A → M(A)$
    ```zig
    fn Pure(comptime M: fn (type) type, comptime A: type) type {
        return fn (A) M(A);
    }
    ```
    #v(0.5em)
    Optional : $∀A:*.A → ?A$
    ```zig
    fn Optional(comptime A: type) type { return ?A; }
    ```
]

#default-slide[
    #title[Déclaration de types]

    #v(0.5em)
    Add_u32 = u32 → u32 → u32
    ```zig
    const Add_u32 = fn(u32) fn(u32) u32;
    ```

    #v(0.5em)
    Pure = $∀M:*→*.∀A:*.A → M(A)$
    ```zig
    const Pure = fn(M:fn(type) type) fn(A:type) fn(A) M(A);
    ```

    #v(0.5em)
    #compiler-message[
    ```zig
    error: use of undeclared identifier 'A'
    const Pure: type = fn(M:fn(type) type) fn(A:type) fn(A) M(A);
                                                         ^
    ```
    ]

]

#default-slide[
    #title[Déclaration de types dérivée]

    #v(0.5em)
    Pure = $∀M:*→*.∀A:*.A → M(A)$
    ```zig
    fn Pure(M: fn(type) type) type {
        const inner = struct {
            fn run(A: type) fn(A) M(A) {
                unreachable;
            }
        }.run;

        return @TypeOf(inner);
    }
    ```
]

#default-slide[
    #title[Quantification existentiel ?]

    #set align(center)

    = $∃x.T(x) = ∀y. (∀x.T(x) → y) → y$
]

#default-slide[
    #title[$∃x.T(x) = ∀y. (∀x.T(x) → y) → y$]

    #v(0.5em)
    #reveal-code(lines: (0, 1, 3))[```zig
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
    #title[$∃x.T(x) = ∀y. (∀x. T(x) → y) → y$]

    #sub-title[Passage à la pratique]

    #v(0.5em)
    ```zig
    fn Opt(comptime X:type) type { return ?X; }
    fn run(comptime X:type, value: Opt(X)) void { ... }

    fn main() void {
        const existential = Exists(Opt).pack(i32, null);
        existential.unpack(void, run);
    }
    ```

    === Applicable uniquement à la compilation !
]
