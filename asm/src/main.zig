const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");
const o = @import("obj.zig").o;

pub var alloc: std.mem.Allocator = undefined;

pub fn main(init: std.process.Init) !void {
    alloc = init.arena.allocator();

    var section: []const u8 = "";

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const contents = try std.Io.Dir.cwd().readFileAlloc(init.io, "assembleme.asm", init.gpa, .limited(1234));
    defer init.gpa.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");
    while (lines.next()) |line| {
        var trimmed = utils.trimComment(line);
        trimmed = std.mem.trim(u8, line, " \t");
        if (trimmed.len == 0) continue;
        std.debug.print("trimmed: {s}\n", .{trimmed});
        if (utils.getFirstWord(line)) |firstWord| {
            if (utils.getDirectiveByName(firstWord)) |directive| {
                if (directive.t == .section) section = directive.name;
            }

            if (utils.getOpByName(firstWord)) |op| {
                _ = op;
                const inst = parseInst(line);
                o.addInst(inst.bin);
            }
        }
    }

    std.debug.print("text: {s}\n", .{o.text});
}
