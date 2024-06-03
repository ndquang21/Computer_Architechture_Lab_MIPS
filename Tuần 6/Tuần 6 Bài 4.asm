.data
	A: .word 4, 3, 2, 6, 2, 0, 2
	Aend: .word
.text
		la $a0, A			# $a0 lưu địa chỉ A[0]
		la $a1, Aend			
		add $a2, $a0, 4			# $a2 lưu địa chỉ A[1]
		la $a3, Aend			
		add $a1, $a1, -4		# $a1 lưu địa chỉ A[n-1]
		j sort
	after_sort:
		li $v0, 10 #exit
 		syscall
	end_main:
	sort:
		li $s0, 1			# i
		loop:
		li $s1, 0			# biến kiểm tra xem có cần chèn ko?		
		add $t0, $s0, $s0		
		add $t0, $t0, $t0
		add $t0, $a0, $t0		# lấy địa chỉ của phần tử A[i]
		addi $t2, $t0, -4		# lấy địa chỉ của phần tử A[j] (j = i - 1)
		move $t5, $t0			# $t5 lưu vị trí sẽ chèn (khởi tạo tại chính vị trí A[i])
	     loop1:
		lw $t1, 0($t0)			# $t1 lưu giá trị A[i]
		lw $t3, 0($t2)			# $t3 lưu giá trị A[j]
		slt $t4, $t1, $t3		# nếu A[j] < A[i]
		beq $t4, $zero, tru_tiep	# thì nhảy đến j--
		move $t5, $t2 			# A[j] > A[j] thì vị trí chèn sẽ là $t2
		li $s1, 1			# biến kiểm tra = 1
		
	     tru_tiep:				# j--
		beq $t2, $a0, chen		# nếu j-- đã đến vị trí A[0]thì bắt đầu chèn
		addi $t2, $t2, -4		# j--
		j loop1
		
	     chen:
		beq $s1, 0, print		# kiểm tra xem A[i] đã đúng vị trí chưa? Nếu $s1 = 0 thì đã đúng và in dãy luôn
	     loop_chen:
		addi $t0, $t0, -4		# A[j]
		lw $s2, 0($t0)			# lưu A[j] vào vị trí A[i]
		sw $s2, 4($t0)
		bne $t0, $t5, loop_chen		# nếu A[j] chưa phải vị trí cần chèn thì tiếp tục
		sw $t1, 0($t5)			# nếu đã đến vị trí chèn thì thực hiện chèn A[i]
		
	     #print
 	     print: 	li $s4, 0		# in
 		    print_char:			
 	 		la $a0, A	    
 			add $s5, $s4, $s4
 			add $s5, $s5, $s5
 			add $s5, $a0, $s5
 			lw $s6, 0($s5)
 		 	beq $s5, $a3, in_xuong_dong
 		 	
 			li $v0, 1
 			move $a0, $s6
 			syscall
 			addi $s7, $a3, -4
 			beq $s5, $s7, skip
 			li $v0, 11
 			li $a0, ' '
 			syscall
 			skip:
 			addi $s4, $s4, 1
 			j print_char
 		   in_xuong_dong:
 			li $v0, 11		#in xuống dòng
 			li $a0, '\n'
 			syscall
 			la $a0, A
 		#print xong
		beq $a1, $a2, after_sort	# thực hiện vòng lặp đến A[n-1]
		addi $s0, $s0, 1		# i++
		addi $a2, $a2, 4		# tăng $a2, thực hiện kiểm tra tiếp A[2]
		j loop
