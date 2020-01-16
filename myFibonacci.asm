.text
li $t9, 0		# counter
li $t8, 3		# sentinel

loop:
move $t0, $t9		# set $t0 = $t9
bgt $t9, $t8, print
jal fib
addi $t9, $t9, 1

j loop

fib:
  bgt $t0, 1, recurse
  li $v0, 1		# if we are less than, equal to 1, just return 1
  jr $ra		# return 1
  
  recurse:
    addi $sp, $sp, -12	# adjust stack pointer 3 words
    sw $ra, 0($sp)	# store return address
    sw $v0, 4($sp)	# store $v0 on stack
    sw $a0, 8($sp)	# store $a0 on stack
    #move $t0, $a0	# move $a0 to $t0
    addi $t0, $t0, -1	# n - 1
    jal fib		# call with new value
    
    move $t1, $v0	# store our n - 1 in $t1
    move $t0, $t9	# start over
    addi $t0, $t0, -2	# this time with n - 2
    jal fib
    move $t2, $v0	# store this value in $t2 to separate from n - 1
    
    #addi $t9, $t9, 1	# increment our counter
    #bgt $t9, $t8, return# if our counter exceeds our stop int, start returning values
    #addi $a0, $a0, 1	# otherwise, increment our n value and repeat
    j fib
    
return:
  lw $a0, 8($sp)	# restore $a0
  lw $v0, 4($sp)	# restore $v0
  lw $ra, 0($sp)	# restore return address
  addi $sp, $sp, 12	# restore stack pointer
  
  add $a0, $t2, $v0	# add the two returned values
  jr $ra
  
print:
  li $v0, 1		# load print integer
  syscall