.data 
prompt_1: .asciiz "Enter an integer: "

.text

main:

promptUser:
  li $v0, 4			# load print string command
  la $a0, prompt_1		# load our prompt into $a0
  syscall			# execute
  
getInfo:
  li $v0, 5			# load read integer command
  syscall			# execute read integer
  move $a0, $v0			# move our received number to our $a0
  
run:
  jal factorial			# call our recursive function
  j print			# after recursion finishes, print the result

factorial:
  addi $sp, $sp, -8		# adjust the stack pointer (space for two words)
  sw $ra, 0($sp)		# store the return address
  sw $a0, 4($sp)		# store the current value of $a0
  li $v0, 1			# initialize $v0 to 1, 
  				# after the recursive calls start to return, $v0 will hold the running product
  ble $a0, $zero, fact_return	# if a0 is less than or equal to zero, go to fact_return
  addi $a0, $a0, -1		# subtract 1 from $a0
  jal factorial			# jump and link to factorial, this is our recursive part!
  lw $a0, 4($sp)		# load original value
  mult $v0, $a0			# multiply n by n - 1
  mflo $v0			# put result in $v0
  
fact_return:
  lw $ra, 0($sp)		# restore $ra
  addi $sp, $sp, 8		# restore the stack pointer
  jr $ra			# return to caller
  
print:
  move $a0, $v0			# move our answer to $a0
  li $v0, 1			# load print integer command
  syscall			# execute
  
 EXIT:
   li $v0, 10
   syscall
