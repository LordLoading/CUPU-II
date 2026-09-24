.segment main

.text
addi $1, $0, 0x1234
addi $2, $0, 0xffff
uaddi $3, $0, 0xffff
addi $2, $2, 2
uaddi $4, $0, 0x80
sb $4, $3
lui $5, 0x1234
uori $5, $5, 0x5678
sw $4, $5
jal $0, $0, 12
