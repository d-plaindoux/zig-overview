const std = @import("std");
const ncurses = @cImport({
    @cInclude("ncurses.h");
});

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    _ = ncurses.initscr();
    defer _ = ncurses.endwin();

    for (0..10) |i| {
        _ = ncurses.clear();

        const boite = ncurses.subwin(
            ncurses.stdscr,
            2,
            2,
            @as(c_int, @intCast(i)),
            @as(c_int, @intCast(i)),
        ) orelse unreachable;
        defer _ = ncurses.delwin(boite);

        _ = ncurses.wborder(boite, '|','|','-','-','+','+','+','+');
        _ = ncurses.wrefresh(boite);
        _ = ncurses.refresh();

        try std.Io.sleep(io, std.Io.Duration.fromMilliseconds(500), .awake);
    }

    _ = ncurses.getch();
}
