//
// Module programming style
//

const std = @import("std");
const List = @import("./data/list.zig").List;
const Pair = @import("./data/pair.zig").Pair;

//
// Specification
//

fn Stack(comptime T: fn (type) type, comptime A: type) type {
    return struct {
        create: *const fn () T(A),
        push: *const fn (std.mem.Allocator, A, T(A)) anyerror!T(A),
        peek: *const fn (T(A)) ?A,
        pop: *const fn (std.mem.Allocator, T(A)) Pair(?A, T(A)),

        fn @"S.peek(S.create()) = null"(S: @This()) !void {
            const stack = S.create();

            try std.testing.expectEqual(null, S.peek(stack));
        }

        fn @"S.peek(S.push(a, S.create())) = a"(
            S: @This(),
            allocator: std.mem.Allocator,
            a: A,
        ) !void {
            const stack = try S.push(allocator, a, S.create());
            defer @TypeOf(stack).deinit(allocator, stack);

            try std.testing.expectEqual(a, S.peek(stack));
        }

        fn @"S.peek(S.pop(S.push(a, S.create())).snd()) = null"(
            S: @This(),
            allocator: std.mem.Allocator,
            a: A,
        ) !void {
            const stack = S.pop(allocator, try S.push(allocator, a, S.create())).snd();
            defer @TypeOf(stack).deinit(allocator, stack);

            try std.testing.expectEqual(null, S.peek(stack));
        }

        fn checkInvariants(
            S: @This(),
            allocator: std.mem.Allocator,
            a: A,
        ) !void {
            try S.@"S.peek(S.create()) = null"();
            try S.@"S.peek(S.push(a, S.create())) = a"(allocator, a);
            try S.@"S.peek(S.pop(S.push(a, S.create())).snd()) = null"(allocator, a);
        }
    };
}

//
// Incarnation
//

fn StackList(comptime A: type) Stack(List, A) {
    return .{
        .create = struct {
            fn fun() List(A) {
                return .nil();
            }
        }.fun,
        .push = struct {
            fn fun(allocator: std.mem.Allocator, a: A, l: List(A)) anyerror!List(A) {
                return try .cons(allocator, a, l);
            }
        }.fun,
        .peek = struct {
            fn fun(l: List(A)) ?A {
                return switch (l) {
                    .Nil => null,
                    .Cons => |c| c.head,
                };
            }
        }.fun,
        .pop = struct {
            fn fun(allocator: std.mem.Allocator, l: List(A)) Pair(?A, List(A)) {
                return switch (l) {
                    .Nil => .init(null, .Nil),
                    .Cons => |c| {
                        defer allocator.destroy(c.tail);
                        return .init(c.head, c.tail.*);
                    },
                };
            }
        }.fun,
    };
}

test "should check Stack invariants for StackList incarnation" {
    var heap = std.heap.DebugAllocator(.{}){};
    defer _ = heap.deinit();
    const allocator = heap.allocator();

    const Module = StackList(u32);

    try Module.checkInvariants(allocator, 1);
}
