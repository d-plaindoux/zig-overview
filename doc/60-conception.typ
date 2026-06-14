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

    == Function call or Static Dispatch?

    #v(0.5em)
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

    == Types sommes et Filtrage de motif

    #v(0.5em)
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
    #title[Programmation Orientée Objet]

    == Encodage à l'aide de table virtuelle

    #v(0.5em)
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
    #title[Programmation Orientée Objet]

    == Encodage à l'aide de table virtuelle

    #v(0.5em)
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

    === Definition de la signature de module ```zig Stack```

    #v(0.5em)
    ```zig
    fn Stack(comptime T:fn (type) type, comptime A:type) type {
        return struct {
            create: *const fn () T(A),
            push: *const fn (Allocator, A, T(A)) anyerror!T(A),
            peek: *const fn (T(A)) ?A,
            pop: *const fn (Allocator, T(A)) Pair(?A, T(A)),
        };
    }
    ```
]

#default-slide[
    #title[Programmation par Modules]

    === Mise en oeuvre du module ```zig Stack``` avec les ```zig List```

    #v(0.5em)
    ```zig
    fn StackList(comptime A: type) Stack(List, A) {
        return .{
            .create = struct {
                fn fun() List(A) {
                    return .nil();
                }
            }.fun,
            ...
        };
    }
    ```
]

#default-slide[
    #title[Programmation par Modules]

    === Mise en pratique

    #v(0.5em)
    #reveal-code(lines: (0, 3, 7, 9))[```zig
    var heap = std.heap.DebugAllocator(.{}){};
    defer _ = heap.deinit();
    const allocator = heap.allocator();

    const S = StackList(u32);
    const stack = try S.push(allocator, 1, S.create());
    defer S.deinit(allocator, stack);

    try std.testing.expectEqual(1, S.peek(stack));
    ```]
]

#default-slide[
    #title[Programmation Fonctionnelle]

    #v(0.5em)
    === - Pas de fonction anonyme

    === - Pas de "closure"

    === - Données de type fonctionnel

    #v(0.5em)
    ```zig
      const incr : *const fn(u32) u32 = struct {
          fn fun(a:u32) u32 {
              return a + 1;
          }
      }.fun;
    ```



]

