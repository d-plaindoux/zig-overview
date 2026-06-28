const std = @import("std");

const List = @import("./data/list.zig").List;
const Pair = @import("./data/pair.zig").Pair;

//
// Compile time specification verification
//

fn implement(comptime Spec: type) type {
    return struct {
        fn checkTypeOf(comptime Signature: type, comptime Impl: type) void {
            const sig_info = @typeInfo(Signature).@"struct";

            inline for (sig_info.fields) |field| {
                if (!@hasDecl(Impl, field.name)) {
                    @compileError("Erreur de signature : la fonction '" ++ field.name ++ "' est manquante dans " ++ @typeName(Impl));
                }

                const actual_type = @TypeOf(@field(Impl, field.name));
                if (actual_type != field.type) {
                    @compileError("Erreur de signature pour '" ++ field.name ++ "' dans " ++ @typeName(Impl) ++ ".\n" ++
                        "  Attendu : " ++ @typeName(field.type) ++ "\n" ++
                        "  Obtenu  : " ++ @typeName(actual_type));
                }
            }
        }

        fn using(comptime Impl: type) Spec {
            // checkTypeOf(Spec, Impl);

            var result: Spec = undefined;

            const target_info = @typeInfo(Spec).@"struct";
            inline for (target_info.fields) |field| {
                @field(result, field.name) = @field(Impl, field.name);
            }

            return result;
        }
    };
}

//
// Stack specification
//

fn Stack(comptime T: fn (type) type, comptime A: type) type {
    return struct {
        create: fn () callconv(.@"inline") T(A),
        push: fn (std.mem.Allocator, A, T(A)) anyerror!T(A),
        peek: fn (T(A)) ?A,
        pop: fn (std.mem.Allocator, T(A)) Pair(?A, T(A)),

        //
        // Invariants
        //

        fn @"S.peek(S.create()) = null"(Impl: @This()) !void {
            const stack = Impl.create();

            try std.testing.expectEqual(null, Impl.peek(stack));
        }

        fn @"S.peek(S.push(a, S.create())) = a"(
            Impl: @This(),
            allocator: std.mem.Allocator,
            a: A,
        ) !void {
            const stack = try Impl.push(allocator, a, Impl.create());
            defer @TypeOf(stack).deinit(allocator, stack);

            try std.testing.expectEqual(a, Impl.peek(stack));
        }

        fn @"S.peek(S.pop(S.push(a, S.create())).snd()) = null"(
            Impl: @This(),
            allocator: std.mem.Allocator,
            a: A,
        ) !void {
            const stack = Impl.pop(allocator, try Impl.push(allocator, a, Impl.create())).snd();
            defer @TypeOf(stack).deinit(allocator, stack);

            try std.testing.expectEqual(null, Impl.peek(stack));
        }

        fn checkInvariants(
            Impl: @This(),
            allocator: std.mem.Allocator,
            a: A,
        ) !void {
            try Impl.@"S.peek(S.create()) = null"();
            try Impl.@"S.peek(S.push(a, S.create())) = a"(allocator, a);
            try Impl.@"S.peek(S.pop(S.push(a, S.create())).snd()) = null"(allocator, a);
        }
    };
}

fn StackList(comptime A: type) type {
    return struct {
        inline fn create() List(A) {
            return .nil();
        }

        fn push(allocator: std.mem.Allocator, a: A, l: List(A)) anyerror!List(A) {
            return try .cons(allocator, a, l);
        }

        fn peek(l: List(A)) ?A {
            return switch (l) {
                .Nil => null,
                .Cons => |c| c.head,
            };
        }

        fn pop(allocator: std.mem.Allocator, l: List(A)) Pair(?A, List(A)) {
            return switch (l) {
                .Nil => .init(null, .Nil),
                .Cons => |c| {
                    defer allocator.destroy(c.tail);
                    return .init(c.head, c.tail.*);
                },
            };
        }
    };
}

test "should check Stack invariants for StackList incarnation" {
    var heap = std.heap.DebugAllocator(.{}){};
    defer _ = heap.deinit();
    const allocator = heap.allocator();

    const Impl = StackList(u32);
    const Module = implement(Stack(List, u32)).using(Impl);

    try Module.checkInvariants(allocator, 1);
}
