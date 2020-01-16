# Marcus Blaisdell
# Cpt_S 260
# Zhe Dang
# Homework 3, problem 3
# 15, February, 2016

# string_1 = input read in from user, must be in the format: xx+yy=
# prompt_1 = prompt user to enter the string appropriately
# overflow = our overflow message
# $t0 = first integer, tens position, also final result
# $t1 = first integer, ones position, also temp value 99 for comparison purposes
# t2 = the value 10 for multiplication
# t3 = second integer, tens position
# t4 = second integer, ones position

.data
string_1: .space 255	# string for user input, 
prompt_1: .asciiz "Enter a string in the format: XX+YY= : "
overflow: .asciiz "OVERFLOW! : sum exceeds 99!"

.text

main:

# read the input from the user:
li $v0, 4		# load command to print a string
la $a0, prompt_1	# laod prompt_1 address to be printed to screen
syscall			# execute the print

li $v0, 8		# load command to read a string
la $a0, string_1	# load address of string_1 to receive the user input
la $a1, 255		# accept 7 characters
syscall			# execute get input

# parse the string appropriately:
# position 0 = tens digit of first integer
# position 1 = ones digit of first integer
# position 3 = tens digit of second integer
# position 4 = ones digit of second integer

la $t9, string_1	# load string_1 address start point to $t9

# decode our first integer:
lb $t0, 0($t9)		# get tens digit of first integer
addiu $t0, $t0, -48	# reduce ascii value by 48 to get integer value
lb $t1, 1($t9)		# get ones digit of first integer
addiu $t1, $t1, -48	# reduce ascii value by 48 to get integer value
addiu $t2, $zero, 10	# create a temp value of 10
mult $t0, $t2		# multiply our tens digit by 10
mflo $t0		# store product in $t0, value won't exceed 32 bits, just using lo word
addu $t0, $t0, $t1	# add our tens to our ones to get our full value

# decode our second integer:
lb $t3, 3($t9)		# get tens digit of first integer
addiu $t3, $t3, -48	# reduce ascii value by 48 to get integer value
lb $t4, 4($t9)		# get ones digit of first integer
addiu $t4, $t4, -48	# reduce ascii value by 48 to get integer value
mult $t3, $t2		# multiply our tens digit by 10
mflo $t3		# store product in $t0, value won't exceed 32 bits, just using lo word
addu $t3, $t3, $t4	# add our tens to our ones to get our full value

# do our addition:
addu $t0, $t0, $t3	# add first integer, $t0 to second integer, $t3, store result in $t0

# evaluate the result:
evaluate:
li $t1, 99		# temp variable to hold value 99
bgt $t0, $t1, OVERFLOW	# if result is greater than 99, print overflow message
j print			# otherwise, print result

OVERFLOW:
  li $v0, 4		# load print string command
  la $a0, overflow	# load address of our overflow message
  syscall		# execute print
  j EXIT		# exit the program

print:
li $v0, 1		# print our result
la $a0, ($t0) 		# load our integer result
syscall			# print our value


EXIT:
  li $v0, 10		# load command for quit
  syscall		# execute quit