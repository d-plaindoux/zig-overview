const std = @import("std");

// ∃x. T = ∀y. (∀x. T(x) -> y) -> y
pub fn Exists(comptime T: fn (type) type) type {
    return struct {
        pub fn pack(comptime Abstract: type, value: T(Abstract)) type {
            return struct {
                // ∀y. (∀x. T(x) -> y) -> y
                // anytype captures ∀x. T(x) -> y
                pub fn unpack(comptime Y: type, continuation: anytype) Y {
                    return continuation.run(Abstract, value);
                }
            };
        }
    };
}

test "...." {
    const Identity = struct {
        fn fun(comptime X: type) type {
            return X;
        }
    }.fun;

    const Opt = struct {
        fn fun(comptime X: type) type {
            return ?X;
        }
    }.fun;

    const Exists_i32 = Exists(Opt).pack(i32, null);
    const Exists_bool = Exists(Identity).pack(bool, true);

    const Inspector = struct {
        pub fn run(comptime X: type, value: ?X) void {
            std.debug.print("Contenu du paquet -> Type: {}, Valeur: {?}\n", .{ X, value });
        }
    };

    Exists_i32.unpack(void, Inspector);
    Exists_bool.unpack(void, Inspector);
}
