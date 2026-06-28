const std = @import("std");

const Point = struct {
    x: u32,
    y: u32,

    fn initAlloc(allocator: std.mem.Allocator, x: u32, y: u32) !*@This() {
        const p_ptr = try allocator.create(@This());
        p_ptr.* = init(x, y);
        return p_ptr;
    }

    fn init(x: u32, y: u32) @This() {
        return @This(){
            .x = x,
            .y = y,
        };
    }

    fn move(self: @This(), dx: u32, dy: u32) @This() {
        return @This(){
            .x = self.x + dx,
            .y = self.x + dy,
        };
    }
};

test "should create a Point and check absissa" {
    const point = Point.init(1, 2);

    try std.testing.expectEqualDeep(1, point.x);
}

test "should create a Point and check ordinate" {
    const point = Point.init(1, 2);

    try std.testing.expectEqualDeep(2, point.y);
}

test "should allocate a Point with explicit pointer" {
    const point_ptr = try Point.initAlloc(std.testing.allocator, 1, 2);
    defer std.testing.allocator.destroy(point_ptr);

    try std.testing.expectEqualDeep(1, point_ptr.*.x);
}

test "should allocate a Point" {
    const point_ptr = try Point.initAlloc(std.testing.allocator, 1, 2);
    defer std.testing.allocator.destroy(point_ptr);

    try std.testing.expectEqualDeep(1, point_ptr.x);
}

test "should perform deep copy when initializing pointer" {
    const point_ptr = try std.testing.allocator.create(Point);
    defer std.testing.allocator.destroy(point_ptr);

    const point = Point.init(1, 2);
    point_ptr.* = point;

    const x1_ptr = @intFromPtr(&point.x);
    const x2_ptr = @intFromPtr(&point_ptr.x);

    try std.testing.expect(!(x1_ptr == x2_ptr));
}
