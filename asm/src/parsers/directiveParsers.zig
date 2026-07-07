const std = @import("std");
const ObjStruct = @import("../obj.zig").ObjStruct;
const main = @import("../main.zig"); 
const utils = @import("../utils.zig"); 
const valUtils = @import("valUtils.zig"); 

pub fn parse(directive: utils.Directive, trimmed: []const u8) void { 
    if (directive.t == .section) main.section = directive.name
    else if (directive.t == .data) parseData(directive, trimmed); 
}                                                                      

fn parseData(directive: utils.Directive, valStr: []const u8) void { 
    if (std.mem.eql(u8, directive.name, ".byte")) { 
        const val = valUtils.parseByte(valStr); 
        main.o.addData(valUtils.asBytes(@TypeOf(val), val));                                                 
    }
}
