const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");
const obj = @import("obj.zig");
const parseDirective = @import("parsers/directiveParsers.zig").parse;

pub var o = obj.ObjStruct{};
pub var alloc: std.mem.Allocator = undefined;
pub var section: ?enum { text, data, bss } = null;

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
                continue;
            }

            if (utils.getOpByName(std.mem.trim(u8, firstWord, "!"))) |op| {
                if (section != .text) {
                    std.log.err("Error: instruction outside of text section", .{});
                    std.process.exit(1);
                }
                _ = op;
                const inst = parseInst(trimmed);
                if (inst.label) |label| {
                    o.addRelocation(label, .inst, .text, @divFloor(@as(u32, @truncate(o.text.items.len)), 2));
                }
                o.addInst(inst.bin);
            }
        }
    }

    const json = std.json.fmt(o, .{ .whitespace = .indent_2, .emit_null_optional_fields = true, .emit_strings_as_arrays = false, .escape_unicode = false, .emit_nonportable_numbers_as_strings = false });
    std.debug.print("json: {f}\n", .{json});
}
