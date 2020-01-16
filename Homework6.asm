.data
prompt1:   .asciiz "Enter a number to find the cube root of: " 	# prompt to ask user to enter a number
value:     .double 7.0		# initialize value to 7.0
divisor:   .double 3.0		# initialize a divisor to 3.0, cube root, divide by 3 seems a good start point 
precision: .double 0.00001	# initialize our precision
newLine:   .asciiz "\n"		# newline

.text

main:

# prompt user:  ### Uncomment the next lines with double pounds (##) to read input from user
## li $v0, 4		# load print string command
## la $a0, prompt1		# load our prompt
## syscall			# execute print prompt

# get the value from the user:
## li $v0, 7		# load command to read a double
## syscall			# execute read integer

l.d $f28, value		# set $f0 = 7, our value
l.d $f2, divisor	# set $f2 = 3, our divisor
l.d $f30, precision	# use $f30 for our precision

# begin Newton's Method: Xn+1 = Xn - ( f(x)/f'(x) )
# step 1: determine a start value, make a guess at a close approximation
#	use X / 3 : double precision

div.d $f0, $f28, $f2		# divide our number by our divisor, value 3

# $f0 is our value:
# $f4 is the cube of our value
# $f6 is the difference, the cube minus our original value, we need this to be less than 0.00001

TEST:
  # test our value, cube it, subtract our target value, if the difference is less than 0.00001,  
  # we are within desired accuracy
  
  mul.d $f4, $f0, $f0		# multiply our value by itself, (square it)
  mul.d $f4, $f4, $f0		# multiply our result by our original value (to get cubed)
  sub.d $f6, $f4, $f28		# subtract our original number from our new value
  abs.d $f6, $f6		# get absolute value of our difference for evaluation
  c.lt.d $f6, $f30		# compare less than, our difference and our target value
  bc1t PRINT			# if we are within 0.00001 of our number, we are done so print our result, $f0
    
  # otherwise, Use Newton's Method, x - [f(x) / f'(x)]
  # f(x) = x^3 - 7 = $f6
  # f'(x) = 3(x^2)
  
  mul.d $f4, $f0, $f0		# get x^2, re-use $f4
  mul.d $f4, $f4, $f2		# $f2 is (not so) coincidentally our multiplier, the value 3, $f4 is now f'(x)
  div.d $f8, $f6, $f4		# divide f(x) by f'(x)
  sub.d $f0, $f0, $f8		# subtract our number from our start number
  j TEST			# re-do the loop
  
  

PRINT:
  # print newline
  li $v0, 4		# load print string
  la $a0, newLine	# load our newline string
  syscall		# execute print newline

  # print our value, $f0
  li $v0, 3		# load command to print double
  mov.d $f12, $f0	# load our product of x^3
  syscall		# execute print double



EXIT:
li $v0, 10		# load exit command
syscall			# execute exit command
