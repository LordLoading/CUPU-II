const std = @import("std");

pub fn parse(regStr: []const u8) u5 {
    if (!std.mem.containsAtLeast(u8, regStr, 1, "$")) {
        std.log.err("expected register, found: {s}", .{regStr});
        std.process.exit(1);
    }

    const trimmed = std.mem.trim(u8, regStr, " \t$");
    return std.fmt.parseInt(u5, trimmed, 10) catch |err| {
        std.log.err("parse reg error: {any}", .{err});
        std.process.exit(1);
    };
}
