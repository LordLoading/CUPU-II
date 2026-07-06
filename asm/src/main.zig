const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");
const obj = @import("obj.zig");

var o = obj.ObjStruct{};

pub var alloc: std.mem.Allocator = undefined;

pub fn main(init: std.process.Init) !void {
    var section: []const u8 = "";
    alloc = init.arena.allocator();

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const contents = try std.Io.Dir.cwd().readFileAlloc(init.io, "assembleme.asm", init.gpa, .limited(1234));
    defer init.gpa.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");
    while (lines.next()) |line| {
        var trimmed = utils.trimComment(line);
        trimmed = std.mem.trim(u8, trimmed, " \t\n\r");
        if (trimmed.len == 0) continue;
        if (utils.getFirstWord(line)) |firstWord| {
            if (utils.getDirectiveByName(firstWord)) |directive| {
                if (directive.t == .section) section = directive.name;
            }

            if (utils.getOpByName(std.mem.trim(u8, firstWord, "!"))) |op| {
                _ = op;
                const inst = parseInst(trimmed);
                o.addInst(inst.bin);
            }
        }
    }

    std.debug.print("o.text.items: {s}\n", .{o.text.items});
}
