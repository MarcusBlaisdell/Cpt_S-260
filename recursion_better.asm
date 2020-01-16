.text

# n = $a0
# x1 = $t0
# y1 = $t1
# x2 = $t2
# y2 = $t3
# z = $t4

li $a0, 3
li $t0, 2
li $t1, -1
li $t2, 3
li $t3, -2
li $t4, 1

jal function
j print

function:
  beq $a0, $zero, theZero
  beq $a0, 1, theOne
  
  addi $sp, $sp, -8
  sw $ra, 0($sp)
  sw $a0, 4($sp)
  add $a0, $a0, $t1
  jal function
  
  mult $a0, $t0
  mflo $t9
  
  lw $a0, 4($sp)
  add $a0, $a0, $t3
  jal function
  
  mult $a0, $t2
  mflo $t8
  
  add $a0, $t9, $t8
  addi $a0, $a0, 1
  
  lw $a0, 4($sp)
  lw $ra, 0($sp)
  
  addi $a0, $a0, -1	# decrement n
  
  jr $ra
  
  
theZero:
  li $v0, 1	# return 1
  jr $ra
  
theOne:
  li $v0, 2	# return 2
  jr $ra
  
print:
  li $v0, 1
  syscall

exit:
  li $v0, 10
  syscall