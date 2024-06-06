.data
	largest: .asciiz "Largest: "
	smallest: .asciiz "\nSmallest: "
	phay: .asciiz ", " 	
.text
	addi $s0, $zero, 1000
	addi $s1, $zero, 9
	addi $s2, $zero, 3
	addi $s3, $zero, -1
	addi $s4, $zero, 1
	addi $s5, $zero, 60
	addi $s6, $zero, -236
	addi $s7, $zero, -1000
	j store_number
	
     print:
	li $v0, 4		#print "Largest: "
	la $a0, largest
	syscall
	
	li $v0, 1		#print largest value
	addi $a0, $t0, 0
	syscall
	
	li $v0, 4		#print ", "
	la $a0, phay
	syscall
	
	li $v0, 1		#print thanh ghi chứa giá tị lớn nhất
	addi $a0, $t7, 0
	syscall
	
	li $v0, 4		#print "\nSmallest: "
	la $a0, smallest
	syscall
	
	li $v0, 1		#print smallest value
	addi $a0, $t1, 0
	syscall
	
	li $v0, 4		#print ", "
	la $a0, phay
	syscall
	
	li $v0, 1		#print thanh ghi chứa giá trị nhỏ nhất
	addi $a0, $t8, 0
	syscall
	
	li $v0, 10		#exit
	syscall
     store_number:
     	add $fp, $zero, $sp
     	addi $sp, $sp, -32
     	sw $s0, 0($sp)
     	sw $s1, 4($sp)
     	sw $s2, 8($sp)
     	sw $s3, 12($sp)
     	sw $s4, 16($sp)
     	sw $s5, 20($sp)
     	sw $s6, 24($sp)
     	sw $s7, 28($sp) 	
     	
     	lw $t0, 0($sp)	#max
     	lw $t1, 0($sp)	#min
     	li $t2, 0
     loop:
     	lw $t4, 0($sp)
     	slt $t5, $t4, $t0
     	beq $t5, $zero, mdfymax
     	slt $t5, $t4, $t1
     	bne $t5, $zero, mdfymin
     	beq $sp, $fp, print
	addi $t2, $t2, 1
	addi $sp, $sp, 4
     	j loop
     	
     mdfymax:
     	addi $t0, $t4, 0
     	addi $t7, $t2, 0
        addi $t2, $t2, 1
	addi $sp, $sp, 4
     	j loop
     	
     mdfymin: 
     	addi $t1, $t4, 0
     	addi $t8, $t2, 0
        addi $t2, $t2, 1   
	addi $sp, $sp, 4  	
     	j loop
     		