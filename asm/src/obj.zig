const std = @import("std");
const main = @import("main.zig");

pub const ObjStruct = struct {
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

    pub fn addInst(self: *ObjStruct, inst: u32) void {
        std.debug.print("inst: 0x{x}\n", .{inst});
        const bytes: []const u8 = std.mem.asBytes(&inst);
        std.debug.print("bytes: {x}\n", .{bytes});
        for (bytes) |byte| {
            const str = std.fmt.hex(byte);
            self.text.appendSlice(main.alloc, &str) catch unreachable;
        }
    }
};
