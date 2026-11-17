const std = @import("std");
const main = @import("main.zig");
const utils = @import("utils.zig");
const valUtils = @import("parsers/valUtils.zig");

pub const PseuOp = struct {
    name: []const u8,
    realOps: []const u8,
    params: []const []const u8,

    pub fn init(name: []const u8, realOps: []const u8, paramRep: []const []const u8) PseuOp {
        return PseuOp{
            .name = name,
            .realOps = realOps,
            .params = paramRep,
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
        \\jal $0 $28 0
    , &.{}),
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
    const alloc = main.alloc;
    var expanded: std.ArrayList(u8) = .empty;
    defer expanded.deinit(alloc);

    var lines = std.mem.splitScalar(u8, original, '\n');
    while (lines.next()) |rawLine| {
        const line = std.mem.trim(u8, utils.trimComment(rawLine), " \t\r");

        var tokens = std.mem.tokenizeAny(u8, line, " \t,");
        var mnemonic = tokens.next() orelse {
            expanded.append(alloc, '\n') catch unreachable;
            continue;
        };

        var isConditional = false;
        if (mnemonic.len > 0 and mnemonic[0] == '!') {
            isConditional = true;
            mnemonic = mnemonic[1..];
        }

        const pseuOp = getPseuOpByName(mnemonic) orelse {
            expanded.appendSlice(alloc, line) catch unreachable;
            expanded.append(alloc, '\n') catch unreachable;
            continue;
        };

        var replacementString = pseuOp.realOps;

        for (pseuOp.params) |param| {
            const arg = tokens.next() orelse "";

            if (std.mem.eql(u8, param, "imm") and arg.len > 0) {
                const val = valUtils.parse(arg);
                if (val.label == null) {
                    replacementString = replaceImmediate(alloc, replacementString, val.val);
                    continue;
                }
            }

            const needle = std.mem.concat(alloc, u8, &.{ "%", param }) catch unreachable;
            replacementString = std.mem.replaceOwned(
                u8,
                alloc,
                replacementString,
                needle,
                arg,
            ) catch unreachable;
        }

        var replacementLines = std.mem.splitScalar(u8, replacementString, '\n');
        while (replacementLines.next()) |replacementLine| {
            if (isConditional) expanded.append(alloc, '!') catch unreachable;
            expanded.appendSlice(alloc, replacementLine) catch unreachable;
            expanded.append(alloc, '\n') catch unreachable;
        }
    }

    return expanded.toOwnedSlice(alloc) catch unreachable;
}

fn replaceImmediate(alloc: std.mem.Allocator, template: []const u8, value: u32) []const u8 {
    const hi = std.fmt.allocPrint(alloc, "0x{X}", .{valUtils.upper(value)}) catch unreachable;
    const lo = std.fmt.allocPrint(alloc, "0x{X}", .{valUtils.lower(value)}) catch unreachable;

    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(alloc);

    var lines = std.mem.splitScalar(u8, template, '\n');
    var first = true;
    while (lines.next()) |line| {
        if (!first) out.append(alloc, '\n') catch unreachable;
        first = false;

        const trimmed = std.mem.trimStart(u8, line, " \t");
        const replacement = if (std.mem.startsWith(u8, trimmed, "lui ")) hi else lo;
        const replaced = std.mem.replaceOwned(u8, alloc, line, "%imm", replacement) catch unreachable;
        out.appendSlice(alloc, replaced) catch unreachable;
    }

    return out.toOwnedSlice(alloc) catch unreachable;
}
