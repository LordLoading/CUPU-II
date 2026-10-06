.segment main

.equ keyBuf 0x20000004
.equ countTo 0x200
.equ display 0x20010000

.text
addi $2, $0, countTo
addi $3, $0, loop1
loop1:
addi $1, $1, 1
neq $1, $2
!jal $0, $0
addi $3, $0, loop2
lui $2, keyBuf
uaddi $2, $2, keyBuf
lui $31, display
uaddi $31, $31, display
add $1, $0, $0
loop2:
lb $4, $2
neq $4, $0
!add $1, $4, $0
!sb $2, $4
!sb $31, $4
!addi $31, $31, 1
jal $0, $3



