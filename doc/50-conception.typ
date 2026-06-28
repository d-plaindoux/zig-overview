#import "@preview/polylux:0.4.0": *
#import "style.typ": *

#chapter-slide[
    = Conception logiciel et #box(image(zig-logo-light, height: 1em), baseline: 17%)
]

#default-slide[
    #title[Programmation Orientée Donnée]

    #v(0.5em)
    ```zig
    const Point = struct {
        x: i32,
        y: i32,

        fn init(x: i32, y: i32) @This() {
            return .{ .x = x, .y = y};
        }
        fn move(self: @This(), dx: i32, dy: i32) @This() {
            return .{ .x = self.x + dx, .y = self.y + dy};
        }
    };
    ```
]

#default-slide[
    #title[Programmation Orientée Donnée]

    #sub-title[Function call or Static Dispatch?]

    ```zig
    fn main() void {
        const zero = Point.init(0, 0);

        // Classical functional call
        const point1 = Point.move(zero, 42, 42);

        // DOT syntax (syntactic sugar)
        const point2 = zero.move(42, 42);
    }
    ```
]

#default-slide[
    #title[Programmation Orientée Donnée]

    #sub-title[Types sommes et Filtrage de motif]

    ```zig
    const Number = union(enum) {
        entier: i64, flottant: f64,

        fn increment(self: @This()) @This() {
            return switch (number) {
                .entier => |n| .{ .entier = n + 1 },
                .flottant => |f| .{ .flottant = f + 1 },
            };
        }
    };
    ```
]

#default-slide[
    #title[Programmation par Abstraction]

    #sub-title[Encodage à l'aide de table virtuelle]

    ```zig
    const Figure: type = struct {
        v_impl: *anyopaque,
        v_surface: *const fn (self: *anyopaque) f64,

        pub fn surface(self: @This()) f64 {
            return self.v_surface(self.v_impl);
        }

        pub inline fn from(impl: anytype) @This() { ... }
    };
    ```
]

#default-slide[
    #title[Programmation par Abstraction]

    #sub-title[Encodage à l'aide de table virtuelle]

    ```zig
    const Cercle = struct {
        rayon: f64,

        pub fn surface(self: @This()) f64 {
            return std.math.pi * self.rayon * self.rayon;
        }
    };
    ```

    === Instanciation : ```zig Figure.from(&Cercle{ .rayon = 10 })```

]

#default-slide[
    #title[Programmation par Modules]

    #sub-title[Definition de la signature de module ```zig Stack```]

    ```zig
    fn Stack(comptime T:fn (type) type, comptime A:type) type {
        return struct {
            create: fn () callconv(.@"inline") T(A),
            push: fn (Allocator, A, T(A)) anyerror!T(A),
            peek: fn (T(A)) ?A,
            pop: fn (Allocator, T(A)) Pair(?A, T(A)),
        };
    }
    ```
]

#default-slide[
    #title[Programmation par Modules]

    #sub-title[Mise en oeuvre avec les ```zig List```]

    ```zig
    fn StackList(comptime A: type) type {
        return struct {
            inline fn create() List(A) {
                return .nil();
            }
            ...
       };
    }
    ```
]


#default-slide[
    #title[Programmation par Modules]

    #sub-title[Un peu de Duck Typing à la compilation]

    ```zig
    fn implUsing(comptime T: type, comptime I: type) S {
        var result: T = undefined;

        const target_info = @typeInfo(T).@"struct"; // unsafe
        inline for (target_info.fields) |f| {
            @field(result, f.name) = @field(I, f.name);
        }

        return result;
    }
    ```
]

#default-slide[
    #title[Programmation par Modules]

    #sub-title[Mise en pratique]

    #v(0.5em)
    #reveal-code(lines: (0, 3, 7, 9))[```zig
        var heap = std.heap.DebugAllocator(.{}){};
        defer _ = heap.deinit();
        const allocator = heap.allocator();

        const s = implUsing(Stack(List, u32), StackList(u32));
        const stack = try s.push(allocator, 1, S.create());
        defer s.deinit(allocator, stack);

        try std.testing.expectEqual(1, s.peek(stack));
        ```]
]

#default-slide[
    #title[Programmation par Modules]

    #sub-title[Est-ce pertinent ?]

    #v(0.5em)
    ```zig
    ...
    const s = implUsing(Stack(List, u32), StackList(u32));
    // Expose le type interne ^^^^
    ...
    ```

    === Abstraction via type existentiel limitée à comptime !

    === Utiliser les vtable et les types opaques en runtime
]

#default-slide[
    #title[Programmation Fonctionnelle]

    #sub-title[Pas de fonction anonyme]

    #sub-title[Pas de fermeture (closure)]

    #sub-title[Ordre supérieur]

    === #h(1em) - Fonction qui manipule des fonctions
    === #h(1em) - Fonction qui retourne une fonction

]

