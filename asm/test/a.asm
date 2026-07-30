.segment main

.text
.global main: lui $1, toast.word
uori $1, $1, toast.word
.equ pi 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679

.data
word: .word 0x12345678
str: .asciz "Hello, world!"
byte: .byte 0x12
