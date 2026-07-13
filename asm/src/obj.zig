const std = @import("std");
const main = @import("main.zig");

pub const ObjStruct = struct {
    fileName: []const u8 = "",
    segment: []const u8 = "",

    text: std.ArrayList(u8) = .empty,
    data: std.ArrayList(u8) = .empty,
    bss: std.ArrayList(u8) = .empty,

    labels: std.ArrayList(Label) = .empty,
    relocations: std.ArrayList(Relocation) = .empty,

    pub const section = enum { text, data, bss };
    pub const relocType = enum { val, inst, loadimm };

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

    pub fn addInst(self: *ObjStruct, inst: u32) void {
        const bytes: []const u8 = std.mem.asBytes(&inst);
        for (bytes) |byte| {
            const str = std.fmt.hex(byte);
            self.text.appendSlice(main.alloc, &str) catch unreachable;
        }
    }

    pub fn addData(self: *ObjStruct, bytes: []const u8) void {
        std.debug.print("raw: {x}\n", .{bytes});

        for (bytes) |byte| {
            const str = std.fmt.hex(byte);
            std.debug.print("hex: {x}\n", .{byte});
            std.debug.print("str: {s}\n\n", .{str});
            self.data.appendSlice(main.alloc, &str) catch unreachable;
        }
        
        return;
    }

    pub fn addRelocation(self: *ObjStruct, label: []const u8, rT: relocType, s: section, offset: u32) void {
        self.relocations.append(main.alloc, .{
            .offset = offset,
            .label = label,
            .section = s,
            .relocType = rT,
        }) catch unreachable;
    }

    pub fn addLabel(self: *ObjStruct, name: []const u8, offset: u32, s: section, global: bool) void {
        self.labels.append(main.alloc, .{
            .name = name,
            .offset = offset,
            .section = s,
            .global = global,
        }) catch unreachable;
    }
};
