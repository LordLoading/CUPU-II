.segment main

.equ display 0x20010000
.equ size 160
.equ displaySize 256

# x = $1
# y = $2
# target address = $3
# value = $4

.text
lui $8, display
uaddi $8, $8, display
uaddi $9, $0, img
uaddi $10, $0, size
uaddi $11, $0, displaySize

loop:
jal $31, $0, copyPixel

addi $1, $1, 1
gt $1, $10
!add $1, $0, $0
!addi $2, $2, 1
jal $0, $0, loop



copyPixel:
# red
jal $30, $0, setupReadAddress
lb $4, $3

jal $30, $0, setupWriteAddress
sb $3, $4

# green
jal $30, $0, setupReadAddress
addi $3, $3, 1
lb $4, $3

jal $30, $0, setupWriteAddress
addi $3, $3, 1
sb $3, $4

# blue
jal $30, $0, setupReadAddress
addi $3, $3, 2
lb $4, $3

jal $30, $0, setupWriteAddress
addi $3, $3, 2
sb $3, $4

jal $0, $31, 0



setupReadAddress:
mul $3, $2, $10
add $3, $3, $1
muli $3, $3, 3
add $3, $3, $9
jal $0, $30, 0



setupWriteAddress:
mul $3, $2, $11
add $3, $3, $1
muli $3, $3, 3
add $3, $3, $8
jal $0, $30, 0



.data
img:
