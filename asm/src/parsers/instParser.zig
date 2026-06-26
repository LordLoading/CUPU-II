const std = @import("std");
const opUtils = @import("../opUtils.zig");
const parseReg = @import("regParser.zig").parse;

pub fn parse(instLine: []const u8) u32 {
    var isCond = false;
    var opcode: u5 = 0;
    var t: u5 = 0;
    var a: u5 = 0;
    var b: u5 = 0;
    var func11: u11 = 0;
    var immediate: u16 = 0;

    var iLine = std.mem.trim(u8, instLine, " \t");
    std.debug.print("iLine: {s}\n", .{iLine});

    var inst = iLine[0 .. std.mem.findAny(u8, iLine, " \t") orelse {
        std.log.err("no space found in line: {s}", .{iLine});
        unreachable;
    }];

    if (inst[0] == '!') {
        isCond = true;
        inst = inst[1..];
    }
    const op = opUtils.getOpByName(inst) orelse {
        std.log.err("op not found: {s}", .{inst});
        unreachable;
    };
    opcode = op.opc;
    func11 = op.func11;

    iLine = iLine[std.mem.findAny(u8, iLine, " \t") orelse {
        std.log.err("no space found in line: {s}", .{iLine});
        unreachable;
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
            // immediate = opUtils.parseImm(arg);
            immediate = std.fmt.parseInt(u16, arg, 10) catch 0;
        }
        i += 1;

        if (i > op.fmt.len) break;
    }

    if (isCond) std.debug.print("1\n", .{}) else std.debug.print("0\n", .{});
    std.debug.print("{b:0>6}\n", .{opcode});
    std.debug.print("{b:0>5}\n", .{t});
    std.debug.print("{b:0>5}\n", .{a});
    std.debug.print("{b:0>5}\n", .{b});
    std.debug.print("{b:0>11}\n", .{func11});
    std.debug.print("{b:0>16}\n", .{immediate});

    if (op.opType == 'R') {
        return opUtils.buildR(isCond, opcode, t, a, b, func11);
    } else if (op.opType == 'I') {
        return opUtils.buildI(isCond, opcode, t, a, immediate);
    } else {
        std.log.err("unable to generate binary for op: {s}", .{inst});
        unreachable;
    }
}
