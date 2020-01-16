li $t0, 0			# $t0 is our "i" value
				# value of k is not give, assume k is already set and is $t9

LOOP1:				# our for loop begins here
   sltiu $t2, $t0, 10		# set our flag $t2 if our $t0 is less than 10
   bne $t2, $zero, LOOP2	# if our flag $t2 is not set (not one), we are less than 10 so continue
   j EXIT			# if our flag $t2 is set (one), we are equal to 10 so quit
   

				# LOOP2 will determine our modulus:
				
LOOP2:				# if we are still in the for loop, evaluate i ($t0)
				# keep subtracting two from our i until it's value is less than two
				# which will be its modulus
				
   sltiu $t1, $t0, 2		# if i < 2, our modulus, set our flag, $t1
   bne $t1, $zero, theMod	# branch on not equal, if flag $t1 is not a zero, go to theMod 
   addiu $t0, $t0, -2		# otherwise, subtract two from our i ($t0)
   j LOOP2			# if we get here, return to our LOOP2 until i ($t0) < 2
   
   				# theMod:, evaluate if our modulus is zero, if so, jump to theK
   				# to do the math, otherwise, just go back to the main loop
theMod:
   beq $t0, $zero, theK		# if our mod == 0, go to "theK" to do the math
   j LOOP1			# otherwise, return to main loop, LOOP1
   
   				# theK, if our modulus was zero, set our k = 2k + 1
theK:
   addu $t9, $t9, $t9		# add $t9 (k) to $t9 (k), store in $t9 (k), this is k = k * 2
   addiu $t9, $t9, 1		# add one to $t9 (k), store in $t9 (k)
   j LOOP1			# return to main loop to complete the for loop
   
   EXIT:
      li $v0, 10		# setup for system call for exit
      syscall			# system call to exit