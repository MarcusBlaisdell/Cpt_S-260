				# $t0 = i 
				# $t9 = k
				# $t2 = for loop conditional flag
				# $t3 = tempVal 
				# $t4 = modulus = 2
				
.text

li $t0, 0			# $t0 is our "i" value
li $t9, 0			# value of k is not give, arbitrarily assign initial value 0
li $t4, 2			# set a register for our modulus value

LOOP1:
   sltiu $t2, $t0, 10		# set our flag $t2 if our i is less than 10
   addiu $t3, $t0, 0		# set our tempVal, $t3, for evaluations
   				# so we don't modify our original i
   				
   				# if $t2 is a 1, then i = 10 and we are done
   				# but if our flag $t2 is not set (!= 1),
   bne $t2, $zero, theMod	# we are less than 10 so evaluate the modulus
   
   j EXIT			# if our flag is set (= 1), we will arrive here 


				# get the modulus and evaluate:
theMod:
   divu $t3, $t4		# divide our tempVal by our modulus, remainder goes to $HI
   mfhi $t3			# reuse $t3 to store the modulus result
   beq $t3, $zero, theK		# if our mod == 0, go to "theK" to do the math
   addiu $t0, $t0, 1		# otherwise, increment i
   j LOOP1			# and return to main loop, LOOP1
   
   				# theK, if our modulus was zero, set our k = 2k + 1
theK:
				# multu is too confusing to me right, now, cheating and using addition:
   addu $t9, $t9, $t9		# add $t9 (k) to $t9 (k), store in $t9 (k), this is k = k * 2
   addiu $t9, $t9, 1		# add one to $t9 (k), store in $t9 (k)
   addiu $t0, $t0, 1		# increment i
   j LOOP1			# and return to main loop to complete the for loop
   
   EXIT:
      li $v0, 10		# setup for system call for exit
      syscall			# system call to exit
