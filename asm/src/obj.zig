const std = @import("std");
const main = @import("main.zig");

const ObjStruct = struct {
    fileName: []const u8 = "",
    segment: []const u8 = "",

    text: std.ArrayList(u8) = .empty,
    data: std.ArrayList(u8) = .empty,
    bss: std.ArrayList(u8) = .empty,

    symbols: std.ArrayList(Symbol) = .empty,
    relocations: std.ArrayList(Relocation) = .empty,

    pub const Symbol = struct {
        name: []const u8,
        offset: []const u8,
        section: []const u8,
        global: bool,
    };

    pub const Relocation = struct {
        offset: u32,
        symbol: []const u8,
        section: []const u8,
        type: enum { i, ui, li, ir, uir, lir },
    };

    pub fn addInst(inst: u32) void {
        const bytes = std.mem.asBytes(&inst); 

        for (bytes) |byte| {
            .text.appendSlice(main.alloc, std.fmt.hex(byte)) catch unreachable;
        }
    }
};

pub const o = ObjStruct{};
