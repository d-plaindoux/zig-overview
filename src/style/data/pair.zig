pub fn Pair(A: type, B: type) type {
    return struct {
        _0: A,
        _1: B,

        pub fn init(a: A, b: B) @This() {
            return .{
                ._0 = a,
                ._1 = b,
            };
        }

        pub fn fst(self: @This()) A {
            return self._0;
        }

        pub fn snd(self: @This()) B {
            return self._1;
        }
    };
}
