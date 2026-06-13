const std = @import("std");

test "..." {
    var sum: usize = 0;

    for (0..5) |v| {
        sum += v;
    } else {
        sum += 5;
    }

    try std.testing.expectEqual(15, sum);
}
