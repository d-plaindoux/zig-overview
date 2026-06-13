//
// Dot programming style
//

const std = @import("std");

const Point = struct {
    const Self = @This();

    x: u32,
    y: u32,

    fn init(x: u32, y: u32) Self {
        return .{
            .x = x,
            .y = y,
        };
    }

    fn move(self: Self, dx: u32, dy: u32) Self {
        return .{
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
