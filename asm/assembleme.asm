.segment main

.text
    !lui $1, -30 #comment
    ori $2, $0, test 
    and $3, $1, $2
    #lone comment

.data
    .word 11
    .half 0x1234
    .byte 0x12
    .byte 0o77
    .word 0
    .word 0
    .word 0
    .float 0.1234
