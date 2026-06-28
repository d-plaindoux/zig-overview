const math_error = error{DivisionByZero};

fn divide(a: f64, b: f64) error{DivisionByZero}!f64 {
    if (b == 0) {
        return math_error.DivisionByZero;
    }

    return a / b;
}

const std = @import("std");

test "should divide" {
    try std.testing.expectEqual(21, divide(42, 2) catch |e| return e);
}

test "should generates an error" {
    try std.testing.expectEqual(null, divide(1, 0) catch null);
}
