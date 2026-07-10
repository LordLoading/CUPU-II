const std = @import("std");
const main = @import("../main.zig");
const utils = @import("../utils.zig");

pub fn hasLabel(str: []const u8) bool {
    const firstWord = utils.getFirstWord(str) orelse return false;
    if (std.mem.endsWith(u8, firstWord, ":")) {
        if (main.section) |section| {
            var offset: u32 = 0; 
            if (section == .text) { 
                offset = @divFloor(@as(u32, @intCast(main.o.text.items.len)), 2); 
            } else if (section == .data) { 
                offset = @divFloor(@as(u32, @intCast(main.o.data.items.len)), 2); 
            }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            main.o.addLabel(firstWord[0 .. firstWord.len - 1], offset, section, false);
        } else {
            std.log.err("Error: Label outside of section {s}", .{firstWord});
            std.process.exit(1);
        }
        return true;
    } else return false;
}
