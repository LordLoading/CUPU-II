const std = @import("std");

pub fn parse(regStr: []u8) u5 {
    const trimmed = std.mem.trim(u8, regStr, " \t$");
    return try std.fmt.parseInt(u5, trimmed, 10);
}
