const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const contents = try std.Io.Dir.cwd().readFileAlloc(init.io, "assembleme.s", init.gpa, .limited(1234));
    defer init.gpa.free(contents);
    std.debug.print("contents:\n{s}\n", .{contents});

    const instLine = init.gpa.dupe(u8, "!lui $1, -30") catch unreachable;
    defer init.gpa.free(instLine);
    std.debug.print("inst: {s}\n", .{utils.getFirstWord(instLine) orelse "null"});
    const bin = parseInst(instLine);
    std.debug.print("bin: {b}\n", .{bin});
}

