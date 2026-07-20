.segment main

.text
.global main: lui $1, toast.word
uori $1, $1, toast.word

.data
word: .word 0x12345678
str: .asciz "Hello, world!"
byte: .byte 0x12
