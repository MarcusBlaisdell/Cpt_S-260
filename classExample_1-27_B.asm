		// read a string from keyboard

.text
.globl main

main:
	li $v0, 8
	la $a0, myString	// load the address of where w will store our data
	li $a1, 64		// load the length, this part of the program doesnt know the length
	syscall			// read a string from keyboard

.data

myString: .space 64	// 64 bytes, can store 63 characters (+ terminator)