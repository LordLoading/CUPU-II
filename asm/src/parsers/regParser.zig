const std = @import("std");

pub fn parse(regStr: []const u8) u5 {
    const trimmed = std.mem.trim(u8, regStr, " \t$");
    return std.fmt.parseInt(u5, trimmed, 10) catch |err| {
        std.log.err("parse reg error: {any}", .{err});
        unreachable;
    };
}
