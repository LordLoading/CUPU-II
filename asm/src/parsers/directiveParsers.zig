const std = @import("std");
const ObjStruct = @import("../obj.zig").ObjStruct;
const main = @import("../main.zig");
const utils = @import("../utils.zig");
const valUtils = @import("valUtils.zig");
const labelUtils = @import("../parsers/labelUtils.zig");

pub fn parse(directive: utils.Directive, trimmed: []const u8) void {
    if (directive.t == .section) {
        if (std.mem.eql(u8, directive.name, ".text")) {
            main.section = .text;
        } else if (std.mem.eql(u8, directive.name, ".data")) {
            main.section = .data;
        } else if (std.mem.eql(u8, directive.name, ".bss")) {
            main.section = .bss;
        }
    } else {
        const fwr = utils.FWR.init(trimmed) orelse {
            std.log.err("Error: invalid directive: '{s}'", .{trimmed});
            std.process.exit(1);
        };

        if (fwr.rest == null) {
            std.log.err("Error: directive '{s}' cant be on its own.", .{trimmed});
            std.process.exit(1);
        } else {
            const rest = fwr.rest.?;

            if (directive.t == .data) {
                parseData(directive, rest);
            } else if (directive.t == .symbol) {
                parseSymbol(directive, rest);
            }
        }
    }
}

fn parseData(directive: utils.Directive, valStr: []const u8) void {
    if (main.section != .data) {
        std.log.err("Error: data directive outside of data section", .{});
        std.process.exit(1);
    }

    if (std.mem.eql(u8, directive.name, ".word")) {
        const val = valUtils.parseWord(valStr) orelse {
            std.log.err("Error: invalid word value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        const bytes = std.mem.asBytes(&val);
        ObjStruct.addData(bytes);
    } else if (std.mem.eql(u8, directive.name, ".half")) {
        const val = valUtils.parseHalf(valStr) orelse {
            std.log.err("Error: invalid half value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        const bytes = std.mem.asBytes(&val);
        ObjStruct.addData(bytes);
    } else if (std.mem.eql(u8, directive.name, ".byte")) {
        const val = valUtils.parseByte(valStr) orelse {
            std.log.err("Error: invalid byte value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        const bytes = std.mem.asBytes(&val);
        ObjStruct.addData(bytes);
    } else if (std.mem.eql(u8, directive.name, ".float")) {
        const val = valUtils.parseFloat(valStr) orelse {
            std.log.err("Error: invalid float value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        const bytes = std.mem.asBytes(&val);
        ObjStruct.addData(bytes);
    } else if (std.mem.eql(u8, directive.name, ".ascii")) {
        var trimmed = std.mem.trim(u8, valStr, " \t");
        if (trimmed[0] != '"' or trimmed[trimmed.len - 1] != '"') {
            std.log.err("Error: invalid ascii value: '{s}'", .{valStr});
            std.process.exit(1);
        }

        trimmed = trimmed[1 .. trimmed.len - 1];
        trimmed = valUtils.unescape(main.alloc, trimmed) catch unreachable;

        ObjStruct.addData(trimmed);
    } else if (std.mem.eql(u8, directive.name, ".asciz")) {
        var trimmed = std.mem.trim(u8, valStr, " \t");
        if (trimmed[0] != '"' or trimmed[trimmed.len - 1] != '"') {
            std.log.err("Error: invalid ascii value: '{s}'", .{valStr});
            std.process.exit(1);
        }

        trimmed = trimmed[1 .. trimmed.len - 1];
        trimmed = valUtils.unescape(main.alloc, trimmed) catch unreachable;

        ObjStruct.addData(trimmed);
        ObjStruct.addData("\x00");
    }
}

fn parseSymbol(directive: utils.Directive, str: []const u8) void {
    if (std.mem.eql(u8, directive.name, ".segment")) {
        main.o.segment = str;
    } else if (std.mem.eql(u8, directive.name, ".global")) {
        if (!labelUtils.hasLabel(str, true)) {
            std.log.err(".global has no label", .{});
            std.process.exit(1);
        }
    }
}
