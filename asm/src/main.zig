const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const instLine = init.gpa.dupe(u8, "!add $1, $2, $3") catch unreachable;
    defer init.gpa.free(instLine);
    const bin = parseInst(instLine, init.gpa);
    std.debug.print("bin: {b}\n", .{bin});
}

