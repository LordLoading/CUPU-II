const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");
const obj = @import("obj.zig");
const parseDirective = @import("parsers/directiveParsers.zig").parse; 

pub var o = obj.ObjStruct{};
pub var alloc: std.mem.Allocator = undefined;
pub var section: []const u8 = ""; 

pub fn main(init: std.process.Init) !void {
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
                parseDirective(directive, trimmed);
            }

            if (utils.getOpByName(std.mem.trim(u8, firstWord, "!"))) |op| {
                _ = op;
                const inst = parseInst(trimmed);
                o.addInst(inst.bin);
            }
        }
    }

    std.debug.print("o.text: {s}\n", .{o.text.items});
}
