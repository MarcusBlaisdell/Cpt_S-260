# Marcus Blaisdell
# Cpt_S 260
# Zhe Dang
# Homework 3, problem 2
# 15, February, 2016

# string_1 = user entered string
# string_2 = manipulated string
# promptK = user message to enter k value
# promptM = user message to enter m value
# promptS = user message to enter a string of size k * m
# $t0 = current address of string_1
# $t1 = current address of string_2
# $t2 = loop counter
# $t3, = k counter (inner loop)
# $t4 = value of m
# $t5 = value of k
# $t6 = temp character storage

.data
string_1: .space 255	# store user entered string
string_2: .space 255 	# store manipulated string
promptK: .asciiz "Enter the value for k: "	# prompt user to enter a k value
promptM: .asciiz "Enter the value for m: "	# prompt user to enter an m value
promptS: .asciiz "Enter a text string of size k * m: "	# prompt user to enter a string of size k * m

.text

main:
# get the k value:
# prompt user to enter k value:
li $v0, 4		# load command to print a string
la $a0, promptK		# load address of promptK
syscall			# execute print promptK

# get user input:
li $v0, 5		# load command to read an integer
syscall			# execute read integer
move $t4, $v0		# move k to $t4

# get the m value:
# prompt user to enter m value:
li $v0, 4		# load command to print a string
la $a0, promptM		# load address of promptM
syscall			# execute print promptM

# get user input:
li $v0, 5		# load command to read an integer
syscall			# execute read integer
move $t5, $v0		# move m to $t5

# get the string:
# prompt user to enter string:
li $v0, 4		# load command to print a string
la $a0, promptS		# load address of promptS
syscall			# execute print promptS

# get user input:
li $v0, 8		# load command to read a string
la $a0, string_1	# load address of string_1 to store user entered string
la $a1, 255		# limit size of string_1 to 255
syscall			# execute read string

# manipulate the data accordingly:
la $t0, string_1	# load address of string_1 into $t0
la $t1, string_2	# load address of string_2 into $t1
li $t2, 0		# initialize $t2 to 0, this will be our loop counter, end when it equals m
li $t3, 0		# initialize $t3 to 0, this will be our k count, reset when it equals k

LOOP1:
  beq $t3, $t4, RESET	# if our k counter = k, reset it
  beq $t2, $t5, PRINT	# if our loop counter is equal to our m value, we are done, print the string
  lb $t6, ($t0)		# get the character from the current position of string_1
  sb $t6, ($t1)		# store the character into the current position of string_2
  addu $t0, $t0, $t5	# add our m to our offset
  addiu $t1, $t1, 1	# increment position of string_2
  addiu $t3, $t3, 1	# increment our k count
  j LOOP1		# return to our loop
  
RESET:
  la $t0, string_1	# reset our $t0 to the beginning of string_1
  addiu $t3, $zero, 0	# reset k to 0
  addiu $t2, $t2, 1	# increment our loop counter
  addu $t0, $t0, $t2	# begin offset with the value of our loop counter
  j LOOP1		# start the loop over 

PRINT:
  li $v0, 4		# load print string command
  la $a0, string_2	# load the address of string_2
  syscall		# execute the command
  j EXIT		# quit

EXIT:
  li $v0, 10		# load exit command
  syscall		# execute exit
