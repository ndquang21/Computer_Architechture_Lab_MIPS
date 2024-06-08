.data
	Message: .asciiz "Nhap so nguyen:”
	A: .word
.text
	main: 	
		la $a0, A
		li $t9, 0		# biến đếm
		li $v0, 5		# nhập số phần tử của mảng
		syscall
		move $t6, $v0		# lưu số phần tử của mảng
	
	loop_nhập_số_nguyên:	# nhập từng phần tử vào mảng
		li $v0, 51
		la $a0, Message
		syscall
	
		move $t7, $a0		# lấy phần tử vừa nhập lưu vào $t7
		la $a0, A		# trả lại địa chỉ đầu dãy cho $a0
	
		beq $a1, -2, sap_xep	# enter ko điền gì thì kết thúc nhập
 		beq $a1, -3, sap_xep	# cancel thì kết thúc nhập
 	
 		add $t8, $t9, $t9	# lưu phần tử vừa nhập trong $t7 vào dãy A
 		add $t8, $t8, $t8
 		add $t8, $t8, $a0
 		sw $t7, 0($t8)

 		addi $t9, $t9, 1	# i++
  		beq $t9, $t6, sap_xep	# đủ số phần tử thì kết thúc nhập
		j loop_nhập_số_nguyên

	sap_xep:
		addi $a2, $t8, 4	# $a2 lưu địa chỉ cuối mảng A (phục vụ vòng lặp print)
 		move $a1, $t8 		#$a1 = Address(A[n-1]) = địa chỉ của phần tử cuối cùng dãy A
 		j sort 			#sort
	after_sort: 
		li $v0, 10 	#exit
 		syscall
	end_main:
	sort: 
		beq $s6,$t6,done 	# $ địa chỉ phần tử âm cuối cùng bằng địa chỉ phần từ âm đầu tiên thì đã duyệt xong
 		j min1 			#nhảy đến hàm tìm số âm bé nhất
	after_min: 		#đổi chỗ (min) với phần tử âm cuối dãy
		lw $t0,0($t6) 		#load last element into $t0
 		sw $t0,0($v0) 		#copy last element to min location
 		sw $v1,0($t6) 		#copy min value to last element
 		add $a1, $t6, -4	#dãy mới là dãy đến trước số âm cuối cùng
 		
 		print: 			# in dãy
 		li $s1, 0
 		la $s0, A
 		loop2:
 			add $s2, $s1, $s1
 			add $s2, $s2, $s2
 			add $t3, $s0, $s2
 			lw $t4, 0($t3)
 		 	beq $t3, $a2, endloop
 		 	
 			li $v0, 1
 			move $a0, $t4
 			syscall
 			
 			li $v0, 11
 			li $a0, ' '
 			syscall
 			
 			addi $s1, $s1, 1
 			j loop2
 		endloop:
 		li $v0, 11
 		li $a0, 0x0000000a
 		syscall
 		la $a0, A	
 		
 		beq $s4, 1, done	# nếu biến kiểm tra = 1 nghĩa là không có số âm trong dãy, in dãy và kết thúc chương trình luôn
 
 		j sort 			#repeat sort for smaller list
	done: 	j after_sort
	min1:
		li $s7, 0		# biến đếm i
		li $s4, 0
	tim_so_am:			# tìm số âm đầu tiên trong mảng
		add $s6, $s7, $s7	
		add $s6, $s6, $s6
		add $s6, $a0, $s6
		lw $s5, 0($s6)		
		bltz $s5, min2		# $s6 là địa chỉ số âm đầu tiên trong mảng và nhảy đến min2
		beq $s6, $t8, tang_bien_kiem_tra	# nếu đã duyệt đến cuối mà ko có số âm	
		addi $s7, $s7, 1
		j tim_so_am
	tang_bien_kiem_tra:
		addi $s4, $zero, 1	# $s4 là biến kiểm tra, nếu ko có số âm thì $s4 = 1
		j print
	min2:
		addi $v0,$s6,0 	# chọn số âm đầu tiên là số bé nhất (chọn địa chỉ)
		lw $v1,0($v0) 	# (chọn giá trị)
		addi $t0,$a0,0 	# init next pointer to first
	loop:
		beq $t0,$a1,ret #nếu next đã duyệt đến last, nhảy đến ret
		addi $t0,$t0,4  #tăng đến phần tử tiếp theo
		lw $t1,0($t0)  	#lấy giá trị của phần tử đó lưu vào $t1
		bgtz $t1, loop	# kiểm tra giá trị đó có âm ko? ko âm thì duyệt tiếp số tiếp theo
		beqz $t1, loop
		move $t6, $t0 	# chọn làm số âm cuối cùng trong dãy
		
		slt $t2,$t1,$v1 # kiểm tra xem phần tử đó có bé hơn min ko (next)<(min) ?
		beq $t2,$zero,loop #nếu (next)>(min), quay lại vòng lặp để duyệt số tiếp theo
		addi $v0,$t0,0 	# nếu (next)<(min) thì cập nhật (min)
		addi $v1,$t1,0 	#next value is new min value
		j loop 		#change completed; now repeat
	ret:
		j after_min
