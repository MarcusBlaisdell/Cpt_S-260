.text
.globl main

main:
	// must pass argument to register $a0
	
la $a0 myString
li $v0, 4 // print the string
syscall // end the code

.data
myString: .asciiz "This is my string\n" // 18 + 1 bytes, "myString" takes 32 bits