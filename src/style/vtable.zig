//
// This example apply the Vtable pattern
//

const std = @import("std");

fn asTPrt(T: type, opaque_ptr: *const anyopaque) T {
    return @as(T, @ptrCast(@alignCast(opaque_ptr)));
}

//
// Figure abstraction
//

const Figure = struct {
    const Self = @This();

    v_impl: *const anyopaque,
    v_surface: *const fn (self: *const anyopaque) f64,

    pub fn surface(self: Self) f64 {
        return self.v_surface(self.v_impl);
    }

    pub inline fn from(comptime impl_obj: anytype) Self {
        const adapter = Adapter(@TypeOf(impl_obj));

        return .{
            .v_impl = impl_obj,
            .v_surface = adapter.surface,
        };
    }

    inline fn Adapter(ImplType: type) type {
        return struct {
            fn surface(value: *const anyopaque) f64 {
                return asTPrt(ImplType, value).surface();
            }
        };
    }
};

//
// DSL Layer mimicking Rust trait implementation
//

fn impl(comptime T: type) type {
    return struct {
        fn @"for"(comptime valeur: anytype) T {
            return T.from(valeur);
        }
    };
}

//
// Some figures definition
//

const Carre = struct {
    longueur: f64,

    pub fn surface(self: @This()) f64 {
        return self.longueur * self.longueur;
    }
};

const Rectangle = struct {
    longueur: f64,
    largeur: f64,

    pub fn surface(self: @This()) f64 {
        return self.longueur * self.largeur;
    }
};

const Cercle = struct {
    rayon: f64,

    pub fn surface(self: @This()) f64 {
        return std.math.pi * self.rayon * self.rayon;
    }
};

//
// Test corner
//

test "should compute Figures(carre) and Fugure(rectangle) surface" {
    const figures = [_]Figure{
        impl(Figure).@"for"(&Carre{ .longueur = 10 }),
        impl(Figure).@"for"(&Rectangle{ .largeur = 10, .longueur = 4 }),
        impl(Figure).@"for"(&Cercle{ .rayon = 3 }),
    };

    var surface: f64 = 0;

    for (figures) |figure| {
        surface = surface + figure.surface();
    }

    try std.testing.expectEqual(168, std.math.floor(surface));
}
