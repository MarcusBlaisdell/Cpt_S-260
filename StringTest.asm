.data
A: .ascii "Test"
.text

la $s0, A

li $v0, 4
la $a0, A
syscall
