.data
	A: .word 7, -2, 5,0,8,8,59,5
	Aend: .word 
.text
	main: 	la $a0,A 	#$a0 = Address(A[0])
		la $a1,Aend
		la $a2,Aend
 		addi $a1,$a1,-4 #$a1 = Address(A[n-1]) = địa chỉ của phần tử cuối cùng dãy A
 		j sort 		#sort
	after_sort: 
		li $v0, 10 	#exit
 		syscall
	end_main:
#procedure sort (ascending selection sort using pointer)
#register usage in sort program
#$a0 pointer to the first element in unsorted part
#$a1 pointer to the last element in unsorted part
#$t0 temporary place for value of last element
#$v0 pointer to max element in unsorted part
#$v1 value of max element in unsorted part
	sort: 
		beq $a0,$a1,done 	# $a0 = $a1 thì xong
 		j max 			#nhảy đến hàm tìm số lớn nhất
	after_max: 		#đổi chỗ (max) với phần tử cuối dãy
		lw $t0,0($a1) 		#load last element into $t0
 		sw $t0,0($v0) 		#copy last element to max location
 		sw $v1,0($a1) 		#copy max value to last element
 		addi $a1,$a1,-4 	#decrement pointer to last element
 		
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
 
 		j sort 			#repeat sort for smaller list
	done: 	j after_sort
#Procedure max
#function: fax the value and address of max element in the list
#$a0 pointer to first element
#$a1 pointer to last element
	max:
		addi $v0,$a0,0 	# chọn số đầu dãy làm số lớn nhất (chọn địa chỉ)
		lw $v1,0($v0) 	# (chọn giá trị)
		addi $t0,$a0,0 	# init next pointer to first
	loop:
		beq $t0,$a1,ret #nếu next đã duyệt đến last, nhảy đến ret
		addi $t0,$t0,4  #tăng đến phần tử tiếp theo
		lw $t1,0($t0)  	#lấy giá trị của phần tử đó lưu vào $t1
		slt $t2,$t1,$v1 #kiểm tra xem phần tử đó có lớn hơn max ko (next)<(max) ?
		bne $t2,$zero,loop #nếu (next)<(max), quay lại vòng lặp để duyệt số tiếp theo
		addi $v0,$t0,0 	# nếu (next)>(max) thì cập nhật (max)
		addi $v1,$t1,0 	#next value is new max value
		j loop 		#change completed; now repeat
	ret:
		j after_max
