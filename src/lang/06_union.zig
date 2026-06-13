const std = @import("std");

// Simple Union
const Simple = struct {
    const Number = union {
        integer: i64,
        float: f64,
    };

    fn integer(n: Number) i64 {
        return n.integer;
    }
};

test "Simple union access" {
    const n = Simple.Number{ .integer = 42 };

    try std.testing.expectEqual(42, n.integer);
    // try std.testing.expectEqual(42, n.float);
    // 05_union.zig:12:38: error: access of union field 'float' while field 'integer' is active
    //    try std.testing.expectEqual(42, n.float);
}

// Tagged union

const Tagged = struct {
    const Label = enum { entier, flottant };

    const Number = union(Label) {
        entier: i64,
        flottant: f64,
    };

    fn zero(label: Label) Number {
        return if (label == .entier) .{ .entier = 0 } else .{ .flottant = 0 };
    }

    fn incr(number: Number) Number {
        return switch (number) {
            .entier => |n| .{ .entier = n + 1 },
            .flottant => |f| .{ .flottant = f + 1 },
        };
    }
};

test "Tagged union access" {
    const n = Tagged.zero(.entier);

    try std.testing.expectEqual(0, n.entier);
}

test "Tagged union incrementation" {
    const n = Tagged.incr(Tagged.zero(.entier));

    try std.testing.expectEqual(1, n.entier);
}

// Natural

pub const Nat = union(enum) {
    Z,
    S: *const Nat,

    pub fn fromInt(n: u32, allocator: std.mem.Allocator) !Nat {
        if (n == 0) return .Z;

        const reste = try fromInt(n - 1, allocator);
        const ptr_reste = try allocator.create(Nat);
        ptr_reste.* = reste;

        return .{ .S = ptr_reste };
    }

    pub fn clone(self: Nat, allocator: std.mem.Allocator) !Nat {
        switch (self) {
            .Z => return .Z,
            .S => |p| {
                const reste_clone = try p.*.clone(allocator);
                const ptr = try allocator.create(Nat);
                ptr.* = reste_clone;
                return .{ .S = ptr };
            },
        }
    }

    pub fn plus(self: Nat, b: Nat, allocator: std.mem.Allocator) !Nat {
        switch (self) {
            .Z => return b.clone(allocator),
            .S => |p| {
                const somme = try p.*.plus(b, allocator);
                const ptr_somme = try allocator.create(Nat);
                ptr_somme.* = somme;

                return .{ .S = ptr_somme };
            },
        }
    }

    pub fn deinit(self: Nat, allocator: std.mem.Allocator) void {
        switch (self) {
            .Z => {},
            .S => |p| {
                // On libère d'abord les enfants récursivement
                p.*.deinit(allocator);
                // Puis on libère le pointeur lui-même
                allocator.destroy(p);
            },
        }
    }

    pub fn toInt(self: Nat) u32 {
        switch (self) {
            .Z => return 0,
            .S => |p| return 1 + p.*.toInt(),
        }
    }
};

test "Natural addition" {
    const allocator = std.testing.allocator;
    const n21 = try Nat.fromInt(21, allocator);
    defer n21.deinit(allocator);

    const n42 = try n21.plus(n21, allocator);
    defer n42.deinit(allocator);

    try std.testing.expectEqual(42, n42.toInt());
}
