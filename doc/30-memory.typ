#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Gestion de la mémoire dans #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Pile ou Tas ?]


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
    #title[Allocation dans #alternatives(repeat-last: true)[le Tas][un Tas]]

    #v(0.5em)
    #reveal-code(lines: (0, 0, 1, 5, 7, 8))[```zig
        const std = @import("std");

        pub fn main() !void {
            var gpa = std.heap.DebugAllocator(.{}){};
            deref _ = gpa.deinit();
            const allocator = gpa.allocator();

            const list = try allocator.alloc(u8, 10);
            defer allocator.free(list);
            ...
        }
        ```]
]

#default-slide[
    #title["Use-After-Free"]

    #v(0.5em)
    #reveal-code(lines: (0, 5, 6, 8, 9, 11))[```zig
    const std = @import("std");

    test "Use after free" {
        var heap = std.heap.DebugAllocator(.{}){};
        defer _ = heap.deinit();
        const allocator = heap.allocator();

        const score_ptr = try allocator.create(u32);
        allocator.destroy(score_ptr);

        score_ptr.* = 999; // Use-After-Free here
    }
    ```]
]

#default-slide[
    #title["Use-After-Free" ]

    #v(0.5em)

    #uncover("2-")[=== Execution avec le `DebugAllocator` :
    ```sh
    Segmentation fault at address 0x109a20000
    use-afer-free.zig:13:5: 0x1010c10c1 in main (use-afer-free)
        score_ptr.* = 999;
        ^
    ```]

    #uncover("3-")[=== Solutions idiomatiques :
    - utilisation du `deref` ou
    - mettre le pointeur à `null` (et donc changer le type).
    ]
]

#default-slide[
    #title["Stack Buffer Overflow"]

    #v(0.5em)
    ```c
    #include <string.h>

    void foo(char* bar) {
        char c[12];
        strcpy(c, bar); // pas de vérification
    }
    ```
    #v(0.5em)

    === Ecriture à une adresse mémoire de la pile d'appel située en dehors de la structure de données prévue
]

#default-slide[
    #title["Stack Buffer Overflow"]

    #v(0.5em)
    ```zig
    const std = @import("std");

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

    #v(0.5em)
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
    const std = @import("std");

    fn foo(input: *const [8] u8) void {
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
    ```zig
    const std = @import("std");

    pub fn main() !void {
        var gpa = std.heap.DebugAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var number = try allocator.create(i32);
        allocator.destroy(number);

        allocator.destroy(number);
    }
    ```
]
