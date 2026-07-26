.segment toast

.text
.global moan: lui $1, 0x1234
uori $1, $1, 0x5678
lui $1, main.pi
uori $1, $1, main.pi

.data
word: .word 0x12345678
str: .asciz "Hello, world!"
byte: .byte 0x12
