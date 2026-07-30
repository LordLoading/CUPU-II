const std = @import("std");
const main = @import("main.zig");

pub const ObjStruct = struct {
    segment: []const u8 = "",

    text: []const u8 = "",
    data: []const u8 = "",
    bss: []const u8 = "",

    labels: []const Label = &[_]Label{},
    relocations: []const Relocation = &[_]Relocation{},
    constants: []const Constant = &[_]Constant{},

    pub const section = enum { text, data, bss };
    pub const relocType = enum { val, imm, uimm };

    pub const Label = struct {
        name: []const u8,
        offset: u32,
        section: section,
        global: bool,
    };

    pub const Relocation = struct {
        offset: u32,
        label: []const u8,
        section: section,
        relocType: relocType,
    };

    pub const Constant = struct {
        name: []const u8,
        value: u32,
    };

    pub fn addInst(inst: u32) void {
        const bytes: []const u8 = std.mem.asBytes(&inst);
        for (bytes) |byte| {
            const str = std.fmt.hex(byte);
            main.text.appendSlice(main.alloc, &str) catch unreachable;
        }
    }

    pub fn addData(bytes: []const u8) void {
        for (bytes) |byte| {
            const str = std.fmt.hex(byte);
            main.data.appendSlice(main.alloc, &str) catch unreachable;
        }
    }

    pub fn addRelocation(label: []const u8, rT: relocType, s: section, offset: u32) void {
        main.relocations.append(main.alloc, .{
            .offset = offset,
            .label = label,
            .section = s,
            .relocType = rT,
        }) catch unreachable;
    }

    pub fn addLabel(name: []const u8, offset: u32, s: section, global: bool) void {
        main.labels.append(main.alloc, .{
            .name = name,
            .offset = offset,
            .section = s,
            .global = global,
        }) catch unreachable;
    }
};
