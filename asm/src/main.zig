const std = @import("std");
const parseOp = @import("parsers/opParser.zig").parse;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const opLine = init.gpa.dupe(u8, "!add $t, $a, $b") catch unreachable;
    defer init.gpa.free(opLine);
    _ = parseOp(opLine);
}

