const std = @import("std");

pub const ValOrLabel = struct {
    val: u32,
    label: ?[]const u8,
};

pub fn parse(valStr: []const u8) ValOrLabel {
    const trimmed = std.mem.trim(u8, valStr, " \t");

    if (trimmed[0] == '$') {
        std.log.err("expected value, found register: {s}\n", .{trimmed});
        std.process.exit(1);
    }

    if (std.mem.containsAtLeast(u8, trimmed, 1, ".")) {
        if (parseFloat(trimmed)) |flt| {
            const val = @as(u32, @bitCast(flt));
            return ValOrLabel{ .val = val, .label = null };
        } else {
            return ValOrLabel{ .val = 0, .label = trimmed };
        }
    } else if (parseIntAutoBase(u32, trimmed)) |parsed| {
        return ValOrLabel{ .val = parsed, .label = null };
    } else {
        return ValOrLabel{ .val = 0, .label = trimmed };
    }
}

fn parseIntAutoBase(T: type, valStr: []const u8) ?std.meta.Int(.unsigned, @typeInfo(T).int.bits) {
    const iT: type = std.meta.Int(.signed, @typeInfo(T).int.bits);
    const uT: type = std.meta.Int(.unsigned, @typeInfo(T).int.bits);

    var base: []const u8 = &[_]u8{0};
    if (valStr.len > 2) base = valStr[0..2];
    if (std.mem.eql(u8, base, "0x")) {
        return @as(uT, @bitCast(parseIntBase(uT, valStr[2..], 16) orelse {
            std.log.err("failed to parse hex value: {s}\n", .{valStr}); 
            std.process.exit(1); 
        }));
    } else if (std.mem.eql(u8, base, "0b")) {
        return @as(uT, @bitCast(parseIntBase(uT, valStr[2..], 2) orelse {
            std.log.err("failed to parse bin value: {s}\n", .{valStr}); 
            std.process.exit(1); 
        }));
    } else if (std.mem.eql(u8, base, "0o")) {
        return @as(uT, @bitCast(parseIntBase(uT, valStr[2..], 8) orelse {
            std.log.err("failed to parse octal value: {s}\n", .{valStr}); 
            std.process.exit(1); 
        }));
    } else if (valStr[0] == '-') {
        return @as(uT, @bitCast(parseIntBase(iT, valStr, 10) orelse { 
            std.log.err("failed to parse int value: {s}\n", .{valStr}); 
            std.process.exit(1);                                                                         
        }));
    } else if (std.fmt.parseInt(uT, valStr, 10) catch null) |parsed| {
        return @as(uT, @bitCast(parsed));
    } else {
        return null;
    }
}

fn parseIntBase(T: type, valStr: []const u8, base: u8) ?T {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    return std.fmt.parseInt(T, trimmed, base) catch return null;
}

pub fn parseWord(valStr: []const u8) ?u32 {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    return parseIntAutoBase(u32, trimmed);
}

pub fn parseHalf(valStr: []const u8) ?u16 {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    return parseIntAutoBase(u16, trimmed);
}

pub fn parseByte(valStr: []const u8) ?u8 {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    return parseIntAutoBase(u8, trimmed);
}

pub fn parseFloat(valStr: []const u8) ?f32 {
    const trimmed = std.mem.trim(u8, valStr, " \t");
    return std.fmt.parseFloat(f32, trimmed) catch return null;
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

pub fn asBytes(T: type, val: T) []const u8 {
    return std.mem.asBytes(&val);
}
