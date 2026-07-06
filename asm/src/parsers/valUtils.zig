const std = @import("std");

pub const ValOrLabel = struct {
    val: u32,
    label: ?[]const u8,
};

pub fn parse(valStr: []const u8) ValOrLabel {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    var base: []const u8 = &[_]u8{0};
    if (trimmed.len > 2) base = trimmed[0..2];

    if (trimmed[0] == '$') {
        std.log.err("expected value, found register: {s}\n", .{trimmed});
        std.process.exit(1);
    }

    var label: ?[]const u8 = null;
    var val: u32 = 0;

    if (std.mem.eql(u8, base, "0x")) {
        val = parseIntBase(u32, trimmed[2..], 16);
    } else if (std.mem.eql(u8, base, "0b")) {
        val = parseIntBase(u32, trimmed[2..], 2);
    } else if (std.mem.eql(u8, base, "0o")) {
        val = parseIntBase(u32, trimmed[2..], 8);
    } else if (std.mem.containsAtLeast(u8, trimmed, 1, ".")) {
        val = @as(u32, @bitCast(parseFloat(trimmed)));
    } else if (trimmed[0] == '-') {
        val = parseIntBase(i32, trimmed, 10);
    } else {
        if (std.fmt.parseInt(u32, trimmed, 10)) |parsed| {
            val = parsed;
        } else |_| {
            val = 0;
            label = trimmed;
        }
    }

    return ValOrLabel{ .val = val, .label = label };
}

pub fn parseIntBase(T: type, valStr: []const u8, base: u8) u32 {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    const val = std.fmt.parseInt(T, trimmed, base) catch |err| {
        std.log.err("parse int error: {any}\ninput: {s}\ntype: {any}", .{ err, trimmed, T });
        std.process.abort();
    };
    return @as(u32, @bitCast(val));
}

pub fn parseFloat(valStr: []const u8) f32 {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    return std.fmt.parseFloat(f32, trimmed) catch |err| {
        std.log.err("parse float error: {any}\ninput: {s}", .{ err, trimmed });
        std.process.abort();
    };
}

pub fn upper(val: u32) u16 {
    const trnc: u16 = @truncate((val >> 16) & 0xFFFF);
    return trnc;
}

pub fn lower(val: u32) u16 {
    const trnc: u16 = @truncate(val & 0xFFFF);
    return trnc;
}

pub fn signExtends(val: u32) bool {
    return lower(u32, val) & 0x8000 != 0;
}
