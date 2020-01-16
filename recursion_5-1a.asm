.data

.text

main:

li $a0, 3

jal function		# jump and link to function
j print

function:
  addiu $sp, $sp, -8	# adjust stack pointer two words
  sw $ra, 0($sp)	# store return address on stack
  sw $a0, 4($sp)	# store value on stack
  
  beq $a0, $zero, return	# if n is zero, start returns
  
  addiu $a0, $a0, -1	# decrement n
  jal function		# recurse
  
  return:
    lw $ra, 0($sp)	# restore return address
    lw $a0, 4($sp)	# restore value
    addiu $sp, $sp, 8	# restore stack pointer
    
    beq $a0, $zero, ifZero	# handle the zero condition
    
    li $t0, 2		# need a 2 for multiplying
    mult $v0, $t0	# multiply our value by 2
    mflo $v0		# get the product
    addiu $v0, $v0, 1	# add one
    
    jr $ra		# return to caller
    
  ifZero:
    li $v0, 1		# if $a0 = 0, this is f(0), just return 1
    jr $ra		# return to caller
    
print:
  move $a0, $v0		# put our result in $a0
  li $v0, 1		# load print integer command
  syscall		# execute
  
exit:
  li $v0, 10		# load exit command
  syscall		# execute
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    