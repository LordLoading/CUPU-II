.segment main

.text
    addi $4, $0, 0x1234
    !lui $1, -30 #comment
    ori $2, $0, test 
    and $3, $1, $2
    balls: ori $4, $0, test 
    #lone comment

.data
    .asciz "Hello World" 
    .global wrd: .word 0x10004443
    .half 0x1234
    .byte 0x12
    .byte 0o77
    .word 0
    .float 0.1234
    .ascii "\\n" 
