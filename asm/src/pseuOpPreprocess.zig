const std = @import("std");
const main = @import("main.zig");
const utils = @import("utils.zig");

pub const PseuOp = struct {
    name: []const u8,
    realOps: []const u8,
    paramRep: [][]const u8,

    pub fn init(name: []const u8, realOps: []const u8, paramRep: [][]const u8) PseuOp {
        return PseuOp{
            .name = name,
            .realOps = realOps,
            .paramRep = paramRep,
        };
    }
};

const pseuOpTable: []const PseuOp = &[_]PseuOp{
    PseuOp.init("li",
        \\lui %target %imm
        \\uori %target %target %imm
    , &.{ "target", "imm" }),
    PseuOp.init("la",
        \\lui %target %imm
        \\uori %target %target %imm
    , &.{ "target", "imm" }),
    //register ops
    PseuOp.init("mv",
        \\addi %target %src 0
    , &.{ "target", "src" }),
    PseuOp.init("neg",
        \\sub %target $0 %src
    , &.{ "target", "src" }),
    PseuOp.init("fneg",
        \\fsub %target $0 %src
    , &.{ "target", "src" }),
    //misc
    PseuOp.init("nop",
        \\add $0 $0 $0
    , &.{}),
    PseuOp.init("ret",
        \\jal $0 %ra 0
    , &.{"ra"}),
    //push
    PseuOp.init("pshb",
        \\sb $31 %data
        \\subi $31 $31 1
    , &.{"data"}),
    PseuOp.init("pshh",
        \\sh $31 %data
        \\subi $31 $31 2
    , &.{"data"}),
    PseuOp.init("pshw",
        \\sw $31 %data
        \\subi $31 $31 4
    , &.{"data"}),
    //pop
    PseuOp.init("popb",
        \\addi $31 $31 1
        \\lb %target $31
    , &.{"target"}),
    PseuOp.init("poph",
        \\addi $31 $31 2
        \\lh %target $31
    , &.{"target"}),
    PseuOp.init("popw",
        \\addi $31 $31 4
        \\lw %target $31
    , &.{"target"}),
    //frame pointer
    PseuOp.init("pshfp",
        \\sw $31 $30
        \\subi $31 $31 4
    , &.{}),
    PseuOp.init("popfp",
        \\addi $31 $31 4
        \\lw $30 $31
    , &.{}),
    PseuOp.init("setfp",
        \\addi $30 $31 0
    , &.{}),
    PseuOp.init("restsp",
        \\addi $31 $30 0
    , &.{}),
    PseuOp.init("allocframe",
        \\subi $31 $31 %size
    , &.{"size"}),
    PseuOp.init("freeframe",
        \\addi $31 $31 %size
    , &.{"size"}),
    //load absolute
    PseuOp.init("ldab",
        \\lui $29 %imm
        \\uori $29 $29 %imm
        \\lb %target $29
    , &.{ "target", "imm" }),
    PseuOp.init("ldah",
        \\lui $29 %imm
        \\uori $29 $29 %imm
        \\lh %target $29
    , &.{ "target", "imm" }),
    PseuOp.init("ldaw",
        \\lui $29 %imm
        \\uori $29 $29 %imm
        \\lw %target $29
    , &.{ "target", "imm" }),
    //store address
    PseuOp.init("stab",
        \\lui $29 %imm
        \\uori $29 $29 %imm
        \\sb $29 %data
    , &.{ "imm", "data" }),
    PseuOp.init("stah",
        \\lui $29 %imm
        \\uori $29 $29 %imm
        \\sh $29 %data
    , &.{ "imm", "data" }),
    PseuOp.init("staw",
        \\lui $29 %imm
        \\uori $29 $29 %imm
        \\sw $29 %data
    , &.{ "imm", "data" }),
};

pub fn getPseuOpByName(name: []const u8) ?PseuOp {
    for (pseuOpTable) |pseuOp| {
        if (std.mem.eql(u8, pseuOp.name, name)) {
            return pseuOp;
        }
    }
    return null;
}

pub fn expandPseuOps(original: []const u8) []const u8 {
    _ = main.alloc;
    const lines = std.mem.splitAny(u8, original, "\n");
    for (lines) |line| {
        line = std.mem.trim(u8, line, " \t");
        const tokens = std.mem.splitAny(u8, line, " \t");
        var isConditional = false;
        if (tokens[0][0] == ' ') isConditional = true;
    }
    return original;
}
