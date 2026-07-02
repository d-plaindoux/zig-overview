const std = @import("std");

test "double free" {
    var heap = std.heap.DebugAllocator(.{}){};
    defer _ = heap.deinit();
    const allocator = heap.allocator();
    const number = try allocator.create(i32);
    allocator.destroy(number);
    allocator.destroy(number);
}
