.data
myArray: .word 9, 2, 15, 20, 1, 6, 13	# initialize an array of ints
myComma: .asciiz ", "			# for print formatting
ERROR: .asciiz "An Error has occurred"	# Error message

.text

main:

# $t0 = start position of the array
# $t1 = value of array at the current index
# $t3 = value of array at the pivot index
# $t7 = our begin position in the array
# $t8 = our middle position in the array
# $t9 = our end position in the array
# $s0 = left begin index
# $s1 = left end index
# $s2 = right begin index
# $s3 = right end index

# set indexes and pivot
# this array is of known size, 7, end index will be at offset (7 - 1) * 4 = 24

li $s0, 0		# initialize $s0, left begin index value to 0
li $s1, 6		# initialize $s1, left end index value to 6
li $s2, 0		# initialize right begin index value to 0
li $s3, 0		# initialize right end index value to 0

jal QSort		# jump and link to QSort, our quicksort function
move $s0, $s2		# move right begin index to left begin index
move $s1, $s3		# move right end index to left end index
li $s2, 0		# set right begin index value to 0
li $s3, 0		# set right end index value to 0
jal QSort		# re-run QSort with the indexes for the right half 


QSort:
  addi $sp, $sp, -20	# adjust our stack pointer down by 20 to store 5 values
  sw $s0, 0($sp)	# store our left begin index on the stack
  sw $s1, 4($sp)	# store our left end index on the stack
  sw $s2, 8($sp)	# store our right end index on the stack
  sw $s3, 12($sp)	# store our right end index on the stack
  sw $ra, 16($sp)	# store our return address on the stack
  
  subu $t6, $s1, $s0	# subtract our end index from our begin index
  beq $t6, 2, sort3	# if end index - begin index = 2, we only have 3 elements, just sort them
  beq $t6, 1, sort2	# if end index - begin index = 1, we only have 2 elements, just sort them
  # else, continue on with QSort

# determine the middle index of the left indexes

MIDDLE:
  la $t0, myArray	# load beginning of array into beginning index, $t0
  li $t4, 4		# put the value 4 into $t4 to use as a multiplier
  multu $s0, $t4	# multiply our begin index by 4 to get our begin offset
  mflo $t7		# put our offset into $t7
  addu $t7, $t0, $t7	# add our begin offset to our array start to move to the begin point
  multu $s1, $t4	# repeat for end index
  mflo $t9		# put our offset into $t9
  addu $t9, $t0, $t9	# add our end offset to our array start to move to the end point
  subu $t8, $s1, $s0	# subtract begin index from end index
  li $t5, 2		# load $t5 with 2 to divide by 2
  divu $t8, $t5		# divide our result by 2
  mflo $t8		# get the quotient
  multu $t8, $t4	# multiply by 4
  mflo $t8		# move the result to $t8
  addu $t8, $t7, $t8	# add the amount to the begin index to get the middle index

# determine the pivot, use the median of the values at the begin index, end index, and middle index

PIVOT:
  # get the value from each of the three indexes:
  
  lw $t1, 0($t7)		# load beginning value into begin index, $t1
  lw $t2, 0($t8)		# load the value from the middle index into temp var, $t2
  lw $t3, 0($t9)		# load ending value into end index, $t3

  # determine which is the median value and move it to the last index in the array to be the pivot:
  # let $t1 be A
  # let $t2 be B
  # let $t3 be C
  # six possibilities:
  # 1) A < B, B < C, A < C so B is median and pivot
  # 2) A < B, B > C, A < C so C is median and pivot
  # 3) A > B, B < C, A < C so A is median and pivot
  # 4) A < B, B > C, A > C so A is median and pivot
  # 5) A > B, B < C, A > C so C is median and pivot
  # 6) A > B, B > C, A > C so B is median and pivot
  
  # Evaluate A to B, then B to C, then A to C
  # if at any point, a test does not meet one of the above orders, skip to next test and re-evaluate all positions
  
  TEST1:
  bgt $t1, $t2, TEST2	# if A > B, skip to next test
  bgt $t2, $t3, TEST2	# if B > C, skip to next test
  bgt $t1, $t3, TEST2	# if A > C, skip to next test
  j set2 		# if we get here, 2 is our median and therefor our pivot
  
  TEST2:
  bgt $t1, $t2, TEST3	# if A > B, skip to next test
  blt $t2, $t3, TEST3	# if B < C, skip to next test
  bgt $t1, $t3, TEST3	# if A > C, skip to next test
  j set3		# if we get here, 3 is our median and therefor our pivot
  
  TEST3:
  blt $t1, $t2, TEST4	# if A < B, skip to next test
  bgt $t2, $t3, TEST4	# if B > C, skip to next test
  bgt $t1, $t3, TEST4	# if A > C, skip to next test
  j set1		# if we get here, 1 is our median and therefor our pivot
  
  TEST4:
  bgt $t1, $t2, TEST5	# if A > B, skip to next test
  blt $t2, $t3, TEST5 	# if B < C, skip to next test
  blt $t1, $t3, TEST5	# if A < C, skip to next test
  j set1		# if we get here, 1 is our median and therefor our pivot
  
  TEST5:
  blt $t1, $t2, TEST6	# if A < B, skip to next test
  bgt $t2, $t3, TEST6	# if B > C, skip to next test
  blt $t1, $t3, TEST6	# if A < C, skip to next test
  j set3		# if we get here, 3 is our median and therefor our pivot
  
  TEST6:
  blt $t1, $t2, P_ERROR	# if A < B, go to ERROR
  blt $t2, $t3, P_ERROR # if B < C, go to ERROR
  blt $t1, $t3, P_ERROR	# if A < C, og to ERROR
  j set2		# if we get here, 2 is our median and therefor our pivot
  
  P_ERROR:
  # This should never happen but if it does, print an error and exit
  li $v0, 4		# load print string code
  la $a0, ERROR		# load error string
  syscall		# execute print error message
  j EXIT		# exit the program
  
set1:
  sw $t1, 0($t9)	# store the value from the beginning index in the last position, this is now our pivot
  sw $t3, 0($t7)	# store the value from the end index in the first position
  # $t8 will now become our end index, $t9 will be the pivot
  
  addiu $t8, $t9, -4	# change our end position to end index - 1, just before our pivot, we'll use $t8 as the end
                        # because we still need $t9 to swap our pivot to it's new location when this round of sort
                        # is completed
  j begin_incr		# jump to begin_incr
  
set2:
  sw $t2, 0($t9)	# store the value from the middle index in the last position, this is now our pivot
  sw $t3, 0($t8)	# store the value from the end index in the middle position
  # $t8 will now become our end index, $t9 will be the pivot
  
  addiu $t8, $t9, -4	# change our end position to end index - 1, just before our pivot, we'll use $t8 as the end
                        # because we still need $t9 to swap our pivot to it's new location when this round of sort
                        # is completed
  j begin_incr		# jump to begin_incr
  
set3:
  # if our middle value is already in the end index, we don't need to swap, just run quicksort
  # $t8 will now become our end index, $t9 will be the pivot
  
  addiu $t8, $t9, -4	# change our end position to end index - 1, just before our pivot, we'll use $t8 as the end
                        # because we still need $t9 to swap our pivot to it's new location when this round of sort
                        # is completed
  j begin_incr		# jump to begin_incr
  
  begin_incr:
    bgt $t7, $t8, p_reset	# if our begin position is beyond our end position, go to p_reset to reset pivot
    lw $t1, 0($t7)	# load the value at our current begin index into our $t1
    lw $t3, 0($t9)	# load the value of our pivot into $t3 for comparison
    bgt $t1, $t3, end_decr	# if value at begin index is greater than value at pivot, jump to decrement end index
    addiu $t7, $t7, 4	# otherwise, increment begin position by 4 bytes
    j begin_incr	# otherwise, repeat
    
  end_decr:
    blt $t8, $t7, p_reset 	# if our end position is before our begin position, go to p_reset to reset pivot
    lw $t2, 0($t8)	# load the value at our current end position into our $t2
    lw $t3, 0($t9)	# load the value of our pivot into $t3 for comparison
    blt $t2, $t3, swap	# if the value at our end index is less than our pivot, jump to swap
    subiu $t8, $t8, 4	# otherwise, decrement our postion by 4
    j end_decr		# repeat
  j PIVOT		# return to pivot ???
  
# move the pivot to the last indexed position so that it is in its sorted position
  
p_reset:
  lw $t1, 0($t7)	# load the value for our current begin index location
  sw $t1, 0($t9)	# store what was at our current begin index location into the end position of the array
  sw $t3, 0($t7)	# store our pivot at the current location of our begin index
  # establish new values for left and right indexes
  # right end index will be current $s2
  move $s3, $s1		# move our existing end index to the end index of our right half
  # left indexes are from existing $s0 to existing $s1 / 2
  divu $s1, $t5		# divide our existing end index by 2
  mflo $s1		# this is our new left half end index, $s1
  addiu $s2, $s1, 1	# our new right half begin index is 1 + the left half end index
  # right indexes are from ($s1 / 2 ) + 1 to existing $s1
  jal QSort		# re-run QSort with new indexes
  
  
swap:
  # the next two lines shouldn't be necessary but I was having problems so I explicitly set the values again
  lw $t1, 0($t7)	# load what is at the begin index into $t1
  lw $t2, 0($t8)	# load what is at the end index into $t2
  sw $t1, 0($t8)	# store what the begin index is pointing to in the position at end index
  sw $t2, 0($t7)	# store that the end index is point to in the position at the begin index
  addiu $t7, $t7, 4	# increment the begin position
  subiu $t8, $t8, 4	# decrement the end position
  j begin_incr		# return to begin_incr

return:
  lw $s0, 0($sp)	# restore left begin index from stack
  lw $s1, 4($sp)	# restore left end index from stack
  lw $s2, 8($sp)	# restore right begin index from stack
  lw $s3, 12($sp)	# restore right end index from stack
  la $ra, 6($sp)	# restore return address
  addiu $sp, $sp, 20	# restore stack pointer
  j EXIT		# go to ?? (not EXIT)

sort3:
  # if only 3 elements, just sort them the brute-force way
  # if begin > middle, swap begin and middle then evaluate middle and end, else evaluate middle and end
  # if middle > end, swap middle and end then return to evaluate begin and middle, else, end
  lw $t1, 0($t7)	# load the value at the begin index
  lw $t3, 0($t8)	# load the value at the end index
                        # (since there are only three elements, the middle index is 4 bytes above the begin index)
  lw $t2, 4($t7)	# load the value at the middle index 
  bgt $t1, $t2, swap12	# if the value in the begin index is larger than the value in the middle index, swap them
  bgt $t2, $t3, swap23	# if the value in the middle index is larger than the value in the end index, swap them
  jr $ra 		# if we reach here, we are sorted, return to return address ???
  
swap12:
  sw $t1, 4($t7)	# store what was in the begin index into the middle index
  sw $t2, 0($t7)	# store what was in the middle index into the begin index
  j sort3		# return to sort3
  
swap23:
  sw $t2, 0($t8)	# store what was in the middle index into the end index
  sw $t3, 4($t7)	# store what was in the end index into the middle index
  j sort3		# return to sort3

sort2:
  # if only 2 elements, just sort them the brute-force way
  lw $t1, 0($t7)	# load the value at the begin index
  lw $t2, 0($t8)	# load the value at the end index
  bgt $t2, $t1, swap2	# if our begin index is greater than our end index, swap them, 
                        # otherwise, they are already sorted
  bgt $s2, $zero, right	# if $s2 is not zero, swap right half indexes to left half indexes and re-run
  jr $ra		# return to return address
                        
swap2:
  sw $t1, 0($t8)	# put what was in the begin index into the end index
  sw $t2, 0($t7)	# put what was in the end index into the begin index
  bgt $s2, $zero, right	# if $s2 is not zero, swap right half indexes to left half indexes and re-run
  jr $ra 		# return to return address
  
# if we get here, we are done with left half, now, process right half
right:
  ble $s2, $zero, PRINT	# if the begin index of our right half is zero, there is no right half so quit
  move $s0, $s2		# move right half begin index to $s0
  move $s1, $s3		# move right half end index to $s1
  li $s2, 0		# reset right half begin index to 0
  li $s3, 0		# reset right half end index to 0
  jal QSort		# re-run QSort with new indexes
  
# end of QSort function

# print the contents of the array

PRINT:
  la $t0, myArray	# load the start address of myArray into $t0
  li $t1, 1		# initialize $t1 to 1
  li $t2, 7		# initialize $t2 to 7, the size of our array
  loop:
    bgt $t1, $t2, EXIT	# if our counter exceeds the size of our array, quit
    
    li $v0, 1		# load print integer command
    lw $a0, 0($t0)	# load value of first element
    syscall		# execute
    
    # add a comma and a space to format our output:
    li $v0, 4		# load command to print a string
    la $a0, myComma	# load our comma and space string
    syscall		# execute print comma and space
    
    addiu $t0, $t0, 4	# increment $t0 by 4 bytes
    addiu $t1, $t1, 1	# increment our counter, $t1
    j loop		# return to loop
  

EXIT:
li $v0, 10		# load exit command
syscall			# execute exit
