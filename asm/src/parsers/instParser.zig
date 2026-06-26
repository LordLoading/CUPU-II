const std = @import("std");
const opUtils = @import("../opUtils.zig");

pub fn parse(instLine: []u8, allocator: std.mem.Allocator) i32 {
    var isCond = false;
    var opcode: u6 = 0;
    var t: u5 = 0;
    var a: u5 = 0;
    var b: u5 = 0;
    var immediate: u16 = 0;
    var func10: u10 = 0;

    var iLine = std.mem.trim(u8, instLine, " \t");

    var inst = allocator.dupe(u8, iLine[0 .. std.mem.find(u8, iLine, " \t") orelse iLine.len]) catch unreachable;
    defer allocator.free(inst);

    if (inst[0] == '!') {
        isCond = true;
        inst = inst[1..];
    }
    const op = opUtils.getOpByName(inst) orelse return 0;
    opcode = op.opc;
    func10 = op.func10;

    iLine = iLine[std.mem.find(u8, iLine, " \t") orelse 0 ..];
    iLine = std.mem.trim(u8, iLine, " \t");

    var args = std.mem.splitAny(u8, iLine, ",");

    var i: usize = 0;
    while (args.next()) |arg| {
        if (op.fmt[i] == 't') {
            t = opUtils.parseReg(arg);
        } else if (op.fmt[i] == 'a') {
            a = opUtils.parseReg(arg);
        } else if (op.fmt[i] == 'b') {
            b = opUtils.parseReg(arg);
        } else if (op.fmt[i] == 'i') {
            immediate = opUtils.parseImm(arg);
        }
        i += 1;

        if (i > op.fmt.len) break;
    }

    if (op.opType == 'R') {
        return opUtils.buildR(isCond, opcode, t, a, b, func10);
    } else if (op.opType == 'I') {
        return opUtils.buildI(isCond, opcode, t, a, immediate);
    }
}
