# CUPU-II CPU/circuit self-test
#
# Assemble with: ./assemble.sh prog/test
# Load out/out.bin into the Logisim test memory at address 0.
#
# End state:
#   $20 = number of checks that passed
#   $21 = number of checks that ran
#   $22 = 1 if every check passed, 0 otherwise
#
# The memory checks at the end use mem_area in .data and require data memory
# to be connected to the CPU's data_in/data_out/address/read/write pins.

.segment main

.text
_start:
    addi $20, $0, 0
    addi $21, $0, 0
    addi $22, $0, 0

    # Float bank: $10=3.0, $11=4.0, $12=7.0, $13=12.0, $14=9.0, $15=1.0
    addi $1, $0, 1
    itof $15, $1
    addi $1, $0, 3
    itof $10, $1
    addi $1, $0, 4
    itof $11, $1
    addi $1, $0, 7
    itof $12, $1
    addi $1, $0, 9
    itof $14, $1
    addi $1, $0, 12
    itof $13, $1

    # add: 7 + 5 = 12
    addi $1, $0, 7
    addi $2, $0, 5
    add $3, $1, $2
    addi $4, $0, 12
    eq $3, $4
    jal $18, $0, cond_check

    # sub: 7 - 5 = 2
    sub $3, $1, $2
    addi $4, $0, 2
    eq $3, $4
    jal $18, $0, cond_check

    # mul: 7 * 5 = 35
    mul $3, $1, $2
    addi $4, $0, 35
    eq $3, $4
    jal $18, $0, cond_check

    # div: 35 / 5 = 7
    addi $1, $0, 35
    div $3, $1, $2
    addi $4, $0, 7
    eq $3, $4
    jal $18, $0, cond_check

    # or: 0x0F0F | 0x00FF = 0x0FFF
    addi $1, $0, 0x0F0F
    addi $2, $0, 0x00FF
    or $3, $1, $2
    addi $4, $0, 0x0FFF
    eq $3, $4
    jal $18, $0, cond_check

    # and: 0x0F0F & 0x00FF = 0x000F
    and $3, $1, $2
    addi $4, $0, 0x000F
    eq $3, $4
    jal $18, $0, cond_check

    # xor: 0x0F0F ^ 0x00FF = 0x0FF0
    xor $3, $1, $2
    addi $4, $0, 0x0FF0
    eq $3, $4
    jal $18, $0, cond_check

    # not: ~0x0F0F = 0xFFFFF0F0
    addi $1, $0, 0x0F0F
    not $3, $1
    lui $4, 0xFFFF
    uori $4, $4, 0xF0F0
    eq $3, $4
    jal $18, $0, cond_check

    # shl: 1 << 4 = 16
    addi $1, $0, 1
    addi $2, $0, 4
    shl $3, $1, $2
    addi $4, $0, 16
    eq $3, $4
    jal $18, $0, cond_check

    # shr: 0x80 >> 3 = 0x10
    addi $1, $0, 0x80
    addi $2, $0, 3
    shr $3, $1, $2
    addi $4, $0, 0x10
    eq $3, $4
    jal $18, $0, cond_check

    # rem: 17 % 5 = 2
    addi $1, $0, 17
    addi $2, $0, 5
    rem $3, $1, $2
    addi $4, $0, 2
    eq $3, $4
    jal $18, $0, cond_check

    # mhi: (0x10000 * 0x10000) >> 32 = 1
    lui $1, 0x0001
    lui $2, 0x0001
    mhi $3, $1, $2
    addi $4, $0, 1
    eq $3, $4
    jal $18, $0, cond_check

    # ovrf: 0xFFFFFFFF + 0 with carry-in = 1
    addi $1, $0, -1
    addi $2, $0, 0
    ovrf $3, $1, $2
    addi $4, $0, 1
    eq $3, $4
    jal $18, $0, cond_check

    # unrf: 0 - 1 with borrow-in = 1
    addi $1, $0, 0
    addi $2, $0, 1
    unrf $3, $1, $2
    addi $4, $0, 1
    eq $3, $4
    jal $18, $0, cond_check

    # addi: 10 + 5 = 15
    addi $1, $0, 10
    addi $3, $1, 5
    addi $4, $0, 15
    eq $3, $4
    jal $18, $0, cond_check

    # subi: 10 - 5 = 5
    subi $3, $1, 5
    addi $4, $0, 5
    eq $3, $4
    jal $18, $0, cond_check

    # muli: 10 * 5 = 50
    muli $3, $1, 5
    addi $4, $0, 50
    eq $3, $4
    jal $18, $0, cond_check

    # divi: 20 / 5 = 4
    addi $1, $0, 20
    divi $3, $1, 5
    addi $4, $0, 4
    eq $3, $4
    jal $18, $0, cond_check

    # ori: 0x0F0F | 0x00FF = 0x0FFF
    addi $1, $0, 0x0F0F
    ori $3, $1, 0x00FF
    addi $4, $0, 0x0FFF
    eq $3, $4
    jal $18, $0, cond_check

    # andi: 0x0F0F & 0x00FF = 0x000F
    andi $3, $1, 0x00FF
    addi $4, $0, 0x000F
    eq $3, $4
    jal $18, $0, cond_check

    # xori: 0x0F0F ^ 0x00FF = 0x0FF0
    xori $3, $1, 0x00FF
    addi $4, $0, 0x0FF0
    eq $3, $4
    jal $18, $0, cond_check

    # lui: 0x1234 << 16 = 0x12340000
    lui $3, 0x1234
    addi $4, $0, 0x1234
    addi $5, $0, 16
    shl $4, $4, $5
    eq $3, $4
    jal $18, $0, cond_check

    # uaddi: 10 + 5 = 15
    addi $1, $0, 10
    uaddi $3, $1, 5
    addi $4, $0, 15
    eq $3, $4
    jal $18, $0, cond_check

    # usubi: 10 - 5 = 5
    usubi $3, $1, 5
    addi $4, $0, 5
    eq $3, $4
    jal $18, $0, cond_check

    # umuli: 10 * 5 = 50
    umuli $3, $1, 5
    addi $4, $0, 50
    eq $3, $4
    jal $18, $0, cond_check

    # udivi: 20 / 5 = 4
    addi $1, $0, 20
    udivi $3, $1, 5
    addi $4, $0, 4
    eq $3, $4
    jal $18, $0, cond_check

    # uori: 0x0F0F | 0x00FF = 0x0FFF
    addi $1, $0, 0x0F0F
    uori $3, $1, 0x00FF
    addi $4, $0, 0x0FFF
    eq $3, $4
    jal $18, $0, cond_check

    # uandi: 0x0F0F & 0x00FF = 0x000F
    uandi $3, $1, 0x00FF
    addi $4, $0, 0x000F
    eq $3, $4
    jal $18, $0, cond_check

    # uxori: 0x0F0F ^ 0x00FF = 0x0FF0
    uxori $3, $1, 0x00FF
    addi $4, $0, 0x0FF0
    eq $3, $4
    jal $18, $0, cond_check

    # itof: 3 -> 0x40400000
    addi $1, $0, 3
    itof $3, $1
    lui $4, 0x4040
    eq $3, $4
    jal $18, $0, cond_check

    # ftoi: 3.0 -> 3
    addi $1, $0, 3
    itof $2, $1
    ftoi $3, $2
    addi $4, $0, 3
    eq $3, $4
    jal $18, $0, cond_check

    # fadd: 3.0 + 4.0 = 7.0
    fadd $3, $10, $11
    eq $3, $12
    jal $18, $0, cond_check

    # fsub: 7.0 - 3.0 = 4.0
    fsub $3, $12, $10
    eq $3, $11
    jal $18, $0, cond_check

    # fmul: 3.0 * 4.0 = 12.0
    fmul $3, $10, $11
    eq $3, $13
    jal $18, $0, cond_check

    # fdiv: 12.0 / 4.0 = 3.0
    fdiv $3, $13, $11
    eq $3, $10
    jal $18, $0, cond_check

    # sqrt: sqrt(9.0) = 3.0
    sqrt $3, $14
    eq $3, $10
    jal $18, $0, cond_check

    # sin: sin(0.0) = 0.0
    sin $3, $0
    eq $3, $0
    jal $18, $0, cond_check

    # cos: cos(0.0) = 1.0
    cos $3, $0
    eq $3, $15
    jal $18, $0, cond_check

    # tan: tan(0.0) = 0.0
    tan $3, $0
    eq $3, $0
    jal $18, $0, cond_check

    # integer comparisons
    addi $1, $0, 5
    addi $2, $0, 5
    eq $1, $2
    jal $18, $0, cond_check

    addi $2, $0, 4
    neq $1, $2
    jal $18, $0, cond_check

    gt $1, $2
    jal $18, $0, cond_check

    addi $2, $0, 5
    gte $1, $2
    jal $18, $0, cond_check

    addi $1, $0, 4
    lt $1, $2
    jal $18, $0, cond_check

    addi $1, $0, 5
    lte $1, $2
    jal $18, $0, cond_check

    # float comparisons
    feq $10, $10
    jal $18, $0, cond_check

    fneq $10, $11
    jal $18, $0, cond_check

    fgt $11, $10
    jal $18, $0, cond_check

    fgte $10, $10
    jal $18, $0, cond_check

    flt $10, $11
    jal $18, $0, cond_check

    flte $10, $10
    jal $18, $0, cond_check

    # false condition: the conditional addi must not execute
    addi $1, $0, 5
    addi $2, $0, 4
    eq $1, $2
    addi $3, $0, 0
    !addi $3, $3, 1
    addi $1, $3, 0
    addi $2, $0, 0
    eq $1, $2
    jal $18, $0, cond_check

    # absolute jump and link
    addi $19, $0, 0
    jal $18, $0, jump_sub
    addi $1, $19, 0
    addi $2, $0, 1
    eq $1, $2
    jal $18, $0, cond_check

    # relative jump: skip the next instruction (8 bytes)
    addi $19, $0, 0
    jral $0, $0, 8
    addi $19, $0, 1
    addi $1, $19, 0
    addi $2, $0, 0
    eq $1, $2
    jal $18, $0, cond_check

    # memory: byte
    lui $2, mem_area
    uori $2, $2, mem_area
    addi $1, $0, 0x7F
    sb $2, $1
    lb $3, $2
    addi $4, $0, 0x7F
    eq $3, $4
    jal $18, $0, cond_check

    # memory: halfword at mem_area+2
    addi $2, $2, 2
    addi $1, $0, 0x1234
    sh $2, $1
    lh $3, $2
    addi $4, $0, 0x1234
    eq $3, $4
    jal $18, $0, cond_check

    # memory: word at mem_area+4
    addi $2, $2, 2
    lui $1, 0x1234
    uori $1, $1, 0x5678
    sw $2, $1
    lw $3, $2
    lui $4, 0x1234
    uori $4, $4, 0x5678
    eq $3, $4
    jal $18, $0, cond_check

    # all checks passed -> $22 = 1
    eq $20, $21
    !addi $22, $0, 1
    hlt

# Increment total and pass counters. The caller sets the condition flag first.
cond_check:
    !addi $20, $20, 1
    addi $21, $21, 1
    jal $0, $18, 0

jump_sub:
    addi $19, $19, 1
    jal $0, $18, 0

.data
mem_area:
    .word 0
    .word 0
