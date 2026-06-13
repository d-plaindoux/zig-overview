const std = @import("std");

pub fn List(comptime T: type) type {
    return union(enum) {
        Nil,
        Cons: struct { head: T, tail: *const Self },

        const Self = @This();

        pub fn nil() Self {
            return .Nil;
        }

        pub fn cons(allocator: std.mem.Allocator, head: T, tail: Self) anyerror!Self {
            const cell = try allocator.create(Self);
            cell.* = tail;

            return .{
                .Cons = .{
                    .head = head,
                    .tail = cell,
                },
            };
        }

        pub fn literal(allocator: std.mem.Allocator, l: []const T) anyerror!Self {
            var result = Self.nil();
            var i = l.len;
            while (i > 0) : (i -= 1) {
                result = try Self.cons(allocator, l[i - 1], result);
            }
            return result;
        }

        pub fn deinit(allocator: std.mem.Allocator, list: Self) void {
            switch (list) {
                .Nil => {},
                .Cons => |c| {
                    Self.deinit(allocator, c.tail.*);
                    allocator.destroy(c.tail);
                },
            }
        }

        // Function

        fn map(allocator: std.mem.Allocator, comptime R: type, mapper: fn (T) R, list: Self) anyerror!List(R) {
            return switch (list) {
                .Nil => .Nil,
                .Cons => |c| Self.cons(
                    allocator,
                    mapper(c.head),
                    try Self.map(allocator, R, mapper, c.tail.*),
                ),
            };
        }
    };
}

// Warning: Not tail recursive!

test "should build map and reduce a list" {
    const sum = struct {
        fn fun(list: List(u32)) u32 {
            return switch (list) {
                .Nil => 0,
                .Cons => |c| c.head + @This().fun(c.tail.*),
            };
        }
    }.fun;

    const incr = struct {
        fn fun(i: u32) u32 {
            return i + 1;
        }
    }.fun;

    var heap = std.heap.DebugAllocator(.{}){};
    defer _ = heap.deinit();
    const allocator = heap.allocator();

    const ListInt = List(u32);
    const l1 = try ListInt.literal(allocator, &.{ 1, 2, 3 });
    defer ListInt.deinit(allocator, l1);

    const l2 = try ListInt.map(allocator, u32, incr, l1);
    defer ListInt.deinit(allocator, l2);

    try std.testing.expectEqual(9, sum(l2));
}
