const std = @import("std");

fn foo(input: *const [8] u8) void {
    var buffer: [8]u8 = undefined;
    @memcpy(buffer[0..], input);
}

pub fn main() void {
    foo("Plus de 8 caractères!");
}
