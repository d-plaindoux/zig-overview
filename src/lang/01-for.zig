const std = @import("std");

test "for loop" {
    var sum: usize = 0;

    for (0..5) |v| {
        sum += v;
    } else {
        sum += 5;
    }

    try std.testing.expectEqual(15, sum);
}

test "size mismatch" {
    const a = [_]i32{ 1, 2, 3 };
    const b = [_]i32{ 10, 20 }; // Taille différente !

    // Erreur de compilation ici : "compile error: for loop sequence lengths mismatch: 3 and 2"
    for (a, b) |item_a, item_b| {
        std.debug.print("{} - {}\n", .{item_a, item_b});
    }
}