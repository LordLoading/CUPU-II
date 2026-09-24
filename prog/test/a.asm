.segment main

.text
lui $1, 0x2000
uori $1, $1, 0x0002
lw $2, $1
jal $0, $0, 0
