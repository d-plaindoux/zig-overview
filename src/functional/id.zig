const std = @import("std");

//
// Explicit type polymorphism
//
// (A: type) -> A -> A
//

fn idT(comptime A: type) type {
    return fn (A) A;
}

fn idGen(comptime A: type) idT(A) {
    return struct {
        fn inner(a: A) A {
            return a;
        }
    }.inner;
}

test "Should Call idGen with a type" {
    // type in type -> Girard paradox to be studied here
    try std.testing.expectEqual(u32, idGen(type)(u32));
}

test "Should Call idGen with a value" {
    try std.testing.expectEqual(3, idGen(u32)(3));
}

//
// Implicit type polymorphism
//
// 'a -> 'a
//

fn id(a: anytype) @TypeOf(a) {
    return a;
}

test "Should Call id with a type" {
    try std.testing.expectEqual(u32, id(u32));
}

test "Should Call id with a value" {
    try std.testing.expectEqual(1, id(1));
}

const std = @import("std");

// Une fonction qui prend une autre fonction en paramètre via comptime
fn appliquer(a: i32, b: i32, comptime operation: anytype) i32 {
    return operation(a, b);
}

test "anonymous" {
    const le_calcul = fn(x: i32) i32 { return x * 2; };

    // On passe directement la fonction anonyme en argument
    const produit = appliquer(4, 5, fn (x: i32, y: i32) i32 {
        return x * y;
        });

    std.debug.print("Produit : {}\n", .{produit}); // Affiche 20
}