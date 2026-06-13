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
