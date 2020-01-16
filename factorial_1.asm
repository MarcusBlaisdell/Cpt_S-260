.data 

.text

main:
li $t0, 5		# initialize $t0 to 3
move $t1, $t0		# initialize our running product with our start number

factorial:
  addi $t0, $t0, -1	# decrement our value
  beq $t0, $zero, print	# if we are at 0, print our answer
  mult $t1, $t0		# otherwise, multiply our decremented number by our running product
  mflo $t1		# move new product to running product $t1, 
  j factorial
  
print:
  li $v0, 1
  la $a0, 0($t1)
  syscall
  
 EXIT:
   li $v0, 10
   syscall