.data

.text

### for f(n) = 3(f(n - 1)) + f(n - 3) -1

li $a0, 3			# initialize n to 3

jal recurse
j print

recurse:
  beqz $a0, ifZero 		# base case, n = 0
  li $t0, 1			# load a one for eval of one
  beq $a0, $t0, ifOne		# base case, n = 1
  
  # adjust stack pointer
  addi $sp, $sp, -12		# adjust down 3 words
  sw $v0, 8($sp)		# store $v0 on the stack
  sw $a0, 4($sp)		# store $a0, our n value on the stack
  sw $ra, 0($sp)		# store return address on the stack
  
  addi $a0, $a0, -1		# subtract 1 from n
  jal recurse			# call recursive function
  li $t0, 3			# need to multiply by 3
  mult $v0, $t0			# multiply by 3
  mflo $v0
  sw $v0, 8($sp)		# replace the value in our stack with our new value
  
  lw $a0, 4($sp)		# restore our n value from the stack
  addi $a0, $a0, -2		# subtract 3 from n
  jal recurse			# call recursive function
  addi $v0, $v0, -1			# do the minus 1
  lw $t0, 8($sp)		# get our updated $v0 from the stack
  add $v0, $v0, $t0		# add our two values
  
  lw $ra, 0($sp)		# restore our return address
  
  jr $ra			# and finish the recursion
  
ifZero:
  li $v0, 0			# just return 0
  jr $ra			# return to where we were called from

ifOne:
  li $v0, 1			# just return 1
  jr $ra			# return to where we were called from
  
print: 
  move $a0, $v0			# move our $v0 to $a0 so we can print it
  li $v0, 1			# load print integer command
  syscall			# execute print
  j exit			# quit

exit:
  li $v0, 10			# load exit command
  syscall			# execute