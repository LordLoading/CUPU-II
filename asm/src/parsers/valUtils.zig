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

// for transparency, this function is written by ai
pub fn unescape(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var out: std.ArrayList(u8) = .empty; 
    errdefer out.deinit(allocator); 
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        const c = input[i];
        if (c != '\\') {
            try out.append(allocator, c);
            continue;
        }
        // We have a backslash; need the next byte.
        if (i + 1 >= input.len) return error.TrailingBackslash;
        i += 1;
        const next = input[i];
        switch (next) {
            'n'  => try out.append(allocator, '\n'),
            't'  => try out.append(allocator, '\t'),
            'r'  => try out.append(allocator, '\r'),
            '\\' => try out.append(allocator, '\\'),
            '\'' => try out.append(allocator, '\''),
            '"'  => try out.append(allocator, '"'),
            'x'  => {
                // \xHH  (two hex digits)
                if (i + 2 >= input.len) return error.InvalidEscape;
                const hi = try std.fmt.parseInt(u8, input[i + 1 .. i + 3], 16);
                try out.append(allocator, hi); 
                i += 2;
            },
            'u'  => {
                // \u{XXXX}  (braced unicode code point)
                i += 1;
                const close = std.mem.indexOfScalarPos(u8, input, i, '}') orelse
                    return error.InvalidEscape;
                const cp = try std.fmt.parseInt(u21, input[i..close], 16);
                var buf: [4]u8 = undefined;
                const len = std.unicode.utf8Encode(cp, &buf) catch
                    return error.InvalidCodePoint;
                try out.appendSlice(allocator, buf[0..len]);
                i = close; // the '}' is skipped; loop's i+=1 moves past it
            },
            else => return error.InvalidEscape,
        }
    }
    return out.toOwnedSlice(allocator);
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
