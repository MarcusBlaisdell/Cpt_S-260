.data

.text

main:

# f(n) = 2(n - 1) + 3(n - 2) + 1

li $a0, 3			# initialize n

function:
  addi $sp, $sp, -8		# adjust stack pointer by two words
  sw $ra, 0($sp)		# store return address
  sw $a0, 4($sp)		# store current value of n
  
  beq $a0, $zero, return	# if n = 0, start returns
  
  li $t0, 2			# to multiply by 2
  addi $a0, $a0, -1		# subtract one
  jal function			# recursive call
  mult $t0, $v0			# multiply 2 * (f(n - 1))
  mflo $t9			# move answer to $t9
  li $t0, 3			# to multiply by 3
  addi $a0, $a0, -2		# subtract 2
  jal function			# recursive call
  mult $t0, $v0			# multiply 3 * (f(n - 2))
  mflo $t8			# move answer to $t8
  add $t0, $t8, $t9		# add $t8 & $t9
  addi $t0, $t0, 1		# add 1
  
  return:
    lw $ra, 0($sp)		# restore return address
    lw $a0, 4($sp)		# restore n
    addi $sp, $sp, 8		# restore stack pointer
    
    addiu $a0, $a0, -1		# decrement n
    
    jr $ra			# return to caller
  
  move $a0, $t0			# put the answer in $a0
  li $v0, 1			# load print integer command
  syscall			# execute
  
exit:
  li $v0, 10			# load exit command
  syscall			# execute exit	





















