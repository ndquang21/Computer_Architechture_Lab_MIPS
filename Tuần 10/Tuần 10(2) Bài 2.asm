.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
 # Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do
 # Auto clear after sw
.text
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
checkE:
	beq $t7, 1, checkX
	beq $t0, 101, Co
checkX:
	beq $t7, 2, checkI
	beq $t0, 120, Co
checkI:
	beq $t7, 3, checkT
	beq $t0, 105, Co
checkT:
	beq $t7, 4, Encrypt2
	beq $t0, 116, Co
Encrypt:
	addi $t7, $zero, 0
Encrypt2:
 
li $s6, 0x61
li $s7, 0x7A
blt $t0, $s6, tiep1  	# if < 'a' bo qua
bgt $t0, $s7, tiep1  	# if > 'z' bo qua
addi $t0, $t0, -32 # change input key
j ShowKey

tiep1:
li $s6, 0x41
li $s7, 0x5A
blt $t0, $s6, tiep2  	# if < 'A bo qua
bgt $t0, $s7, tiep2  	# if > 'Z' bo qua
addi $t0, $t0, 32 # change input key
j ShowKey

tiep2:
li $s6, 0X30
li $s7, 0X39
blt $t0, $s6, tiep3  	# if < 0 bo qua
bgt $t0, $s7, tiep3  	# if > 9 bo qua
addi $t0, $t0, 0 # change input key
j ShowKey

tiep3:
add $t0, $zero, 0x2A
ShowKey: 	
	sw $t0, 0($s0) # show key
	nop
	beq $t7, 4, Exit
	j loop
Co:
	addi $t7, $t7, 1
	j Encrypt2
Exit:
	li $v0, 10
	syscall
