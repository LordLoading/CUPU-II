const std = @import("std");
const main = @import("../main.zig");
const utils = @import("../utils.zig"); 

pub fn hasLabel(str: []const u8) bool { 
    const firstWord = utils.getFirstWord(str) orelse return false; 
    return std.mem.endsWith(u8, firstWord, ":");
}                                                                    
