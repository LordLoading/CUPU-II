const std = @import("std");
const utils = @import("../utils.zig");
const parseReg = @import("regParser.zig").parse;
const valUtils = @import("valUtils.zig");

pub const InstReloc = struct {
    label: ?[]const u8,
    bin: u32,
};

pub fn parse(instLine: []const u8) InstReloc {
    var isCond = false;
    var opcode: u5 = 0;
    var t: u5 = 0;
    var a: u5 = 0;
    var b: u5 = 0;
    var func11: u11 = 0;
    var immediate: u16 = 0;
    var label: ?[]const u8 = null;

    var iLine = std.mem.trim(u8, instLine, " \t");

    var inst = iLine[0 .. std.mem.findAny(u8, iLine, " \t") orelse {
        std.log.err("no space found in line: {s}", .{iLine});
        unreachable;
    }];
    if (inst[0] == '!') {
        isCond = true;
        inst = inst[1..];
    }
    const op = utils.getOpByName(inst) orelse {
        std.log.err("op not found: {s}", .{inst});
        std.process.exit(1);
    };
    opcode = op.opc;
    func11 = op.func11;

    iLine = iLine[std.mem.findAny(u8, iLine, " \t") orelse {
        std.log.err("no space found in line: {s}", .{iLine});
        std.process.exit(1);
    } ..];

    iLine = std.mem.trim(u8, iLine, " \t");

    var args = std.mem.splitAny(u8, iLine, ",");

    var i: usize = 0;
    while (args.next()) |arg| {
        if (op.fmt[i] == 't') {
            t = parseReg(arg);
        } else if (op.fmt[i] == 'a') {
            a = parseReg(arg);
        } else if (op.fmt[i] == 'b') {
            b = parseReg(arg);
        } else if (op.fmt[i] == 'i') {
            const val = valUtils.parse(arg);
            immediate = valUtils.lower(val.val);
            label = val.label;
        }
        i += 1;

        if (i >= op.fmt.len) break;
    }

    // if (isCond) std.debug.print("1\n", .{}) else std.debug.print("0\n", .{});
    // std.debug.print("{b:0>6}\n", .{opcode});
    // std.debug.print("{b:0>5}\n", .{t});
    // std.debug.print("{b:0>5}\n", .{a});
    // std.debug.print("{b:0>5}\n", .{b});
    // std.debug.print("{b:0>11}\n", .{func11});
    // std.debug.print("{b:0>16}\n", .{immediate});
    // std.debug.print("{any}\n", .{label});

    if (op.opType == 'R') {
        return InstReloc{ .bin = utils.buildR(isCond, opcode, t, a, b, func11), .label = label };
    } else if (op.opType == 'I') {
        return InstReloc{ .bin = utils.buildI(isCond, opcode, t, a, immediate), .label = label };
    } else {
        std.log.err("unable to generate binary for op: {s}", .{inst});
        std.process.exit(1);
    }
}
