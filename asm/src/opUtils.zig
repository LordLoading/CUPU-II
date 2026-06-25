pub fn buildR(cond: bool, opc: u6, t: u5, a: u5, b: u5, func10: u10) u32 {
    var bin = 0x0;
    bin |= cond << 31;
    bin |= opc << 25;
    bin |= t << 20;
    bin |= a << 15;
    bin |= b << 10;
    bin |= func10 << 0;
    return bin;
}

pub fn buildI(cond: bool, opc: u6, target: u5, a: u5, immediate: u16) u32 {
    var bin = 0x0;
    bin |= cond << 31;
    bin |= opc << 25;
    bin |= target << 20;
    bin |= a << 15;
    bin |= immediate << 0;
    return bin;
}

const Op = struct {
    name: []u8,
    opType: []u8,
    fmt: []u8,
    opc: u6,
    func10: u10,

    pub fn init(name: []u8, opType: []u8, fmt: []u8, opc: u6, func10: u10) Op {
        return Op{
            .name = name,
            .opType = opType,
            .fmt = fmt,
            .opc = opc,
            .func10 = func10,
        };
    }
};

const opTable: []Op = .{
    //alu
    Op.init("add",  "R", "tab", 0x00, 0x000),
    Op.init("sub",  "R", "tab", 0x00, 0x001),
    Op.init("mul",  "R", "tab", 0x00, 0x002),
    Op.init("div",  "R", "tab", 0x00, 0x003),
    Op.init("or",   "R", "tab", 0x00, 0x004),
    Op.init("and",  "R", "tab", 0x00, 0x005),
    Op.init("xor",  "R", "tab", 0x00, 0x006),
    Op.init("not",  "R", "ta",  0x00, 0x007),
    Op.init("shl",  "R", "tab", 0x00, 0x008),
    Op.init("shr",  "R", "tab", 0x00, 0x009),
    Op.init("rem",  "R", "tab", 0x00, 0x00A),
    Op.init("mhi",  "R", "tab", 0x00, 0x00B),
    Op.init("ovrf", "R", "tab", 0x00, 0x00C),
    Op.init("unrf", "R", "tab", 0x00, 0x00D),
    //fpu
    Op.init("itof", "R", "ta",  0x00, 0x00E),
    Op.init("ftoi", "R", "ta",  0x00, 0x00F),
    Op.init("fadd", "R", "tab", 0x00, 0x010),
    Op.init("fsub", "R", "tab", 0x00, 0x011),
    Op.init("fmul", "R", "tab", 0x00, 0x012),
    Op.init("fdiv", "R", "tab", 0x00, 0x013),
    Op.init("sqrt", "R", "ta",  0x00, 0x014),
    Op.init("sin",  "R", "ta",  0x00, 0x015),
    Op.init("cos",  "R", "ta",  0x00, 0x016),
    Op.init("tan",  "R", "ta",  0x00, 0x017),
    //comparisons
    Op.init("eq",   "R", "ab",  0x00, 0x020),
    Op.init("neq",  "R", "ab",  0x00, 0x021),
    Op.init("gt",   "R", "ab",  0x00, 0x022),
    Op.init("gte",  "R", "ab",  0x00, 0x023),
    Op.init("lt",   "R", "ab",  0x00, 0x024),
    Op.init("lte",  "R", "ab",  0x00, 0x025),
    //memory access
    Op.init("lw",   "R", "ta",  0x00, 0x030),
    Op.init("lh",   "R", "ta",  0x00, 0x031),
    Op.init("lb",   "R", "ta",  0x00, 0x032),
    Op.init("sw",   "R", "ab",  0x00, 0x033),
    Op.init("sh",   "R", "ab",  0x00, 0x034),
    Op.init("sb",   "R", "ab",  0x00, 0x035),
    //immediate alu
    Op.init("addi", "I", "tai", 0x08, 0x000),
    Op.init("subi", "I", "tai", 0x09, 0x000),
    Op.init("muli", "I", "tai", 0x0A, 0x000),
    Op.init("divi", "I", "tai", 0x0B, 0x000),
    Op.init("ori",  "I", "tai", 0x0C, 0x000),
    Op.init("andi", "I", "tai", 0x0D, 0x000),
    Op.init("xori", "I", "tai", 0x0E, 0x000),
    Op.init("lui",  "I", "ti",  0x0F, 0x000),
    //jumps
    Op.init("jal",  "I", "tai", 0x10, 0x000),
    Op.init("jral", "I", "tai", 0x11, 0x000),
};
