.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.eqv KEY_CODE 0xFFFF0004 	# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 	# =1 if has a new keycode ?
 				# Auto clear after lw
#-------------------------------------------------------------------------------
# Key value cho Digital Lab Sim
	.eqv KEY_0 0x11
	.eqv KEY_1 0x21
	.eqv KEY_2 0x41
	.eqv KEY_3 0x81
	.eqv KEY_4 0x12
	.eqv KEY_5 0x22
	.eqv KEY_6 0x42
	.eqv KEY_7 0x82
	.eqv KEY_8 0x14
	.eqv KEY_9 0x24
	.eqv KEY_a 0x44
	.eqv KEY_b 0x84
	.eqv KEY_c 0x18
	.eqv KEY_d 0x28
	.eqv KEY_e 0x48
	.eqv KEY_f 0x88
#-------------------------------------------------------------------------------
# Marsbot
.eqv HEADING 0xffff8010 # Integer: 0 -> 359
 			# 0 : north (up)
 			# 90: east (right)
			# 180: south (down)
			# 270: west (left)
.eqv MOVING 0xffff8050 # boolean: di chuyển hay ko
.eqv LEAVETRACK 0xffff8020 # boolean (0 or non-0):
 			# in dấu hay ko
.eqv WHEREX 0xffff8030 # Integer: tọa độ x hiện tại của MarsBot
.eqv WHEREY 0xffff8040 # Integer: tọa độ y hiện tại của MarsBot

#===============================================================================
#===============================================================================
.data

#Code điều khiển
	MOVE_CODE: .asciiz "1b4"
	STOP_CODE: .asciiz "c68"
	TURN_LEFT_CODE: .asciiz "444"
	TURN_RIGHT_CODE: .asciiz "666"
	TRACK_CODE: .asciiz "dad"
	UNTRACK_CODE: .asciiz "cbc"
	TURN_BACK_CODE: .asciiz "999"
	WRONG_CODE: .asciiz "Ma khong hop le"
#---------------------------------------------------------
	inputControlCode: .space 50
	lengthOfControlCode: .word 0
	nowHeading: .word 0
#---------------------------------------------------------
# duong di cua masbot duoc luu tru vao mang path, moi 1 canh duoc luu tru duoi dang 1 structure
# đường đi của marsbot được lưu vào mảng path, mỗi cạnh là 1 structure 
# 1 structure có dạng (x, y, z), với x, y là tọa độ điểm thực hiện rẽ, z là hướng rẽ lúc đó
# structure đầu tiên sẽ là (0,0,0)
# đọ dài mảng path khi bắt đầu là 12 bytes (3 x 4 byte)
#---------------------------------------------------------
	path: .space 600
	lengthOfPath: .word 12		#bytes  #khởi tạo giá trị độ dài của mảng path

#===============================================================================
#===============================================================================
.text	
main:
	li $k0, KEY_CODE
 	li $k1, KEY_READY
#---------------------------------------------------------
# Enable the interrupt of Keyboard matrix 4x4 of Digital Lab Sim
#---------------------------------------------------------
	li $t1, IN_ADRESS_HEXA_KEYBOARD
	li $t3, 0x80 # bit 7 = 1 to enable
	sb $t3, 0($t1)
#---------------------------------------------------------
loop:		nop
WaitForKey:	lw $t5, 0($k1)			
		beq $t5, $zero, WaitForKey	 
		nop
		beq $t5, $zero, WaitForKey
ReadKey:	lw $t6, 0($k0)			#$t6 = [$k0] = KEY_CODE
		beq $t6, 127 , continue		#if $t6 == delete key thì đến continue và xóa input
						#127 là mã ascii của delete
		beq $t6, 32, replay		# if $t6 = space => replay (32 là mã ascii của space)
		nop
		nop
		li $a1, 0			# ko phải replay thì $a1 = 0
		bne $t6, '\n' , loop		# nếu $t6 là các ký tự khác ngoài enter/ space/ delete thì tiếp tục Polling
		nop
		bne $t6, '\n' , loop
CheckControlCode:
		la $s2, lengthOfControlCode	# gán $s2 địa chỉ của lengthControlCode (độ dài code điều khiển)
		lw $s2, 0($s2)			# lấy giá trị $s2 là độ dài của code điều khiển
		#----------------
		bne $s2, 3, printError		# so sánh nếu số ký tự ko bằng 3 thì lỗi luôn -> PushErrorMess 
						# bằng thì tiếp tục kiểm tra xem có giống mã điều khiển ko
check:						
		la $s3, MOVE_CODE		# gán $s3 địa chỉ của MOVE_CODE (lệnh bắt đầu di chuyển)
		jal CheckString			# nhảy đến isEqualString 
		beq $t0, 1, go			# thực hiện go 
		
		la $s3, STOP_CODE		# gán $s3 địa chỉ của STOP_CODE (lệnh dừng lại)
		jal CheckString			# tương tự như MOVE_CODE
		beq $t0, 1, stop		# thực hiện stop
			
		la $s3, TURN_LEFT_CODE		# gán $s3 địa chỉ của TURN_LEFT_CODE (lệnh rẽ trái)
		jal CheckString			# tương tự như MOVE_CODE
		beq $t0, 1, turnLeft		# thực hiện rẽ trái
		
		la $s3, TURN_RIGHT_CODE		# gán $s3 địa chỉ của TURN_RIGHT_CODE (lệnh rẽ phải)
		jal CheckString			# tương tự như MOVE_CODE
		beq $t0, 1, turnRight		# thực hiện rẽ phải
		
		la $s3, TRACK_CODE		# gán $s3 địa chỉ của TRACK_CODE (lệnh bắt đầu để lại vệt)
		jal CheckString			# tương tự như MOVE_CODE
		beq $t0, 1, track		# thực hiện lưu vệt

		la $s3, UNTRACK_CODE		# gán $s3 địa chỉ của UNTRACK_CODE (lệnh không lưu vệt)
		jal CheckString			# tương tự như MOVE_CODE
		beq $t0, 1, untrack		# dừng lưu vệt
		
		la $s3, TURN_BACK_CODE		# gán $s3 địa chỉ của TURN_BACK_CODE (lệnh bắt đầu di chuyển ngược)
		jal CheckString			# tương tự như MOVE_CODE
		beq $t0, 1, turnBack		# thực hiện di chuyển ngược lộ trình
		
		beq $t0, 0, printError		# ko giống mã điều khiển nào thì -> lỗi 
			
printControlCode: # gán $a0 = inputControlCode để in ra
	li $v0, 4
	la $a0, inputControlCode
	syscall
	nop
		
continue:
	jal removeControlCode	# xóa dữ liệu code hiện tại 		
	nop
	j loop
	nop
	j loop
#-----------------------------------------------------------
# storePath procedure, store path of marsbot to path variable
# param[in] 	nowHeading variable
#		lengthPath variable
#-----------------------------------------------------------	
storePath:
	#backup
	addi $sp,$sp,4
	sw $t1, 0($sp)
	addi $sp,$sp,4
	sw $t2, 0($sp)
	addi $sp,$sp,4
	sw $t3, 0($sp)
	addi $sp,$sp,4
	sw $t4, 0($sp)
	addi $sp,$sp,4
	sw $s1, 0($sp)
	addi $sp,$sp,4
	sw $s2, 0($sp)
	addi $sp,$sp,4
	sw $s3, 0($sp)
	addi $sp,$sp,4
	sw $s4, 0($sp)
	
	#processing
	li $t1, WHEREX
	lw $s1, 0($t1)		#$s1 = x
	li $t2, WHEREY	
	lw $s2, 0($t2)		#$s2 = y
	la $s4, nowHeading
	lw $s4, 0($s4)		#$s4 = z = now heading

	la $t3, lengthOfPath
	lw $s3, 0($t3)		#$s3 = lengthOfPath (dv: byte)
	
	la $t4, path
	add $t4, $t4, $s3	# vị trí cần lưu = 
	
	sw $s1, 0($t4)		#store x
	sw $s2, 4($t4)		#store y
	sw $s4, 8($t4)		#store heading
	
	addi $s3, $s3, 12	#update lengthOfPath
				#12 = 3 (word) x 4 (bytes)
	sw $s3, 0($t3)
	
	#restore
	lw $s4, 0($sp)
	addi $sp,$sp,-4
	lw $s3, 0($sp)
	addi $sp,$sp,-4
	lw $s2, 0($sp)
	addi $sp,$sp,-4
	lw $s1, 0($sp)
	addi $sp,$sp,-4
	lw $t4, 0($sp)
	addi $sp,$sp,-4
	lw $t3, 0($sp)
	addi $sp,$sp,-4
	lw $t2, 0($sp)
	addi $sp,$sp,-4
	lw $t1, 0($sp)
	addi $sp,$sp,-4
	
	jr $ra
	nop
	jr $ra		
#-----------------------------------------------------------
# goBack procedure, control marsbot go back
# param[in] 	path array, lengthPath array
#-----------------------------------------------------------		
turnBack:
	#backup
	addi $sp,$sp,4
	sw $s5, 0($sp)
	addi $sp,$sp,4
	sw $s6, 0($sp)
	addi $sp,$sp,4
	sw $s7, 0($sp)
	addi $sp,$sp,4
	sw $t8, 0($sp)
	addi $sp,$sp,4
	sw $t9, 0($sp)
	
	jal UNTRACK
	la $s7, path
	la $s5, lengthOfPath
	lw $s5, 0($s5)
	add $s7, $s7, $s5
begin:

	addi $s5, $s5, -12 	# lui lai 1 structure
	
	addi $s7, $s7, -12	# vi tri cua thong tin ve canh cuoi cung
	lw $s6, 8($s7)		# huong cua canh cuoi cung
	addi $s6, $s6, 180	# nguoc lai huong cua canh cuoi cung
	
	
	la $t8, nowHeading	#marsbot quay nguoc lai
	sw $s6, 0($t8)
	jal ROTATE
	jal GO
	
go_to_diem_dau_tien:	
	lw $t9, 0($s7)		#toa do x cua diem dau tien cua canh
	li $t8, WHEREX		#toa do x hien tai
	lw $t8, 0($t8)

	bne $t8, $t9, go_to_diem_dau_tien	# nếu x(hiện tại) = x(quá khứ)
	nop
	bne $t8, $t9, go_to_diem_dau_tien
	
	lw $t9, 4($s7)		# toa do y cua diem dau tien cua canh
	li $t8, WHEREY		# toa do y hien tai
	lw $t8, 0($t8)
	
	bne $t8, $t9, go_to_diem_dau_tien	# nếu y(hiện tại) = y(quá khứ)
	nop
	bne $t8, $t9, go_to_diem_dau_tien
	
	beq $s5, 0, xong
	nop
	beq $s5, 0, xong
	
	j begin
	nop
	j begin
	
xong:
	jal STOP
	nop
	jal STOP
	
	la $t8, nowHeading
	add $s6, $zero, $zero
	sw $s6, 0($t8)		#update heading = 0
	la $t8, lengthOfPath
	addi $s5, $zero, 12
	sw $s5, 0($t8)		#update lengthPath = 12
	
	#restore
	lw $t9, 0($sp)
	addi $sp,$sp,-4
	lw $t8, 0($sp)
	addi $sp,$sp,-4
	lw $s7, 0($sp)
	addi $sp,$sp,-4
	lw $s6, 0($sp)
	addi $sp,$sp,-4
	lw $s5, 0($sp)
	addi $sp,$sp,-4
	
	jal ROTATE
	nop
	j printControlCode
#-----------------------------------------------------------
# track procedure
#-----------------------------------------------------------	
track: 	jal TRACK
	j printControlCode
#-----------------------------------------------------------
# untrack procedure
#-----------------------------------------------------------	
untrack: jal UNTRACK
	j printControlCode
#-----------------------------------------------------------
# go procedure
#-----------------------------------------------------------	
go: 	jal GO			
	j printControlCode	
#-----------------------------------------------------------
# stop procedure
#-----------------------------------------------------------	
stop: 	jal STOP
	j printControlCode
#-----------------------------------------------------------
# turnRight procedure
#-----------------------------------------------------------	
turnRight:
	#backup
	addi $sp,$sp,4
	sw $s5, 0($sp)
	addi $sp,$sp,4
	sw $s6, 0($sp)
	#restore
	jal UNTRACK
	jal TRACK
	la $s5, nowHeading
	lw $s6, 0($s5)	#$s6 là hướng hiện tại
	addi $s6, $s6, 90 #cộng hướng hiện tại thêm 90
	sw $s6, 0($s5) # update nowHeading
	#restore
	lw $s6, 0($sp)
	addi $sp,$sp,-4
	lw $s5, 0($sp)
	addi $sp,$sp,-4
	
	li $a1, 1
	
	jal storePath	#thực hiện lưu vết lần rẽ này
	jal ROTATE
	j printControlCode	
#-----------------------------------------------------------
# turnLeft procedure
#-----------------------------------------------------------	
turnLeft:	
	#backup
	addi $sp,$sp,4
	sw $s5, 0($sp)
	addi $sp,$sp,4
	sw $s6, 0($sp)
	#processing
	jal UNTRACK
	jal TRACK
	la $s5, nowHeading
	lw $s6, 0($s5)	#$s6 is heading at now
	addi $s6, $s6, -90 #increase heading by 90*
	sw $s6, 0($s5) # update nowHeading
	#restore
	lw $s6, 0($sp)
	addi $sp,$sp,-4
	lw $s5, 0($sp)
	addi $sp,$sp,-4
	
	li $a1,2
	
	jal storePath
	jal ROTATE
	j printControlCode			
#-----------------------------------------------------------
# Replay procedure, control marsbot to replay latesst procedure
#-----------------------------------------------------------	
replay:
	#backup
	addi $sp,$sp,4
	sw $s5, 0($sp)
	addi $sp,$sp,4
	sw $s3, 0($sp)
	#restore
	jal UNTRACK
	jal TRACK
	
	beq $a1,1,turnRightAgain
	beq $a1,2,turnLeftAgain
	beq $a1,0,continue
	
	
   turnLeftAgain:
	#restore
	lw $s3, 0($sp)
	addi $sp,$sp,-4
	lw $s5, 0($sp)
	addi $sp,$sp,-4
	j turnLeft
	nop
	j turnLeft
	nop
	
   turnRightAgain:
  	#restore
	lw $s3, 0($sp)
	addi $sp,$sp,-4
	lw $s5, 0($sp)
	addi $sp,$sp,-4
	j turnRight
	nop
	j turnRight
	nop
	
#-----------------------------------------------------------
# thủ tục removeControlCode để xóa chuỗi inputControlCode
#				inputControlCode = ""
# param[in] none
#-----------------------------------------------------------				
removeControlCode:
	#backup $t1, $t2, $s1, $t3, $s2 (lưu tạm)
	addi $sp,$sp,4
	sw $t1, 0($sp)
	addi $sp,$sp,4
	sw $t2, 0($sp)
	addi $sp,$sp,4
	sw $s1, 0($sp)
	addi $sp,$sp,4
	sw $t3, 0($sp)
	addi $sp,$sp,4
	sw $s2, 0($sp)
	
	#processing
	la $s2, lengthOfControlCode			#$s2 = địa chỉ lengControlCode
	lw $t3, 0($s2)					#$t3 = độ dài của input code
	addi $t1, $zero, -1				#$t1 = -1 = i
	addi $t2, $zero, 0				#$t2 = '\0'
	la $s1, inputControlCode			# $s1 = địa chỉ input code
	addi $s1, $s1, -1				
	for_loop_to_remove:
		addi $t1, $t1, 1			#i++
	
		add $s1, $s1, 1				#$s1 = inputControlCode + i
		sb $t2, 0($s1)				# $t2 = 0 -> inputControlCode[i] = '\0'
				
		bne $t1, $t3, for_loop_to_remove	#if $t1 <=3 continue loop
		nop
		bne $t1, $t3, for_loop_to_remove	# i = n thì kết thúc vòng lặp
		
	add $t3, $zero, $zero			
	sw $t3, 0($s2)					# update lengthControlCode = 0
		
	#restore $t1, $t2, $s1, $t3, $s2 (trả lại)
	lw $s2, 0($sp)
	addi $sp,$sp,-4
	lw $t3, 0($sp)
	addi $sp,$sp,-4
	lw $s1, 0($sp)
	addi $sp,$sp,-4
	lw $t2, 0($sp)
	addi $sp,$sp,-4
	lw $t1, 0($sp)
	addi $sp,$sp,-4
	
	jr $ra			
	nop
	jr $ra
#-----------------------------------------------------------
# thủ tục CheckString, để kiểm tra chuỗi inputControlCode (Code điều khiển)
#				có bằng chuỗi 666,dad,1b4,... (lưu trong $s3 )
#				độ dài của 2 chuỗi là bằng nhau
# param[in] $s3, lưu địa chỉ chuỗi
# param[out] $t0, 1 if equal, 0 is not equal
#-----------------------------------------------------------					
CheckString:
	#backup $t1, $s1, $t2, $t3 (lưu tạm các dữ liệu cũ của các thanh ghi này để sử dụng chúng trong thủ tục này)
	addi $sp,$sp,4
	sw $t1, 0($sp)
	addi $sp,$sp,4
	sw $s1, 0($sp)
	addi $sp,$sp,4
	sw $t2, 0($sp)
	addi $sp,$sp,4
	sw $t3, 0($sp)	
	
	#processing
	addi $t1, $zero, -1				#$t1 = -1 = i
	add $t0, $zero, $zero				#$t0 = 0
	la $s1, inputControlCode			#$s1 = inputControlCode,  $s1 là code vừa nhập
	for_loop_to_check_equal:
		addi $t1, $t1, 1			#i++
	
		add $t2, $s1, $t1			#$t2 = inputControlCode + i
		lb $t2, 0($t2)				#$t2 = inputControlCode[i]
		
		add $t3, $s3, $t1			#$t3 = s + i
		lb $t3, 0($t3)				#$t3 = s[i]
		
		bne $t2, $t3, notEqual		#if $t2 != $t3 -> not equal


		bne $t1, 2, for_loop_to_check_equal	#if $t1 <=2 continue loop
		nop
		bne $t1, 2, for_loop_to_check_equal
Equal:
	#restore $t1, $s1, $t2, $t3 (trả lại dữ liệu cũ của các thanh ghi)
	lw $t3, 0($sp)
	addi $sp,$sp,-4
	lw $t2, 0($sp)
	addi $sp,$sp,-4
	lw $s1, 0($sp)
	addi $sp,$sp,-4
	lw $t1, 0($sp)
	addi $sp,$sp,-4
	
	add $t0, $zero, 1				#update $t0 = 1 => nghĩa là giống mã điều khiển này
	jr $ra						#quay lại 
	nop
	jr $ra
notEqual:
	#restore $t1, $s1, $t2, $t3 (trả lại dữ liệu cũ của các thanh ghi)
	lw $t3, 0($sp)
	addi $sp,$sp,-4
	lw $t2, 0($sp)
	addi $sp,$sp,-4
	lw $s1, 0($sp)
	addi $sp,$sp,-4
	lw $t1, 0($sp)
	addi $sp,$sp,-4

	add $t0, $zero, $zero				#update $t0 = 0 => nghĩa là 0 giống mã điều khiển này
	jr $ra						#quay lại 
	nop
	jr $ra
#-----------------------------------------------------------
# print error mess
#-----------------------------------------------------------					
printError: # thủ tục in thông báo nhập code sai
	li $v0, 4
	la $a0, inputControlCode
	syscall
	nop
	
	li $v0, 55
	la $a0, WRONG_CODE
	syscall
	nop
	nop
	j continue 		# quay lại continue 
	nop
	j continue		# khoảng dòng 135			
#-----------------------------------------------------------
# GO, STOP, TRACK, UNTRACK, ROTATE
#-----------------------------------------------------------
GO: 	#backup $at, $k0 (lưu tạm)
	addi $sp,$sp,4
	sw $at,0($sp)
	addi $sp,$sp,4
	sw $k0,0($sp)
	#processing
	li $at, MOVING 		# change MOVING port
 	addi $k0, $zero,1 	# $k0 to logic 1,
	sb $k0, 0($at) 		# to start running	
	#restore $at, $k0 (trả lại)
	lw $k0, 0($sp)
	addi $sp,$sp,-4
	lw $at, 0($sp)
	addi $sp,$sp,-4
	
	jr $ra
	nop
	jr $ra

STOP: 	#backup
	addi $sp,$sp,4
	sw $at,0($sp)
	#processing
	li $at, MOVING # change MOVING port to 0
	sb $zero, 0($at) # to stop
	#restore
	lw $at, 0($sp)
	addi $sp,$sp,-4
	
	jr $ra
	nop
	jr $ra

TRACK: 	#backup
	addi $sp,$sp,4
	sw $at,0($sp)
	addi $sp,$sp,4
	sw $k0,0($sp)
	#processing
	li $at, LEAVETRACK # change LEAVETRACK port
	addi $k0, $zero,1 # to logic 1,
 	sb $k0, 0($at) # to start tracking
 	#restore
	lw $k0, 0($sp)
	addi $sp,$sp,-4
	lw $at, 0($sp)
	addi $sp,$sp,-4
	
 	jr $ra
	nop
	jr $ra

UNTRACK:#backup
	addi $sp,$sp,4
	sw $at,0($sp)
	#processing
	li $at, LEAVETRACK # change LEAVETRACK port to 0
 	sb $zero, 0($at) # to stop drawing tail
 	#restore
	lw $at, 0($sp)
	addi $sp,$sp,-4
	
 	jr $ra
	nop
	jr $ra

ROTATE: 
	#backup
	addi $sp,$sp,4
	sw $t1,0($sp)
	addi $sp,$sp,4
	sw $t2,0($sp)
	addi $sp,$sp,4
	sw $t3,0($sp)
	#processing
	li $t1, HEADING # change HEADING port
	la $t2, nowHeading
	lw $t3, 0($t2)	#$t3 is heading at now
 	sw $t3, 0($t1) # to rotate robot
 	#restore
 	lw $t3, 0($sp)
	addi $sp,$sp,-4
	lw $t2, 0($sp)
	addi $sp,$sp,-4
	lw $t1, 0($sp)
	addi $sp,$sp,-4
	
 	jr $ra
	nop
	jr $ra	
		

#===============================================================================
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
#-------------------------------------------------------
# SAVE the current REG FILE to stack
#-------------------------------------------------------
backup: 
	addi $sp,$sp,4
	sw $ra,0($sp)
	addi $sp,$sp,4
	sw $t1,0($sp)
	addi $sp,$sp,4
	sw $t2,0($sp)
	addi $sp,$sp,4
	sw $t3,0($sp)
	addi $sp,$sp,4
	sw $a0,0($sp)
	addi $sp,$sp,4
	sw $at,0($sp)
	addi $sp,$sp,4
	sw $s0,0($sp)
	addi $sp,$sp,4
	sw $s1,0($sp)
	addi $sp,$sp,4
	sw $s2,0($sp)
	addi $sp,$sp,4
	sw $t4,0($sp)
	addi $sp,$sp,4
	sw $s3,0($sp)
#--------------------------------------------------------
# Processing
#--------------------------------------------------------
get_cod:
	li $t1, IN_ADRESS_HEXA_KEYBOARD
	li $t2, OUT_ADRESS_HEXA_KEYBOARD
scan_row1:
	li $t3, 0x81
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bnez $a0, get_code_in_char
scan_row2:
	li $t3, 0x82
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bnez $a0, get_code_in_char
scan_row3:
	li $t3, 0x84
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bnez $a0, get_code_in_char
scan_row4:
	li $t3, 0x88
	sb $t3, 0($t1)
	lbu $a0, 0($t2)
	bnez $a0, get_code_in_char
get_code_in_char:
	beq $a0, KEY_0, case_0
	beq $a0, KEY_1, case_1
	beq $a0, KEY_2, case_2
	beq $a0, KEY_3, case_3
	beq $a0, KEY_4, case_4
	beq $a0, KEY_5, case_5
	beq $a0, KEY_6, case_6
	beq $a0, KEY_7, case_7
	beq $a0, KEY_8, case_8
	beq $a0, KEY_9, case_9
	beq $a0, KEY_a, case_a
	beq $a0, KEY_b, case_b
	beq $a0, KEY_c, case_c
	beq $a0, KEY_d, case_d
	beq $a0, KEY_e, case_e
	beq $a0, KEY_f, case_f
	
	#$s0 store code in char type
case_0:	li $s0, '0'
	j store_code
case_1:	li $s0, '1'
	j store_code
case_2:	li $s0, '2'
	j store_code
case_3:	li $s0, '3'
	j store_code
case_4:	li $s0, '4'
	j store_code
case_5:	li $s0, '5'
	j store_code
case_6:	li $s0, '6'
	j store_code
case_7:	li $s0, '7'
	j store_code
case_8:	li $s0, '8'
	j store_code
case_9:	li $s0, '9'
	j store_code
case_a:	li $s0, 'a'
	j store_code
case_b:	li $s0, 'b'
	j store_code
case_c:	li $s0, 'c'
	j store_code
case_d:	li $s0, 'd'
	j store_code
case_e:	li $s0,	'e'
	j store_code
case_f:	li $s0, 'f'
	j store_code
store_code:
	la $s1, inputControlCode
	la $s2, lengthOfControlCode
	lw $s3, 0($s2)				#$s3 = strlen(inputControlCode)
	addi $t4, $t4, -1 			#$t4 = i 
	for_loop_to_store_code:
		addi $t4, $t4, 1
		bne $t4, $s3, for_loop_to_store_code
		add $s1, $s1, $t4		#$s1 = inputControlCode + i
		sb  $s0, 0($s1)			#inputControlCode[i] = $s0
		
		addi $s0, $zero, '\n'		#add '\n' character to end of string
		addi $s1, $s1, 1		#add '\n' character to end of string
		sb  $s0, 0($s1)			#add '\n' character to end of string
		
		
		addi $s3, $s3, 1
		sw $s3, 0($s2)			#update length of input control code
		
#--------------------------------------------------------
# Evaluate the return address of main routine
#--------------------------------------------------------
next_pc:
	mfc0 $at, $14 # $at <= Coproc0.$14 = Coproc0.epc
	addi $at, $at, 4 # $at = $at + 4 (next instruction)
	mtc0 $at, $14 # Coproc0.$14 = Coproc0.epc <= $at
#--------------------------------------------------------
# RESTORE the REG FILE from STACK
#--------------------------------------------------------
restore:
	lw $s3, 0($sp)
	addi $sp,$sp,-4
	lw $t4, 0($sp)
	addi $sp,$sp,-4
	lw $s2, 0($sp)
	addi $sp,$sp,-4
	lw $s1, 0($sp)
	addi $sp,$sp,-4
	lw $s0, 0($sp)
	addi $sp,$sp,-4
	lw $at, 0($sp)
	addi $sp,$sp,-4
	lw $a0, 0($sp)
	addi $sp,$sp,-4
	lw $t3, 0($sp)
	addi $sp,$sp,-4
	lw $t2, 0($sp)
	addi $sp,$sp,-4
	lw $t1, 0($sp)
	addi $sp,$sp,-4
	lw $ra, 0($sp)
	addi $sp,$sp,-4
return: eret # Return from exception
