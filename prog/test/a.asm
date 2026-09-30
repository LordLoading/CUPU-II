.segment main

.text
addi $2, $0, 0x2000
addi $3, $0, loop1
loop1:
addi $1, $1, 1
neq $1, $2
!jal $0, $0
loop2:
addi $3, $0, loop2
jal $0, $3

