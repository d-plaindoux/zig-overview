const std = @import("std");

pub fn Pair(comptime F: type, comptime S: type) type {
    return struct {
        const Self = @This();

        first: F,
        second: S,

        fn init(f: F, s: S) Self {
            return .{
                .first = f,
                .second = s,
            };
        }
    };
}

pub fn Vector(comptime n: usize, comptime T: type) type {
    return struct {
        const Self = @This();

        data: [n]T,

        fn addT() type {
            return Vector(n + 1, T);
        }

        pub fn add(self: Self, t: T) Self.addT() {
            var data: [n + 1]T = undefined;
            @memcpy(data[0..n], &self.data);
            data[n] = t;

            return .init(data);
        }

        fn concatT(comptime m: usize) type {
            return Vector(n + m, T);
        }

        pub fn concat(self: Self, comptime m: usize, v: Vector(m, T)) Self.concatT(m) {
            var data: [n + m]T = undefined;
            @memcpy(data[0..n], &self.data);
            @memcpy(data[n..], &v.data);

            return Vector(n + m, T).init(data);
        }

        fn zipT(comptime R: type) type {
            return Vector(n, Pair(T, R));
        }

        pub fn zip(self: Self, comptime R: type, v: Vector(n, R)) Self.zipT(R) {
            var data: [n]Pair(T, R) = undefined;
            for (0..n) |i| {
                data[i] = .init(self.data[i], v.data[i]);
            }

            return .init(data);
        }

        fn init(v: [n]T) Self {
            return .{
                .data = v,
            };
        }
    };
}

test "should add an element to a vector" {
    const v0 = Vector(0, u32).init([0]u32{});
    const v1 = v0.add(42);

    try std.testing.expectEqual([_]u32{42}, v1.data);
}

test "should concat two vectors" {
    const v0 = Vector(0, u32).init([0]u32{});
    const v1 = Vector(1, u32).init([1]u32{42});
    const v2 = v0.concat(1, v1);

    try std.testing.expectEqual([1]u32{42}, v2.data);
}

test "should zip two vectors" {
    const v0 = Vector(1, u32).init([1]u32{21});
    const v1 = Vector(1, u64).init([1]u64{42});
    const v2 = v0.zip(u64, v1);

    try std.testing.expectEqual([1]Pair(u32, u64){.init(21, 42)}, v2.data);
}
