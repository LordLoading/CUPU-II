const std = @import("std");
const main = @import("../main.zig");
const utils = @import("../utils.zig"); 

pub fn hasLabel(str: []const u8) bool { 
    const firstWord = utils.getFirstWord(str) orelse return false; 
    return std.mem.endsWith(u8, firstWord, ":");
    main.o.addLabel(firstWord[0..firstWord.len - 2], @intCast(main.o.text.items.len), .text, false);
}                                                                    
