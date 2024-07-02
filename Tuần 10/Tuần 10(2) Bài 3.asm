.eqv HEADING 0xffff8010 # Integer: An angle between 0 and 359
.eqv MOVING 0xffff8050 # Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # Boolean (0 or non-0):	# whether or not to leave a track
.eqv WHEREX 0xffff8030 # Integer: Current x-location of MarsBot
.eqv WHEREY 0xffff8040 # Integer: Current y-location of MarsBot

.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?		# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do	# Auto clear after sw
.text
main:
	li $k0, KEY_CODE
 	li $k1, KEY_READY
 	li $s0, DISPLAY_CODE
 	li $s1, DISPLAY_READY
loop: nop
 
WaitForKey: lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
 beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
ReadKey: lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
WaitForDis: lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
 beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling 
 
Kiemtra:
 	beq $t0, 0x61, nhan_a
 	beq $t0, 0x77, nhan_w
 	beq $t0, 0x73, nhan_s
 	beq $t0, 0x64, nhan_d
 	beq $t0, 0x20, nhan_space 	
nhan_a:
	jal UNTRACK # keep old track
 	jal TRACK # and draw new track line
	goLeft: addi $a0, $zero, 270 # Marsbot rotates 270
 	jal ROTATE
 	jal GO
 	j loop
 	
 nhan_w:
	jal UNTRACK # keep old track
 	jal TRACK # and draw new track line
	goUp: addi $a0, $zero, 0 # Marsbot rotates 0
 	jal ROTATE
 	jal GO
 	j loop
 	
 nhan_s:
	jal UNTRACK # keep old track
 	jal TRACK # and draw new track line
	goDown: addi $a0, $zero, 180 # Marsbot rotates 180
 	jal ROTATE
 	jal GO
 	j loop
 	
 nhan_d:
	jal UNTRACK # keep old track
 	jal TRACK # and draw new track line
	goRight: addi $a0, $zero, 90 # Marsbot rotates 90
 	jal ROTATE
 	jal GO
 	j loop	
 	
 nhan_space:
	beq $t7, 1, stop
	beq $t7, 0, tieptuc
	tieptuc:
	jal GO
	j loop
	stop:
	jal STOP
	j loop				

GO: li $at, MOVING # change MOVING port
 addi $t7, $zero,1 # to logic 1,
 sb $t7, 0($at) # to start running
 jr $ra

STOP: li $at, MOVING # change MOVING port to 0
 addi $t7, $zero,0 # to logic 0,
 sb $t7, 0($at) # to stop
 jr $ra

TRACK: li $at, LEAVETRACK # change LEAVETRACK port
 addi $t7, $zero,1 # to logic 1,
 sb $t7, 0($at) # to start tracking
 jr $ra
 
UNTRACK:li $at, LEAVETRACK # change LEAVETRACK port to 0
 sb $zero, 0($at) # to stop drawing tail
 jr $ra

ROTATE: li $at, HEADING # change HEADING port
 sw $a0, 0($at) # to rotate robot
 jr $ra