const std = @import("std");

pub fn parse(opLine: []u8) i32 {
    var opL = std.mem.trim(u8, opLine, " \t");
    const op = std.mem.sliceTo(opLine, ' ');
    opL = opL[(std.mem.find(u8, opLine, " \t") orelse 0)..];
    opL = std.mem.trim(u8, opL, " \t");

    var args = std.mem.splitAny(u8, opL, ",");

    std.debug.print("op: {s}\n", .{op});
    std.debug.print("opLine: {s}\n", .{opL});
    while (args.next()) |arg| {
        std.debug.print("arg: {s};\n", .{arg});
    }

    return 0;
}

