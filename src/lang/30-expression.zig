fn main() void {
    _ = if (true) 1 else 2;
    _ = for (5..10) |i| i else @"return": {
        break :@"return" 10;
    };
    var i = 0;
    _ = while (i < 10) : (i += 1) {} else @"return": {
        break :@"return" 10;
    };
}
