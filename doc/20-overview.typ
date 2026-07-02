#import "@preview/polylux:0.4.0": *
#import "style.typ": *
#import emoji: *

#chapter-slide[
    = Survol du langage #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Types natifs]

    #uncover("2-")[== Nombres (entier et flottant)

        i8, u8, i16, u16, i32, u32, i64, u64, i128, u128, isize, usize

        f16, f32, f64, f80, f128
    ]
    #uncover("3-")[== Compatibilité ABI avec C

        c_char, c_short, c_ushort, c_int, c_uint, c_long etc.
    ]
    #uncover("4-")[== Autres ...

        bool, void, anyopaque, noreturn, type, anytype, anyerror
    ]
]

#default-slide[
    #title[Tableaux]

    #uncover("2-")[=== Tableau statique
    ```zig
    const hello: [5]u8 = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    ```]
    #uncover("3-")[=== "Slice" (pointeur  + taille)
    ```zig
    const he: []const u8 = hello[0..2];
    ```]
    #uncover("4-")[=== Tableau dynamique avec ```zig std.ArrayList```]

    #uncover("5-")[=== Vecteur (support SIMD)
    ```zig
    const v1: @Vector(4, i32) = .{ 1, 2, 3, 4 };
    ```]

]

#default-slide[
    #title[Contrôle]

    #v(0.5em)

    #reveal-code(lines:(0, 1, 3, 5 ,7 ,9, 11))[```zig
    if (condition) true_branch [else false_branch]

    for(items) |item| { ... }

    for(items) |item, index| { ... }

    for(items1,items2) |item1, item2| { ... }

    while(i < 10) { ... }

    while (i < 10) : (i += 1) { ... }
    ```]
]

#default-slide[
    #title[Fonction]

    #v(0.5em)
    ```zig
    fn nom(p1: t1, ..., p1: tn) r {
        ...
    }
    ```

    #uncover("2-")[== Type des paramètres et résultat obligatoire]
    #uncover("3-")[== Les paramètres sont passés par valeur]
    #uncover("4-")[=== #h(1cm) - les valeurs primitives sont copiées et ]
    #uncover(5)[=== #h(1cm) - pour les données composites cela dépend]
]

#default-slide[
    #title[Optionel ```zig ?T```]

    #sub-title[Soit la valeur ```zig null``` soit une valeur de type ```zig T```]

    #reveal-code(lines:(0, 1, 3, 4, 5, 7))[```zig
    const a : ?u32 = ...;

    const value1 = a orelse ...;
    const value2 = a orelse unreacheable; // panique si [null]
    const value3 = a.?; // équivalent à [a orelse unreacheable]

    if (a) |value| { ... } else { ...  }
    ```]
]

#default-slide[
    #title[Enumération]

    #sub-title[Ensemble restreint de valeurs nommées]

    ```zig
    const Couleur = enum { rouge, noir };
    const Enseigne = enum { pique, trefle, carreau, coeur };
    ```
]

#default-slide[
    #title[Enumération]

    #sub-title[Traitement par filtrage exhaustif]

    ```zig
    const Couleur = enum { rouge, noir };
    const Enseigne = enum { pique, trefle, carreau, coeur };

    fn couleur(e: Enseigne) Couleur {
        return switch (e) {
            .pique, .trefle => .noir,
            .carreau, .coeur => .rouge,
        };
    }
    ```
]

#default-slide[
    #title[Enumération]

    #sub-title[Colocaliser représentation et comportements]

    ```zig
    const Couleur = enum { rouge, noir };
    const Enseigne = enum {
        pique, trefle, carreau, coeur,

        fn couleur(e: Enseigne) Couleur {
            ...
        }
    };
    // Enseigne.couleur(.pique) ou Enseigne.pique.couleur()
    ```
]

#default-slide[
    #title[Enumération]

    #sub-title[Typage et référence au type courant]

    ```zig
    const Couleur = enum { rouge, noir };
    const Enseigne = enum {
        pique, trefle, carreau, coeur,

        fn couleur(e: @This()) Couleur {
            ...
        }
    };
    // Enseigne.couleur(.pique) ou Enseigne.pique.couleur()
    ```

]

#default-slide[
    #title[Erreur]

    #sub-title[Enumérations spécifiques dédiées aux erreurs]

    #reveal-code(lines:(0,1,3))[```zig
    const A = error{ NotDir, PathNotFound };

    const B = error{ OutOfMemory, PathNotFound };

    const C = A || B;
    // C = error{ OutOfMemory, NotDir, PathNotFound }
    ```]

    #uncover(5)[== Pas de notion d'exceptions !]
]

#default-slide[
    #title[Fonction & Erreurs]

    #reveal-code(lines:(0,1,3))[```zig
    fn nom(p1: t1, ..., p1: tn) A!r { ... }

    fn nom(p1: t1, ..., p1: tn) error{OutOfMemory}!r { ... }

    fn nom(p1: t1, ..., p1: tn) !r { ... }
    ```]

    #uncover(5)[=== La remontée d'erreur est faite via ```zig return ...```]
]

#default-slide[
    #title[Traitement des erreurs]

    #reveal-code(lines:(0,1,3,5,7))[```zig
    const r1 = operation catch comportement_en_cas_d_erreur;

    const r2 = operation catch |e| comportement_en_cas_d_erreur;

    const r3 = operation catch |e| return e;

    const r3 = try operation; // Sucre syntaxique pour r3
    ```]
]

#default-slide[
    #title[Fonction & Erreur]

    #sub-title[Un exemple complet]

    #reveal-code(lines:(0,1,6))[```zig
    const MathError = error{DivideByZero};

    fn divide(a: f64, b: f64) MathError!f64 {
        if (b == 0) {
            return MathError.DivideByZero;
        }

        return a / b;
    }
    ```]
]


#default-slide[
    #title[Erreur et Diagnostique]

    #sub-title[Type énuméré donc sans valeurs]

    #uncover("2-")[#sub-title[Approches possibles:]]
    #uncover("3-")[=== #h(1cm) - Remplacer ```zig E!R``` par un type algébrique comme ```zig Result```]
    #uncover("4")[=== #h(1cm) - Avoir un paramètre en écriture pour le diagnostique]
]

#default-slide[
    #title[Structure]

    #sub-title[Type produit hérité du langage C]

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

    #sub-title[Type produit hérité du langage C]

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

    #sub-title[Colocaliser représentation et comportements]

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

    #sub-title[Typage et référence au type courant]

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
    #reveal-code(lines: (0, 0, 2, 6))[```zig
    x: i32,
    y: i32,

    fn init(x: i32, y: i32) @This() {
        return .{ .x = x, .y = y};
    }
    ```]
]

#default-slide[
    #title[Structure]

    #sub-title[Tout fichier source est une Structure]

    ```zig
    x: i32,
    y: i32,

    fn init(x: i32, y: i32) @This() {
        return @This(){ .x = x, .y = y};
    }
    ```
]

#default-slide[
    #title[Union]

    #sub-title[Type somme hérité du langage C]

    #v(0.5em)
    #uncover("2-")[
    ```zig
    const Number = union {
        integer: i64,
        float: f64,
    };
    ```]
    #v(0.5em)
    #uncover("3")[
    Soit un ```zig integer``` soit un ```zig float```
    ]
]

#default-slide[
    #title[Union]

    #sub-title[Manipulation sécurisée à la compilation]

    #v(0.5em)
    #reveal-code(lines:(0,1,4,5))[
    ```zig
    const Number = union { integer: i64, float: f64, };

    fn main() void {
        const n = Number{ .integer = 42 };
        if (n.float == 0.0) {
            ...
        }
    }
    ```]

    #uncover(6)[#compiler-message[error: access of union field 'float' while field 'integer' is active]]

]

#default-slide[
    #title[Union]

    #sub-title[Manipulation sécurisée à l'exécution]

    #v(0.5em)
    #reveal-code(lines:(0,1,5))[```zig
    const Number = union { integer: i64, float: f64, };

    fn integer(n: Number) i64 {
        return n.integer;
    }
    ```]
    #v(1.5em)
    #uncover(4)[#compiler-message[panic: access of union field 'integer' while field 'float' is active]]
]


#default-slide[
    #title[Union Étiquetée]

    #uncover("2-")[== Inspirée des langages fonctionnels]
    #uncover("3-")[=== #h(1cm) - Etiquetage Implicite]
    #uncover("4-")[=== #h(1cm) - Etiquetage Explicite]
    #uncover("5-")[=== #h(1cm) - Filtrage de Motif]
]

#default-slide[
    #title[Union]

    #sub-title[Étiquetage implicite]

    #v(0.5em)
    #reveal-code(lines:(0,1,5,9))[```zig
    const Number = union(enum) { integer: i64, float: f64, };

    fn zeroInteger() Number {
       return .{ .integer = 0 };
    }

    fn zeroFloat() Number {
       return .{ .float = 0 };
    }
    ```]
]

#default-slide[
    #title[Union]

    #sub-title[Étiquetage explicite]

    #v(0.5em)
    #reveal-code(lines:(0,1,3,9))[```zig
    const Label = enum { entier, flottant };

    const Number = union(Label) { entier: i64, flottant: f64, };

    fn zero(label: Label) Number {
        return if (label == .entier) .{ .entier = 0 }
               else .{ .flottant = 0 };
    }
    ```]
]

#default-slide[
    #title[Union]

    #sub-title[Cas du Filtrage de Motif]

    #v(0.5em)
    #reveal-code(lines:(1,4,5,6))[```zig
    const Number = union(enum) {
        entier: i64, flottant: f64, };

    fn increment(number: Number) Number {
        return switch (number) {
            .entier => |n| .{ .entier = n + 1 },
            .flottant => |f| .{ .flottant = f + 1 },
        };
    }
    ```]
]

#default-slide[
    #title[Union]

    #sub-title[Colocaliser représentation et comportements]

    #v(0.5em)
    ```zig
    const Number = union(enum) {
        entier: i64, flottant: f64,

        fn increment(number: Number) Number {
            return ...
        }
    };
    ```
]

#default-slide[
    #title[Union]

    #sub-title[Typage et référence au type courant]

    #v(0.5em)
    ```zig
    const Number = union(enum) {
        entier: i64,
        flottant: f64,

        fn increment(self: @This()) @This() {
            return ...
        }
    };
    ```
]

#default-slide[
    #title[Union]

    #sub-title[Cas des types récursifs]

    #v(0.5em)
    #reveal-code(lines:(0,4))[```zig
    const Naturel = union(enum) {
        Zero,
        Succ: Naturel,
    };
    ```]
    #v(0.5em)

    #uncover("3-")[#compiler-message[
        ```
        error: type 'Naturel' depends on itself for field declared here
            Succ: Naturel,
                  ^~~~~~~
        ```
    ]

    #uncover(4)[Il faut passer par les pointeurs !]]
]

#default-slide[
    #show link: underline
    #title[Pointeur]

    #v(0.5em)
    #uncover("2-")[*Définition de type :* ```zig *T``` jamais nul sauf si ```zig T``` est optionnel]

    #uncover("3-")[*Syntaxe :* ```zig &``` pour l'adresse et ```zig .*``` pour déréférencer]

    #uncover("4-")[*Implicite :* ```zig .*``` optionel lors d'accès (fonction ou champ)]

    #uncover("5-")[*Arithmétique indirecte :* par coercion de type]

    #uncover("6-")[```zig
    var x: i32 = 1234;
    const ptr = &x;

    ptr.* = 5678;  // Modification de la valeur
    ptr += 1;      // Erreur de compilation
    ```]
]
