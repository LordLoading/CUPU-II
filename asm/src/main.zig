const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");
const obj = @import("obj.zig");
const parseDirective = @import("parsers/directiveParsers.zig").parse;

pub var o = obj.ObjStruct{};
pub var alloc: std.mem.Allocator = undefined;
pub var section: ?obj.ObjStruct.section = null;

pub fn main(init: std.process.Init) !void {
    alloc = init.arena.allocator();

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    _ = args;

    const num: i32 = -400;
    const flt: f32 = @bitCast(num);
    o.addData(std.mem.asBytes(&flt));

    const contents = try std.Io.Dir.cwd().readFileAlloc(init.io, "assembleme.asm", init.gpa, .limited(1234));
    defer init.gpa.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");
    while (lines.next()) |line| {
        var trimmed = utils.trimComment(line);
        trimmed = std.mem.trim(u8, trimmed, " \t\n\r");

        utils.parseLine(trimmed);
    }

    const json = std.json.fmt(o, .{ .whitespace = .indent_2, .emit_null_optional_fields = true});

    const jsonStr = std.fmt.allocPrint(alloc, "{f}", .{json}) catch |err| {
        std.log.err("json alloc error: {any}", .{err});
        std.process.exit(1); 
    };

    try std.Io.Dir.cwd().writeFile(init.io, .{ .data = jsonStr, .sub_path = "assembleme.o" });
}
