# recursion test
# my_int = word
# $t0 = my_int

.data 

.text

main:

# read in an integer from the user
li $v0, 5
syscall 
move $v0, $t0	# store the entered value into $t0

# create my factorial function:
fact:
   bgt $a0, 1, recurse	# if $a0 is greater than one, go to my recursive function
   # else, just return 1
   li $v0, 1
   syscall
   # jr $ra
   
recurse:
   addi $sp, $sp, -8
   sw $a0, 0($sp)
   sw $ra, 4($sp)

   addi $a0, $a0, -1
   jal fact
   # bne $a0, $zero, fact		# if we are not zero, call fact again
      
# otherwise, recover:
   lw $ra, 4($sp)
   lw $a0, 0($sp)
   addi $sp, $sp, 8
   mul $v0, $v0, $a0
   

# exit the program
li $v0, 10
syscall
