const std = @import("std");

fn identite(comptime T: type, comptime valeur: T) T {
    return valeur;
}

test "Girard Paradox" {
    const Paradoxal = identite(type, type);
    std.debug.print("Le type retourné est : {}\n", .{Paradoxal});
}