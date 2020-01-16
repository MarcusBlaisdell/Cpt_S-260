# Marcus Blaisdell
# Cpt_S 260
# Zhe Dang
# Homework 3, problem 1
# 15, February, 2016

# string_1 = first string, limited to 255 characters, just because
# string_2 = second string, limited to 255 characters, just because
# string_3 = shuffled results string
# prompt_1 = user message one
# prompt_2 = user message two
# $t0 = current address of string_1
# $t1 = current address of string_2
# $t2 = current address of string_3
# $t3 = temp, hold current character for storing into string_3

.data 
string_1: .space 255		# label for first string, max size 255
string_2: .space 255		# label for second string, max size 255
string_3: .space 510		# label for third string that will hold results of the shuffle
prompt_1: .asciiz "Enter the first string (max size 255 characters): "
prompt_2: .asciiz "Enter the second string (max size 255 characters): "

.text

main:

# read in first string:
# print message to user:
li $v0, 4			# load command to print a string
la $a0, prompt_1		# load prompt 1 to the address space to be printed
syscall				# execute print a string

li $v0, 8			# load command to read a string
la $a0, string_1		# load address of string 1 to store what user enters
la $a1, 255			# limit string to 255 characters
syscall				# execute read string

# read in second string:
li $v0, 4			# load command to print a string
la $a0, prompt_2		# load prompt 2 to the address space to be printed
syscall				# execute print a string

# read in the second string
li $v0, 8			# load command to read a string
la $a0, string_2		# load address of string 2 to store what user enters
la $a1, 255			# limit string size to 255 characters
syscall				# execute read string

# now shuffle them
# load the addresses of all of our strings to temp registers:
la $t0, string_1		# load address of string_1 into $t0
la $t1, string_2		# load address of string_2 into $t1
la $t2, string_3		# laod address of string_3 into $t4

# use subroutine to shuffle:
shuffle:
  # $t3 will be my copy variable
  lb $t3, ($t0)			# load first byte of string_1 into $t3
  beq $t3, $zero, printResult	# if we have reached the end of our string, skip store and jump to printResult
  sb $t3, ($t2)			# store first byte of string_1 into first position of $t2, pointer to string_3
  addi $t0, $t0, 1		# increment string_1
  lb $t3, ($t1)			# load first byte of string_2 into $t3
  addi $t2, $t2, 1		# increment address of $t2 by one, 
  sb $t3, ($t2)			# store first byte of string_2 into second position of $t2
  addi $t1, $t1, 1		# increment string_2
  addi $t2, $t2, 1		# increment address of $t2 by one
  j shuffle			# return to beginning of loop

printResult:
  li $v0, 4			# load command to print a string
  la $a0, string_3		# load address of string_3
  syscall			# print string_3

EXIT:
li $v0, 10			# load the exit command
syscall				# execute exit
