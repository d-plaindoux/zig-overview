const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const score_ptr = try allocator.create(u32);
    score_ptr.* = 42;
    allocator.destroy(score_ptr);

    // Use-After-Free here
    score_ptr.* = 999;
}
