const std = @import("std");
const main = @import("../main.zig");
const utils = @import("../utils.zig");

pub fn hasLabel(str: []const u8, global: bool) bool {
    const fwr = utils.FWR.init(str) orelse unreachable;
    if (std.mem.endsWith(u8, fwr.firstWord, ":")) {
        if (main.section) |section| {
            var offset: u32 = 0;
            if (section == .text) {
                offset = @divFloor(@as(u32, @intCast(main.o.text.items.len)), 2);
            } else if (section == .data) {
                offset = @divFloor(@as(u32, @intCast(main.o.data.items.len)), 2);
            }
            main.o.addLabel(fwr.firstWord[0 .. fwr.firstWord.len - 1], offset, section, global);
            if (fwr.rest) |rest| {
                utils.parseLine(rest);
            }
        } else {
            std.log.err("Error: Label outside of section {s}", .{fwr.firstWord});
            std.process.exit(1);
        }
        return true;
    } else return false;
}
