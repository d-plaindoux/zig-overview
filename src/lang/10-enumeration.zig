const std = @import("std");

const Couleur = enum { rouge, noir };

const Enseigne = enum {
    pique,
    trefle,
    carreau,
    coeur,

    fn couleur(e: Enseigne) Couleur {
        return switch (e) {
            .pique, .trefle => .noir,
            .carreau, .coeur => .rouge,
        };
    }
};

test "Qui est rouge ?" {
    try std.testing.expectEqual(.rouge, Enseigne.carreau.couleur());
}

test "Qui est noir ?" {
    try std.testing.expectEqual(.noir, Enseigne.couleur(.trefle));
}