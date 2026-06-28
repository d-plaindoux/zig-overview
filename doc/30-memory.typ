#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Gestion de la mémoire dans #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Pile ou Tas ?]

    #sub-title[La Pile (Stack)]

    Taille connue et durée de vie liée au bloc de base

    #v(0.5em)
    *Portée :* Destruction dès que l'on sort du bloc de base \
    *Performance :* Allocation efficace mais taille limitée \
    *Contrainte :* La taille doit être connue à la compilation
]

#default-slide[
    #title[Pile ou Tas ?]

    #sub-title[Le Tas (Heap)]

    Taille dynamique ou durée de vie indépendante de la pile

    #v(0.5em)
    *Philosophie Zig :* Pas d'allocateur global caché \
    *Passage d'allocateur :* Allocator comme paramètre \
    *Contrainte :* Libération explicite (cf. fuite mémoire)
]

#default-slide[
    #title[Allocation sur la Pile]

    #v(0.5em)
    #reveal-code(lines: (0, 1, 4, 8))[```zig
        const Point = struct { x: i32, y: i32 };

        pub fn main() void {
            const p1 = Point { .x = 0, .y = 0};
            {
              const p2 = Point { .x = 42, .y = 42};
              ...
            } // -> p2 fin de portée donc libéré
            ...
        }
        ```]
]


#default-slide[
    #title[Allocation sur le Tas]

    #sub-title[Oui mais lequel ?]

    #uncover("2-")[=== #h(1cm) - DebugAllocator]
    #uncover("3-")[=== #h(1cm) - SafeAllocator]
    #uncover("4-")[=== #h(1cm) - ArenaAllocator]
    #uncover("5-")[=== #h(1cm) - PageAllocator]
    #uncover("6-")[=== #h(1cm) ...]
]

#default-slide[
    #title[Allocation]

    #v(0.5em)
    #reveal-code(lines: (0, 1, 6, 8))[```zig
        pub fn main() !void {
            var heap = std.heap.DebugAllocator(.{}){};
            defer _ = heap.deinit();
            const allocator = heap.allocator();
            const array = try allocator.alloc(u8, 10);
            defer allocator.free(array);
            ...
        }
        ```]
]

#default-slide[
    #title[Fuite mémoire]

    #v(0.5em)
    ```zig
    pub fn main() !void {
        var heap = std.heap.DebugAllocator(.{}){};
        defer _ = heap.deinit();
        const allocator = heap.allocator();
        const array = try allocator.alloc(u8, 10);
        ...
    }
    ```

    #compiler-message[
    ```
    error(DebugAllocator): memory address 0x10caa0000 leaked:
        const array = try allocator.alloc(u8, 10);
                                         ^
    ```
    ]
]

#default-slide[
    #title["Use-After-Free"]

    #v(0.5em)
    #reveal-code(lines: (0, 5, 6, 8, 9))[```zig
    test "Use after free" {
        var heap = std.heap.DebugAllocator(.{}){};
        defer _ = heap.deinit();
        const allocator = heap.allocator();

        const score_ptr = try allocator.create(u32);
        allocator.destroy(score_ptr);

        score_ptr.* = 666; // Use-After-Free here
    }
    ```]
]

#default-slide[
    #title["Use-After-Free" ]

    #uncover("2-")[=== Execution avec le `DebugAllocator` :
    ```sh
    Segmentation fault at address 0x109a20000
    use-after-free.zig:13:5: 0x1010c10c1 in main
        score_ptr.* = 666;
        ^
    ```]

    #uncover("3-")[=== Solutions idiomatiques :
    - utilisation du `defer` ou
    - typer avec un optionel et mettre le pointeur à `null`.
    ]
]

#default-slide[
    #title["Stack Buffer Overflow"]

    #sub-title[Ecriture en dehors de la structure prévue]

    #v(0.5em)
    ```zig
    fn foo(input: []const u8) void {
        var buffer: [8]u8 = undefined;
        @memcpy(buffer[0..], input);
    }

    pub fn main() void {
        foo("Plus de 8 caractères!"); // 22 caractères
    }
    ```
]

#default-slide[
    #title["Stack Buffer Overflow"]

    === Execution interrompue :
    ```sh
    thread 1332888 panic: ... arguments have non-equal lengths
    stack-buffer-overflow.zig:5:19: 0x10230955f in foo
    @memcpy(buffer[0..], input);
                  ^
    stack-buffer-overflow.zig:9:8: 0x102309314 in main
    foo("Plus de 8 caractères!");
    ```

    === Détection des débordements (modes de compilation)
    Voir aussi Stack canaries, ASLR et DEP/NX.

]

#default-slide[
    #title["Stack Buffer Overflow"]

    #v(0.5em)
    ```zig
    fn foo(input: *const [8]u8) void {
        var buffer: [8]u8 = undefined;
        @memcpy(buffer[0..], input);
    }

    pub fn main() void {
        foo("Plus de 8 caractères!"); // 22 caractères
    }
    ```

    === expected type '*const [8]u8', found '*const [22:0]u8'
]

#default-slide[
    #title["Double Free"]

    #v(0.5em)
    #reveal-code(lines: (0, 3, 6, 8))[```zig
    var heap = std.heap.DebugAllocator(.{}){};
    defer _ = heap.deinit();
    const allocator = heap.allocator();

    var number = try allocator.create(i32);
    allocator.destroy(number);

    allocator.destroy(number);
    ```]

    #uncover("6-")[=== Solution idiomatique :
    - utilisation du `defer` ou typer avec un optionel.
    ]
]
