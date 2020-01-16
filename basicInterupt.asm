.data
  dmesg: .asciiz "main\n"

.text

mfc0 $t0, $12	# get register
ori $t0, $t0 1	# set bit 0 to one, enable
mtc0 $t0, $12	# restore register

lui $t0, 0xffff	# load the receiver control register address
lw $t1, 0($t0)	# get the register
ori $t1, $t1, 2	# enable bit 1 to enable keyboard interupt
sw $t1, 0($t0)	# update reciever control register

Loop:
  j Loop	# run until we say stop (interupted)
  
print:
  la $a0, dmesg	# load message
  li $v0, 4	# load print string command
  syscall	# execute print
  
exit:
  li $v0, 10	# load exit command
  syscall	# execute exit 
  
.ktext 0x80000180
  la $a0, mesg	# load interupt message
  li $v0, 4	# load print string command
  syscall 	# execute print
  
  # adjust return address 
  mfc0 $t0, $14		# load return address register
  addi $t0, $t0, 4	# increment by 4
  mtc0 $t0, $14		# restore return address register
  
  eret			# return

.kdata
  mesg: .asciiz "interupted\n"