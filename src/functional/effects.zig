const std = @import("std");
const fun = @import("fun.zig");

//
// Type signatures
//

const specs = struct {
    fn Pure(M: fn (type) type, A: type) type {
        return fn (A) M(A);
    }

    fn Map(M: fn (type) type, A: type, B: type) type {
        return fn (fn (A) B) fn (M(A)) M(B);
    }

    fn Bind(M: fn (type) type, A: type, B: type) type {
        return fn (fn (A) M(B)) fn (M(A)) M(B);
    }

    fn Join(M: fn (type) type, A: type) type {
        return fn (M(M(A))) M(A);
    }
};

fn Functor(M: fn (type) type, pure_impl: specs(M).Pure) type {
    return struct {
        fn pure(comptime A: type) specs(M).Pure(A) {
            return pure_impl(A);
        }
    };
}

//
// Optional
//

fn Optional(T: type) type {
    return ?T;
}

const optional = struct {
    fn pure(A: type) specs.Pure(Optional, A) {
        return struct {
            fn fun(value: A) Optional(A) {
                return value;
            }
        }.fun;
    }

    fn map(A: type, B: type) specs.Map(Optional, A, B) {
        return fun.curry(struct {
            fn fun(mapper: fn (A) B, value: Optional(A)) Optional(B) {
                return if (value) |a| pure(B)(mapper(a)) else null;
            }
        }.fun);
    }

    fn bind(A: type, B: type) specs.Bind(Optional, A, B) {
        return fun.curry(struct {
            fn fun(binder: fn (A) Optional(B), value: Optional(A)) Optional(B) {
                return if (value) |a| binder(a) else null;
            }
        }.fun);
    }

    fn join(A: type) specs.Join(Optional, A) {
        return struct {
            fn fun(value: Optional(Optional(A))) Optional(A) {
                return if (value) |a| a else null;
            }
        }.fun;
    }
};

fn incr(a: u32) u64 {
    return a + 1;
}

test "Optional pure in action" {
    const res = optional.pure(u32)(1);
    try std.testing.expectEqual(1, res);
}

test "Optional map in action" {
    const res = optional.map(u32, u64)(incr)(1);
    try std.testing.expectEqual(2, res);
}

fn incr2(a: u32) ?u64 {
    return a + 1;
}

test "Optional bind in action" {
    const res = optional.bind(u32, u64)(incr2)(1);
    try std.testing.expectEqual(2, res);
}

test "Optional join in action" {
    const res = optional.bind(u32, u64)(incr2)(1);
    try std.testing.expectEqual(2, res);
}
