const std = @import("std");
const labelUtils = @import("parsers/labelUtils.zig");
const parseDirective = @import("parsers/directiveParsers.zig").parse;
const main = @import("main.zig");
const parseInst = @import("parsers/instParser.zig").parse;
const ObjStruct = @import("obj.zig").ObjStruct;

pub fn parseLine(line: []const u8) void {
    const trimmed = std.mem.trim(u8, line, " \t");

    if (labelUtils.hasLabel(trimmed, false)) {
        return;
    }

    if (getFirstWord(trimmed)) |firstWord| {
        if (getDirectiveByName(firstWord)) |directive| {
            parseDirective(directive, trimmed);
            return;
        }

        if (getOpByName(std.mem.trim(u8, firstWord, "!"))) |op| {
            if (main.section != .text) {
                std.log.err("Error: instruction outside of text section: '{s}'", .{trimmed});
                std.process.exit(1);
            }
            const inst = parseInst(trimmed);
            if (inst.label) |label| {
                if (std.mem.eql(u8, op.name, "lui")) {
                    ObjStruct.addRelocation(label, .uimm, .text, @divFloor(@as(u32, @truncate(main.text.items.len)), 2));
                } else {
                    ObjStruct.addRelocation(label, .imm, .text, @divFloor(@as(u32, @truncate(main.text.items.len)), 2));
                }
            }
            ObjStruct.addInst(inst.bin);
        }
    }
}

pub fn buildR(cond: bool, opc: u5, t: u5, a: u5, b: u5, func11: u11) u32 {
    var bin: u32 = 0x0;
    if (cond) bin |= 0x80000000;
    bin |= @as(u32, opc) << 26;
    bin |= @as(u32, t) << 21;
    bin |= @as(u32, a) << 16;
    bin |= @as(u32, b) << 11;
    bin |= @as(u32, func11) << 0;
    return bin;
}

pub fn buildI(cond: bool, opc: u5, target: u5, a: u5, immediate: u16) u32 {
    var bin: u32 = 0x0;
    if (cond) bin |= 0x80000000;
    bin |= @as(u32, opc) << 26;
    bin |= @as(u32, target) << 21;
    bin |= @as(u32, a) << 16;
    bin |= @as(u32, immediate) << 0;
    return bin;
}

pub const Op = struct {
    name: []const u8,
    opType: u8,
    fmt: []const u8,
    opc: u5,
    func11: u11,

    pub fn init(name: []const u8, opType: u8, fmt: []const u8, opc: u5, func11: u11) Op {
        return Op{
            .name = name,
            .opType = opType,
            .fmt = fmt,
            .opc = opc,
            .func11 = func11,
        };
    }
};

const opTable: []const Op = &[_]Op{
    //alu
    Op.init("add", 'R', "tab", 0x00, 0x000),
    Op.init("sub", 'R', "tab", 0x00, 0x001),
    Op.init("mul", 'R', "tab", 0x00, 0x002),
    Op.init("div", 'R', "tab", 0x00, 0x003),
    Op.init("or", 'R', "tab", 0x00, 0x004),
    Op.init("and", 'R', "tab", 0x00, 0x005),
    Op.init("xor", 'R', "tab", 0x00, 0x006),
    Op.init("not", 'R', "ta", 0x00, 0x007),
    Op.init("shl", 'R', "tab", 0x00, 0x008),
    Op.init("shr", 'R', "tab", 0x00, 0x009),
    Op.init("rem", 'R', "tab", 0x00, 0x00A),
    Op.init("mhi", 'R', "tab", 0x00, 0x00B),
    Op.init("ovrf", 'R', "tab", 0x00, 0x00C),
    Op.init("unrf", 'R', "tab", 0x00, 0x00D),
    //fpu
    Op.init("itof", 'R', "ta", 0x00, 0x00E),
    Op.init("ftoi", 'R', "ta", 0x00, 0x00F),
    Op.init("fadd", 'R', "tab", 0x00, 0x010),
    Op.init("fsub", 'R', "tab", 0x00, 0x011),
    Op.init("fmul", 'R', "tab", 0x00, 0x012),
    Op.init("fdiv", 'R', "tab", 0x00, 0x013),
    Op.init("sqrt", 'R', "ta", 0x00, 0x014),
    Op.init("sin", 'R', "ta", 0x00, 0x015),
    Op.init("cos", 'R', "ta", 0x00, 0x016),
    Op.init("tan", 'R', "ta", 0x00, 0x017),
    //comparisons
    Op.init("eq", 'R', "ab", 0x00, 0x020),
    Op.init("neq", 'R', "ab", 0x00, 0x021),
    Op.init("gt", 'R', "ab", 0x00, 0x022),
    Op.init("gte", 'R', "ab", 0x00, 0x023),
    Op.init("lt", 'R', "ab", 0x00, 0x024),
    Op.init("lte", 'R', "ab", 0x00, 0x025),
    //memory access
    Op.init("lw", 'R', "ta", 0x00, 0x030),
    Op.init("lh", 'R', "ta", 0x00, 0x031),
    Op.init("lb", 'R', "ta", 0x00, 0x032),
    Op.init("sw", 'R', "at", 0x00, 0x033),
    Op.init("sh", 'R', "at", 0x00, 0x034),
    Op.init("sb", 'R', "at", 0x00, 0x035),
    //idk
    Op.init("hlt", 'R', "", 0x00, 0x040),
    //immediate alu
    Op.init("addi", 'I', "tai", 0x08, 0x000),
    Op.init("subi", 'I', "tai", 0x09, 0x000),
    Op.init("muli", 'I', "tai", 0x0A, 0x000),
    Op.init("divi", 'I', "tai", 0x0B, 0x000),
    Op.init("ori", 'I', "tai", 0x0C, 0x000),
    Op.init("andi", 'I', "tai", 0x0D, 0x000),
    Op.init("xori", 'I', "tai", 0x0E, 0x000),
    Op.init("lui", 'I', "ti", 0x0F, 0x000),
    //jumps
    Op.init("jal", 'I', "tai", 0x10, 0x000),
    Op.init("jral", 'I', "tai", 0x11, 0x000),
    //unsigned immediate alu
    Op.init("uaddi", 'I', "tai", 0x18, 0x000),
    Op.init("usubi", 'I', "tai", 0x19, 0x000),
    Op.init("umuli", 'I', "tai", 0x1A, 0x000),
    Op.init("udivi", 'I', "tai", 0x1B, 0x000),
    Op.init("uori", 'I', "tai", 0x1C, 0x000),
    Op.init("uandi", 'I', "tai", 0x1D, 0x000),
    Op.init("uxori", 'I', "tai", 0x1E, 0x000),
};

pub fn getOpByName(name: []const u8) ?Op {
    for (opTable) |op| {
        if (std.mem.eql(u8, op.name, name)) {
            return op;
        }
    }
    return null;
}

pub fn getFirstWord(str: []const u8) ?[]const u8 {
    var firstWord = std.mem.trim(u8, str, " \t");
    firstWord = firstWord[0 .. std.mem.findAny(u8, firstWord, " \t") orelse {
        return firstWord;
    }];
    firstWord = std.mem.trim(u8, firstWord, " \t");
    if (firstWord.len == 0) return null;
    return firstWord;
}

pub const FWR = struct {
    firstWord: []const u8,
    rest: ?[]const u8,

    pub fn init(inStr: []const u8) ?FWR {
        const str = std.mem.trim(u8, inStr, " \t");
        const firstWord = getFirstWord(str) orelse return null;
        if (firstWord.len == str.len) return FWR{ .firstWord = firstWord, .rest = null };
        const rest = std.mem.trim(u8, str[firstWord.len..], " \t");
        return FWR{
            .firstWord = firstWord,
            .rest = rest,
        };
    }
};

const DType = enum { section, symbol, data };

pub const Directive = struct {
    name: []const u8,
    t: DType,

    pub fn init(name: []const u8, t: DType) Directive {
        return Directive{
            .name = name,
            .t = t,
        };
    }
};

const directiveTable: []const Directive = &[_]Directive{
    Directive.init(".text", DType.section),
    Directive.init(".data", DType.section),
    Directive.init(".bss", DType.section),
    Directive.init(".segment", DType.symbol),
    Directive.init(".global", DType.symbol),
    Directive.init(".equ", DType.symbol),
    Directive.init(".byte", DType.data),
    Directive.init(".half", DType.data),
    Directive.init(".word", DType.data),
    Directive.init(".float", DType.data),
    Directive.init(".asciz", DType.data),
    Directive.init(".ascii", DType.data),
};

pub fn getDirectiveByName(name: []const u8) ?Directive {
    for (directiveTable) |directive| {
        if (std.mem.eql(u8, directive.name, name)) {
            return directive;
        }
    }
    return null;
}

pub fn trimComment(str: []const u8) []const u8 {
    if (std.mem.findAny(u8, str, "#;")) |i| return str[0..i] else return str;
}
