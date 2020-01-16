.text
li $a0, 0
fib:
  bgt $a0, 1, fib_recurse
  move $v0, $a0
  jr $ra
  
  fib_recurse:
    sub $sp, $sp, 12
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    add $a0, $a0, -1
    jal fib
    
    lw $a0, 4($sp)
    sw $v0, 8($sp)
    add $a0, $a0, -2
    jal fib
    
    lw $t0, 8($sp)
    add $v0, $v0, $t0
    lw $ra, 0($sp)
    add $sp, $sp, 12
    jr $ra
    
print:
  move $a0, $v0
  li $v0, 1
  syscall
  
EXIT:
  li $v0, 10
  syscall