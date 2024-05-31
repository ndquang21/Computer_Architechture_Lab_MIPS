.data
	A: .word 2, 6, 1, 3, 2
.text
	main: 	la $a0,A
 		li $a1,5
		j mspfx
 		nop
	continue:
	lock: 	j lock
		nop
	end_of_main:
#-----------------------------------------------------------------
#Procedure mspfx
# @brief find the maximum-sum prefix in a list of integers
# @param[in] a0 lưu base address của dãy A
# @param[in] a1 kuwu số số hạng trong dãy A (là n)
# @param[out] v0 lưu độ dài của chuỗi con có tổng lớn nhất trong dãy (chuỗi con được tính từ phần tử đầu tiên)
# @param[out] v1 the max sum of a certain sub-array
#-----------------------------------------------------------------
#Procedure mspfx
#function: find the maximum-sum prefix in a list of integers
#base address của list(A) lưu trong $a0 và số phần tử được lưu trong $a1
	mspfx: 	addi $v0,$zero,0 # khởi tạo giá trị độ dài trong $v0 = 0 ($v0 lưu độ dài của chuỗi con có tổng lớn nhất)
 		addi $v1,$zero,0 # khởi tạo tổng lớn nhất trong $v1 = 0 ($v1 lưu tổng của chuỗi con đó)
 		addi $t0,$zero,0 # khởi tạo biến i trong $t0 = 0
 		addi $t1,$zero,0 # khởi tạo tổng "tạm" trong $t1 = 0
	loop: 	add $t2,$t0,$t0 # lưu 2i vào $t2
 		add $t2,$t2,$t2 # lưu 4i vào $t2
		add $t3,$t2,$a0 # lưu 4i+A (địa chỉ A[i]) vào $t3
		lw $t4,0($t3)   # load A[i] từ thanh ghi $t3 -> $t4 (lấy giá trị từ địa chỉ mà thanh ghi $t3 đang lưu, ở đây là giá trị A[i])
		add $t1,$t1,$t4 # cộng A[i] vào tổng "tạm" trong $t1
		slt $t5,$v1,$t1 # set $t5 thành 1 / 0 nếu tổng max < tổng "tạm"
		bne $t5,$zero,modify # nếu tổng max bé hơn, đổi lại tổng "tạm" -> tổng max (nhảy đến modify để đổi)
		j test #done?
	modify: addi $v0,$t0,1 #new max-sum prefix có độ dài độ dài mới là i+1
		addi $v1,$t1,0 #new max sum ($v1) được đổi thành tổng hiện tại đang tính ($t1)
	test: 	addi $t0,$t0,1 #tăng biến i thêm 1
		slt $t5,$t0,$a1 #set $t5 thành 1 / 0 nếu i < n ($t0 < $a1)
		bne $t5,$zero,loop #tiếp tục vòng lặp nếu i < n
	done: 	j continue
	mspfx_end:
