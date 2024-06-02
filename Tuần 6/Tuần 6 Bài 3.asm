.data 
	A: .word  111, 34, -23, 43, 12, 0, 9, 4, 2, -34
	Aend: .word
.text
		la $a0, A		# $a0 = Address(A[0])
		la $a1, Aend
		la $a2, Aend
		addi $a1, $a1, -4	# $a1 = Address(A[n-1]) = địa chỉ của phần tử cuối cùng dãy A
		move $a3, $a1
		j sort			# sort
	after_sort:
		li $v0, 10 #exit
 		syscall
	end_main:
	sort:		li $s0, 0		# i
			move $t7, $a1		# $t7 lưu địa chỉ A[n-1]
		loop: 	
			beq $t7, $a0, end_loop	
			add $t0, $s0, $s0	
			add $t0, $t0, $t0
			add $t1, $a0, $t0
			lw $t2, 0($t1)		# A[i]
			addi $t3, $t1, 4
			lw $t4, 0($t3)		# A[i+1]
			slt $t5, $t2, $t4	# so sánh A[i] với A[i+1]
			bne $t5, $zero, tang_$s0 # A[i] < A[i+1] thì i++
			
			move $t6, $t4		# swap
			move $t4, $t2
			move $t2, $t6
			sw $t2, 0($t1)
			sw $t4, 0($t3)

			addi $s0, $s0, 1
			addi $t7, $t7, -4
			j loop
		tang_$s0: 
			addi $s0, $s0, 1	# i++
			addi $t7, $t7, -4
			j loop
		end_loop:
			addi $a3, $a3, -4
		#print
 		print: 	li $s1, 0		# in
 		   	la $s4, A
 		    print_char:
 			add $s2, $s1, $s1
 			add $s2, $s2, $s2
 			add $s3, $s4, $s2
 			lw $s5, 0($s3)
 		 	beq $s3, $a2, in_xuong_dong
 		 	
 			li $v0, 1
 			move $a0, $s5
 			syscall
 			addi $s6, $a2, -4
 			beq $s3, $s6, qua
 			li $v0, 11
 			li $a0, ' '
 			syscall
 			qua:
 			addi $s1, $s1, 1
 			j print_char
 		   in_xuong_dong:
 			li $v0, 11		#in xuống dòng
 			li $a0, '\n'
 			syscall
 			la $a0, A
 		#print xong
			beq $a3, $a0, after_sort
		j sort 
		
		
		

		
	  	 
	 
