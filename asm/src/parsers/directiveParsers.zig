const std = @import("std");
const ObjStruct = @import("../obj.zig").ObjStruct;
const main = @import("../main.zig");
const utils = @import("../utils.zig");
const valUtils = @import("valUtils.zig");

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
        main.o.addData(valUtils.asBytes(@TypeOf(val), val));
    } else if (std.mem.eql(u8, directive.name, ".half")) {
        const val = valUtils.parseHalf(valStr) orelse {
            std.log.err("Error: invalid half value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        main.o.addData(valUtils.asBytes(@TypeOf(val), val));
    } else if (std.mem.eql(u8, directive.name, ".byte")) {
        const val = valUtils.parseByte(valStr) orelse {
            std.log.err("Error: invalid byte value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        main.o.addData(valUtils.asBytes(@TypeOf(val), val));
    } else if (std.mem.eql(u8, directive.name, ".float")) {
        const val = valUtils.parseFloat(valStr) orelse {
            std.log.err("Error: invalid float value: '{s}'", .{valStr});
            std.process.exit(1);
        };
        main.o.addData(valUtils.asBytes(@TypeOf(val), val));
    }
}

fn parseSymbol(directive: utils.Directive, str: []const u8) void {
    if (std.mem.eql(u8, directive.name, ".segment")) {
        main.o.segment = str;
    } else if (std.mem.eql(u8, directive.name, ".global")) {
        std.debug.print("global: {s}\n", .{str}); 
    }
}
