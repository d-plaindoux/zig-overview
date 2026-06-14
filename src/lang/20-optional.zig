const std = @import("std");

test "a orelse ..." {
    const a: ?u32 = 1;

    try std.testing.expectEqual(1, a orelse 0);
}

test "a?" {
    const a: ?u32 = 1;

    try std.testing.expectEqual(1, a.?);
}

test "if (a) |v| ..." {
    const a: ?u32 = 1;

    if (a) |v| {
        try std.testing.expectEqual(1, v);
    } else {
        try std.testing.expect(false);
    }
}

test "if (a) |v| ...with a modifiable" {
    var a: ?u32 = 1;

    if (a) |*v| {
        try std.testing.expectEqual(1, v.*);
    } else {
        try std.testing.expect(false);
    }
}
