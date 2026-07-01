const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");

pub fn main(init: std.process.Init) !void {
    var section: []const u8 = "";

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const contents = try std.Io.Dir.cwd().readFileAlloc(init.io, "assembleme.s", init.gpa, .limited(1234));
    defer init.gpa.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");
    while (lines.next()) |line| {
        if (utils.getFirstWord(line)) |firstWord| {
            if (utils.getDirectiveByName(firstWord)) |directive| {
                if (directive.t == .section) section = directive.name;
            }
        }
    }

    const instLine = init.gpa.dupe(u8, "!lui $1, -30") catch unreachable;
    defer init.gpa.free(instLine);
    std.debug.print("inst: {s}\n", .{utils.getFirstWord(instLine) orelse "null"});
    const bin = parseInst(instLine);
    std.debug.print("bin: {b}\n", .{bin});
}

