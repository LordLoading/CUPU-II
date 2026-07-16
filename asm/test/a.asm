.segment main
.import b

.text
.global main: lui $1, 0x1234
uori $1, $1, 0x5678

.data
word: .word 0x12345678
str: .asciz "Hello, world!"
byte: .byte 0x12
