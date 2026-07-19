const std = @import("std");
const parseInst = @import("parsers/instParser.zig").parse;
const utils = @import("utils.zig");
const obj = @import("obj.zig");
const parseDirective = @import("parsers/directiveParsers.zig").parse;

pub var o = obj.ObjStruct{};
pub var alloc: std.mem.Allocator = undefined;
pub var section: ?obj.ObjStruct.section = null;

pub var text: std.ArrayList(u8) = .empty;
pub var data: std.ArrayList(u8) = .empty;
pub var bss: std.ArrayList(u8) = .empty;
pub var labels: std.ArrayList(obj.ObjStruct.Label) = .empty;
pub var relocations: std.ArrayList(obj.ObjStruct.Relocation) = .empty;

var fileName: []const u8 = "";

pub fn main(init: std.process.Init) !void {
    alloc = init.arena.allocator();

    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) {
        std.log.info("Usage: zig run assembleme.asm <input file> <output file>\n", .{});
        std.process.exit(0);
    }

    fileName = args[1];

    const contents = try std.Io.Dir.cwd().readFileAlloc(init.io, fileName, init.gpa, .limited(1234));
    defer init.gpa.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");
    while (lines.next()) |line| {
        var trimmed = utils.trimComment(line);
        trimmed = std.mem.trim(u8, trimmed, " \t\n\r");

        utils.parseLine(trimmed);
    }

    o.text = text.items;
    o.data = data.items;
    o.bss = bss.items;
    o.labels = labels.items;
    o.relocations = relocations.items;

    const json = std.json.fmt(o, .{ .whitespace = .indent_2, .emit_null_optional_fields = true });

    const jsonStr = std.fmt.allocPrint(alloc, "{f}", .{json}) catch |err| {
        std.log.err("json alloc error: {any}", .{err});
        std.process.exit(1);
    };

    var outFile = fileName[0..std.mem.findLast(u8, fileName, ".").?];
    outFile = std.fmt.allocPrint(alloc, "out/{s}.o", .{outFile}) catch |err| {
        std.log.err("outFile alloc error: {any}", .{err});
        std.process.exit(1);
    };

    if (args.len > 2) {
        outFile = args[2];
    }

    std.Io.Dir.cwd().writeFile(init.io, .{ .data = jsonStr, .sub_path = outFile }) catch |err| {
        switch (err) {
            error.FileNotFound => {
                std.Io.Dir.cwd().createDirPath(init.io, outFile[0..std.mem.findLast(u8, outFile, "/").?]) catch |errr| {
                    std.log.err("createDirPath error: {any}", .{errr});
                    std.process.exit(1);
                };
                std.Io.Dir.cwd().writeFile(init.io, .{ .data = jsonStr, .sub_path = outFile }) catch |errr| {
                    std.log.err("writeFile error: {any}", .{errr});
                    std.process.exit(1);
                };
            },
            else => std.log.err("writeFile error: {any}", .{err}),
        }
    };
}
