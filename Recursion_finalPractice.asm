.text

li $a0, 3		# how many times
li $t0, 2		# 'x' value
li $t1, -1		# 'y' value
li $t4, 1		# 'z' value

jal function
move $t9, $v0		# store first value
li $t0, 3		# 'x' value
li $t1, -2		# 'y' value
li $t4, 0		# 'z' value
jal function
add $a0, $v0, $t9	# sum them up
j print

function:
  addi $sp, $sp, -8	# adjust stack pointer two words
  sw $ra, 4($sp)	# store return address on stack
  sw $a0, 0($sp)	# store our value on the stack
  
  beq $a0, $zero, return	# if our value is zero, jump to return process
  add $a0, $a0, -1	# decrement $a0
  jal function		# recurse

return:
  lw $ra, 4($sp)	# restore return address
  lw $a0, 0($sp)	# restore value
  addi $sp, $sp, 8	# restore stack pointer
  
  beq $a0, $zero, ifZero	# if $a0 = 0, process that condition
  
  li $t1, 1		# load a one
  beq $a0, $t1, ifOne	# if $a0 = 1, process that condition
  
  mult $v0, $t0		# multiple our value by 'x'
  mflo $v0		# put the answer in $t0
  
  addu $v0, $t0, $t4	# add 'z'
  
  jr $ra
  
ifZero:
  li $v0, 1		# return 1
  jr $ra		# return
  
ifOne:
  li $v0, 2		# return 2
  jr $ra		# return
  
print:
  li $v0, 1		# load print integer
  syscall		# execute 

exit:
  li $v0, 10		# load exit command
  syscall		# execute