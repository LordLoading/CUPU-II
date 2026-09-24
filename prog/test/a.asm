.segment main

.text
# addi $1, $0, 0x1234
# addi $2, $0, 0xffff
# uaddi $3, $0, 0xffff
# addi $2, $2, 2
# sb $0, 0x0, $3
# jal $0, $0, 12

sb $0, 0x0, $0
