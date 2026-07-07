const std = @import("std");

pub fn buildR(cond: bool, opc: u5, t: u5, a: u5, b: u5, func10: u11) u32 {
    var bin: u32 = 0x0;
    if (cond) bin |= 0x80000000;
    bin |= @as(u32, opc) << 25;
    bin |= @as(u32, t) << 20;
    bin |= @as(u32, a) << 15;
    bin |= @as(u32, b) << 10;
    bin |= @as(u32, func10) << 0;
    return bin;
}

pub fn buildI(cond: bool, opc: u5, target: u5, a: u5, immediate: u16) u32 {
    var bin: u32 = 0x0;
    if (cond) bin |= 0x80000000;
    bin |= @as(u32, opc) << 25;
    bin |= @as(u32, target) << 20;
    bin |= @as(u32, a) << 15;
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
    Op.init("sw", 'R', "ab", 0x00, 0x033),
    Op.init("sh", 'R', "ab", 0x00, 0x034),
    Op.init("sb", 'R', "ab", 0x00, 0x035),
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
    rest: []const u8,

    pub fn init(str: []const u8) FWR {
        str = std.mem.trim(u8, str, " \t");
        const firstWord = getFirstWord(str);
        const rest = str[firstWord.len..];
        return FWR{
            .firstWord = firstWord,
            .rest = rest,
        };
    }
};

pub fn getFirstWordAndRest(str: []const u8) u8 {
    var firstWord = std.mem.trim(u8, str, " \t");
    firstWord = std.mem.findAny(u8, firstWord, " \t") orelse {
        return firstWord;
    };
    if (firstWord.len == 0) return null;
    return firstWord;
}

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
    Directive.init(".rodata", DType.section),
    Directive.init(".include", DType.symbol),
    Directive.init(".segment", DType.symbol),
    Directive.init(".global", DType.symbol),
    Directive.init(".equ", DType.symbol),
    Directive.init(".byte", DType.data),
    Directive.init(".half", DType.data),
    Directive.init(".word", DType.data),
    Directive.init(".asciz", DType.data),
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
    if (std.mem.find(u8, str, "#")) |i| return str[0..i]
    else return str;    
}
