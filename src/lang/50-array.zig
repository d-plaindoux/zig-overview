const std = @import("std");

test "..." {
    const hello: [5]u8 = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    const he: []const u8 = hello[0..2];

    try std.testing.expectEqualSlices(u8, &[_]u8{ 'h', 'e'}, he);
}
